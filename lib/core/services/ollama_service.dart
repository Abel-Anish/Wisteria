import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Reusable service for communicating with a local Ollama instance.
///
/// Sends chat completions to the Ollama REST API and returns either
/// a progressive stream of response chunks or the full assistant text.
/// All inference runs locally — no cloud services, API keys, or external
/// backends are involved.
class OllamaService {
  /// Base URL for the Ollama API (default local install).
  final String baseUrl;

  /// Model identifier to use for chat completions.
  final String model;

  /// HTTP request connection and socket timeout.
  final Duration timeout;

  OllamaService({
    this.baseUrl = 'http://localhost:11434',
    this.model = 'gemma3:4b',
    this.timeout = const Duration(seconds: 120),
  });

  /// Streams response text chunks from Ollama's `/api/chat` endpoint
  /// using `"stream": true`.
  ///
  /// Incremental chunks split across network boundaries are buffered
  /// and split by [LineSplitter], then decoded as individual JSON objects.
  /// Text from `message.content` is yielded as it arrives.
  ///
  /// Throws [OllamaException] on network errors, timeout, server errors,
  /// or malformed responses.
  Stream<String> chatStream(List<Map<String, String>> messages) async* {
    final uri = Uri.parse('$baseUrl/api/chat');
    final payload = {
      'model': model,
      'messages': messages,
      'stream': true,
    };
    final body = jsonEncode(payload);

    HttpClient? client;
    try {
      client = HttpClient();
      client.connectionTimeout = timeout;

      final request = await client.postUrl(uri).timeout(timeout);
      request.headers.set(
        HttpHeaders.contentTypeHeader,
        'application/json; charset=utf-8',
      );
      // Explicitly send UTF-8 bytes to support emojis and unicode in history
      request.add(utf8.encode(body));

      final response = await request.close().timeout(timeout);

      if (response.statusCode != 200) {
        final errorBody = await response
            .transform(utf8.decoder)
            .join()
            .timeout(const Duration(seconds: 5), onTimeout: () => '');
        String errorMessage = 'Ollama error (${response.statusCode})';
        try {
          final parsed = jsonDecode(errorBody);
          if (parsed is Map<String, dynamic> && parsed['error'] != null) {
            errorMessage = parsed['error'].toString();
          }
        } catch (_) {
          if (errorBody.isNotEmpty && errorBody.length < 200) {
            errorMessage = errorBody;
          }
        }
        throw OllamaException(
          errorMessage,
          type: OllamaErrorType.serverError,
        );
      }

      // Stream decoder handles multi-byte UTF-8 split across packets,
      // and LineSplitter buffers lines split across network chunks.
      final lines = response
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty) continue;

        final dynamic json;
        try {
          json = jsonDecode(trimmed);
        } catch (e) {
          throw OllamaException(
            'Malformed JSON chunk from Ollama.',
            type: OllamaErrorType.malformedResponse,
          );
        }

        if (json is Map<String, dynamic>) {
          if (json.containsKey('error')) {
            throw OllamaException(
              json['error']?.toString() ?? 'Unknown Ollama error',
              type: OllamaErrorType.serverError,
            );
          }

          final message = json['message'];
          if (message is Map<String, dynamic>) {
            final content = message['content'];
            if (content is String && content.isNotEmpty) {
              yield content;
            }
          }

          if (json['done'] == true) {
            break;
          }
        }
      }
    } on SocketException catch (e) {
      throw OllamaException(
        'Cannot connect to Ollama at $baseUrl. Make sure Ollama is running.\n'
        '${e.osError?.message ?? e.message}',
        type: OllamaErrorType.connectionFailed,
      );
    } on TimeoutException catch (_) {
      throw OllamaException(
        'Request to Ollama timed out after ${timeout.inSeconds}s.',
        type: OllamaErrorType.timeout,
      );
    } on FormatException catch (e) {
      throw OllamaException(
        'Malformed JSON from Ollama: ${e.message}',
        type: OllamaErrorType.malformedResponse,
      );
    } catch (e) {
      if (e is OllamaException) rethrow;
      throw OllamaException(
        'Unexpected error communicating with Ollama: $e',
        type: OllamaErrorType.unknown,
      );
    } finally {
      client?.close(force: true);
    }
  }

  /// Non-streaming chat completion for fallback or simple requests.
  Future<String> chat(List<Map<String, String>> messages) async {
    final buffer = StringBuffer();
    await for (final chunk in chatStream(messages)) {
      buffer.write(chunk);
    }
    return buffer.toString();
  }

  /// Checks whether Ollama is reachable at [baseUrl].
  Future<bool> isAvailable() async {
    HttpClient? client;
    try {
      client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 3);
      final request = await client
          .getUrl(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 3));
      final response =
          await request.close().timeout(const Duration(seconds: 3));
      await response.drain<void>();
      return response.statusCode == 200;
    } catch (_) {
      return false;
    } finally {
      client?.close(force: true);
    }
  }
}

/// Classification of Ollama errors for UI display.
enum OllamaErrorType {
  connectionFailed,
  timeout,
  serverError,
  malformedResponse,
  unknown,
}

/// Exception thrown by [OllamaService] operations.
class OllamaException implements Exception {
  final String message;
  final OllamaErrorType type;

  const OllamaException(this.message, {this.type = OllamaErrorType.unknown});

  @override
  String toString() => 'OllamaException($type): $message';
}
