// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:wisteria/core/services/ollama_service.dart';

void main() {
  test('Ollama multi-turn streaming 8 consecutive turns test', () async {
    final service = OllamaService();

    final available = await service.isAvailable();
    expect(available, isTrue, reason: 'Ollama must be running on localhost:11434');

    final history = <Map<String, String>>[];

    Future<String> sendPrompt(int turn, String prompt) async {
      print('\n[TURN $turn] User: $prompt');
      history.add({'role': 'user', 'content': prompt});

      final sb = StringBuffer();
      int chunks = 0;
      final sw = Stopwatch()..start();

      await for (final chunk in service.chatStream(history)) {
        chunks++;
        sb.write(chunk);
      }
      sw.stop();

      final response = sb.toString();
      history.add({'role': 'assistant', 'content': response});

      print('  -> Chunks: $chunks in ${sw.elapsedMilliseconds}ms');
      final preview = response.replaceAll('\n', ' ');
      print('  -> Response: ${preview.length > 80 ? "${preview.substring(0, 80)}..." : preview}');
      expect(chunks, greaterThan(0));
      expect(response.isNotEmpty, isTrue);
      return response;
    }

    // Turn 1
    final r1 = await sendPrompt(1, 'hey');
    expect(r1.isNotEmpty, isTrue);

    // Turn 2
    final r2 = await sendPrompt(2, 'give me the code for merge sort in C++');
    expect(r2.toLowerCase().contains('merge'), isTrue);

    // Turn 3
    final r3 = await sendPrompt(3, 'explain the code you just gave me');
    expect(r3.isNotEmpty, isTrue);

    // 5 additional consecutive prompts without refresh
    // Turn 4
    final r4 = await sendPrompt(4, 'What is the time complexity of this algorithm?');
    expect(r4.toLowerCase().contains('o(') || r4.toLowerCase().contains('log'), isTrue);

    // Turn 5
    final r5 = await sendPrompt(5, 'Is it a stable sorting algorithm? Answer in one sentence.');
    expect(r5.isNotEmpty, isTrue);

    // Turn 6
    final r6 = await sendPrompt(6, 'Give me a 3-item list of its disadvantages.');
    expect(r6.isNotEmpty, isTrue);

    // Turn 7
    final r7 = await sendPrompt(7, 'Compare it briefly to QuickSort in one sentence.');
    expect(r7.isNotEmpty, isTrue);

    // Turn 8
    final r8 = await sendPrompt(8, 'What was my very first message in this chat?');
    print('  -> Memory verification: $r8');
    expect(
      r8.toLowerCase().contains('hey') || r8.toLowerCase().contains('hello'),
      isTrue,
      reason: 'Should remember that turn 1 was "hey"',
    );

    // Error recovery test
    final badService = OllamaService(baseUrl: 'http://localhost:59999');
    expect(
      () => badService.chatStream([{'role': 'user', 'content': 'test'}]).first,
      throwsA(isA<OllamaException>()),
    );
  }, timeout: const Timeout(Duration(minutes: 5)));
}
