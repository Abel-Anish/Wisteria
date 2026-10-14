import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';
import 'package:image/image.dart' as img;

class PneumoniaInferenceResult {
  final String prediction;
  final double confidence;
  final double normalProbability;
  final double pneumoniaProbability;
  final DateTime executedAt;

  const PneumoniaInferenceResult({
    required this.prediction,
    required this.confidence,
    required this.normalProbability,
    required this.pneumoniaProbability,
    required this.executedAt,
  });
}

/// Inference result from the Brain Tumor ResNet18 model.
///
/// Class order matches training (PyTorch ImageFolder alphabetical order):
///   index 0 = glioma
///   index 1 = meningioma
///   index 2 = notumor
///   index 3 = pituitary
class BrainTumorInferenceResult {
  final String prediction;
  final double confidence;
  final double gliomaScore;
  final double meningiomaScore;
  final double noTumorScore;
  final double pituitaryScore;
  final DateTime executedAt;

  const BrainTumorInferenceResult({
    required this.prediction,
    required this.confidence,
    required this.gliomaScore,
    required this.meningiomaScore,
    required this.noTumorScore,
    required this.pituitaryScore,
    required this.executedAt,
  });
}

class OnnxInferenceService {
  OnnxInferenceService._();

  static final OnnxInferenceService instance = OnnxInferenceService._();

  static const String modelAsset = 'assets/models/pneumonia_resnet18.onnx';

  static const int inputSize = 224;

  static const List<double> mean = [0.485, 0.456, 0.406];

  static const List<double> std = [0.229, 0.224, 0.225];

  final OnnxRuntime _runtime = OnnxRuntime();

  OrtSession? _session;
  bool _isInitializing = false;

  bool get isInitialized => _session != null;

  Future<void> initialize() async {
    if (_session != null) return;

    if (_isInitializing) {
      // Avoid accidentally creating two sessions.
      while (_isInitializing) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }

      if (_session != null) return;
    }

    _isInitializing = true;

    try {
      final session = await _runtime.createSessionFromAsset(modelAsset);

      if (session.inputNames.isEmpty || session.outputNames.isEmpty) {
        await session.close();
        throw StateError('The ONNX model has no input or output tensors.');
      }

      _session = session;
    } finally {
      _isInitializing = false;
    }
  }

  Future<PneumoniaInferenceResult> analyzeImage(File imageFile) async {
    await initialize();

    final session = _session!;

    if (!await imageFile.exists()) {
      throw ArgumentError('The selected image does not exist.');
    }

    final bytes = await imageFile.readAsBytes();
    final decoded = img.decodeImage(bytes);

    if (decoded == null) {
      throw const FormatException('Could not decode the selected image.');
    }

    final resized = img.copyResize(
      decoded,
      width: inputSize,
      height: inputSize,
    );

    final inputData = Float32List(3 * inputSize * inputSize);

    final planeSize = inputSize * inputSize;

    // NCHW layout: [1, 3, 224, 224].
    for (var y = 0; y < inputSize; y++) {
      for (var x = 0; x < inputSize; x++) {
        final pixel = resized.getPixel(x, y);
        final index = y * inputSize + x;

        final red = pixel.r.toDouble() / 255.0;
        final green = pixel.g.toDouble() / 255.0;
        final blue = pixel.b.toDouble() / 255.0;

        inputData[index] = (red - mean[0]) / std[0];

        inputData[planeSize + index] = (green - mean[1]) / std[1];

        inputData[(2 * planeSize) + index] = (blue - mean[2]) / std[2];
      }
    }

    final inputName = session.inputNames.first;
    final outputName = session.outputNames.first;

    final inputTensor = await OrtValue.fromList(inputData, [
      1,
      3,
      inputSize,
      inputSize,
    ]);

    Map<String, OrtValue>? outputs;

    try {
      outputs = await session.run({inputName: inputTensor});

      final outputTensor = outputs[outputName];

      if (outputTensor == null) {
        throw StateError('The model did not return the expected output.');
      }

      final rawOutput = await outputTensor.asList();
      final logits = _flattenNumbers(rawOutput);

      if (logits.length != 2) {
        throw StateError(
          'Expected 2 classification outputs, '
          'but received ${logits.length}. '
          'Check the model output contract.',
        );
      }

      final probabilities = _softmax(logits);

      // Class order must match the order used during training.
      const normalIndex = 0;
      const pneumoniaIndex = 1;

      final normalProbability = probabilities[normalIndex];

      final pneumoniaProbability = probabilities[pneumoniaIndex];

      final isPneumonia = pneumoniaProbability >= normalProbability;

      final confidence = isPneumonia ? pneumoniaProbability : normalProbability;

      return PneumoniaInferenceResult(
        prediction: isPneumonia ? 'PNEUMONIA' : 'NORMAL',
        confidence: confidence,
        normalProbability: normalProbability,
        pneumoniaProbability: pneumoniaProbability,
        executedAt: DateTime.now(),
      );
    } finally {
      inputTensor.dispose();

      if (outputs != null) {
        for (final output in outputs.values) {
          output.dispose();
        }
      }
    }
  }

  List<double> _flattenNumbers(dynamic value) {
    final numbers = <double>[];

    void visit(dynamic item) {
      if (item is num) {
        numbers.add(item.toDouble());
      } else if (item is List) {
        for (final child in item) {
          visit(child);
        }
      } else {
        throw FormatException(
          'Unexpected model output type: '
          '${item.runtimeType}',
        );
      }
    }

    visit(value);
    return numbers;
  }

  List<double> _softmax(List<double> logits) {
    final maxLogit = logits.reduce(math.max);

    final exponentials = logits
        .map((value) => math.exp(value - maxLogit))
        .toList();

    final sum = exponentials.reduce((a, b) => a + b);

    return exponentials.map((value) => value / sum).toList();
  }

  Future<void> dispose() async {
    final session = _session;
    _session = null;

    await session?.close();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Brain Tumor Inference Service
// ─────────────────────────────────────────────────────────────────────────────

/// ONNX inference service for the Brain Tumor ResNet18 model.
///
/// Preprocessing (per notebook):
///   • Resize to 224×224 (bilinear, default)
///   • Convert to RGB
///   • Normalize per channel: mean=[0.485,0.456,0.406], std=[0.229,0.224,0.225]
///   • Layout: NCHW [1, 3, 224, 224], float32
///
/// Output: raw logits [1, 4]
///   • No softmax is applied inside the model; softmax is applied here
///     to produce per-class probabilities for display only.
///   • Class index → label (alphabetical, matching PyTorch ImageFolder):
///       0 = glioma
///       1 = meningioma
///       2 = notumor
///       3 = pituitary
class BrainTumorInferenceService {
  BrainTumorInferenceService._();

  static final BrainTumorInferenceService instance =
      BrainTumorInferenceService._();

  static const String modelAsset = 'assets/models/brain_tumor_resnet18.onnx';

  static const int inputSize = 224;

  /// ImageNet mean per channel (R, G, B).
  static const List<double> mean = [0.485, 0.456, 0.406];

  /// ImageNet standard deviation per channel (R, G, B).
  static const List<double> std = [0.229, 0.224, 0.225];

  /// Class labels in the exact order produced by PyTorch ImageFolder
  /// (sorted alphabetically from the training directory names).
  static const List<String> classLabels = [
    'glioma', // index 0
    'meningioma', // index 1
    'notumor', // index 2
    'pituitary', // index 3
  ];

  /// Human-readable display names for each class index.
  static const List<String> classDisplayNames = [
    'Glioma',
    'Meningioma',
    'No Tumor',
    'Pituitary',
  ];

  final OnnxRuntime _runtime = OnnxRuntime();

  OrtSession? _session;
  bool _isInitializing = false;

  bool get isInitialized => _session != null;

  Future<void> initialize() async {
    if (_session != null) return;

    if (_isInitializing) {
      while (_isInitializing) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
      if (_session != null) return;
    }

    _isInitializing = true;

    try {
      final session = await _runtime.createSessionFromAsset(modelAsset);

      if (session.inputNames.isEmpty || session.outputNames.isEmpty) {
        await session.close();
        throw StateError(
          'The Brain Tumor ONNX model has no input or output tensors.',
        );
      }

      _session = session;
    } finally {
      _isInitializing = false;
    }
  }

  /// Runs inference on [imageFile] and returns a [BrainTumorInferenceResult].
  ///
  /// Throws if the file is missing, cannot be decoded, or the model output
  /// is malformed. Never returns fabricated results.
  Future<BrainTumorInferenceResult> analyzeImage(File imageFile) async {
    await initialize();

    final session = _session!;

    if (!await imageFile.exists()) {
      throw ArgumentError('The selected image file does not exist.');
    }

    final bytes = await imageFile.readAsBytes();
    final decoded = img.decodeImage(bytes);

    if (decoded == null) {
      throw const FormatException('Could not decode the selected image file.');
    }

    // Resize to 224×224.
    final resized = img.copyResize(
      decoded,
      width: inputSize,
      height: inputSize,
    );

    // Build NCHW float32 tensor.
    final inputData = Float32List(3 * inputSize * inputSize);
    final planeSize = inputSize * inputSize;

    for (var y = 0; y < inputSize; y++) {
      for (var x = 0; x < inputSize; x++) {
        final pixel = resized.getPixel(x, y);
        final index = y * inputSize + x;

        final red = pixel.r.toDouble() / 255.0;
        final green = pixel.g.toDouble() / 255.0;
        final blue = pixel.b.toDouble() / 255.0;

        inputData[index] = (red - mean[0]) / std[0];
        inputData[planeSize + index] = (green - mean[1]) / std[1];
        inputData[(2 * planeSize) + index] = (blue - mean[2]) / std[2];
      }
    }

    final inputName = session.inputNames.first; // 'image'
    final outputName = session.outputNames.first; // 'output'

    final inputTensor = await OrtValue.fromList(inputData, [
      1,
      3,
      inputSize,
      inputSize,
    ]);

    Map<String, OrtValue>? outputs;

    try {
      outputs = await session.run({inputName: inputTensor});

      final outputTensor = outputs[outputName];

      if (outputTensor == null) {
        throw StateError(
          'The Brain Tumor model did not return the expected output tensor.',
        );
      }

      final rawOutput = await outputTensor.asList();
      final logits = _flattenNumbers(rawOutput);

      if (logits.length != 4) {
        throw StateError(
          'Expected 4 classification outputs (glioma, meningioma, notumor, '
          'pituitary), but received ${logits.length}. '
          'Check the model output contract.',
        );
      }

      // Validate outputs: reject NaN / Infinity values.
      for (final v in logits) {
        if (v.isNaN || v.isInfinite) {
          throw StateError(
            'Brain Tumor model produced invalid output values (NaN or Infinity). '
            'The model output is rejected.',
          );
        }
      }

      // Convert raw logits → probabilities.
      final probabilities = _softmax(logits);

      // Predicted class is the argmax over probabilities
      // (softmax preserves relative ordering of logits).
      var predictedIndex = 0;
      var maxProb = probabilities[0];
      for (var i = 1; i < probabilities.length; i++) {
        if (probabilities[i] > maxProb) {
          maxProb = probabilities[i];
          predictedIndex = i;
        }
      }

      return BrainTumorInferenceResult(
        prediction: classLabels[predictedIndex],
        confidence: maxProb,
        gliomaScore: probabilities[0],
        meningiomaScore: probabilities[1],
        noTumorScore: probabilities[2],
        pituitaryScore: probabilities[3],
        executedAt: DateTime.now(),
      );
    } finally {
      inputTensor.dispose();

      if (outputs != null) {
        for (final output in outputs.values) {
          output.dispose();
        }
      }
    }
  }

  List<double> _flattenNumbers(dynamic value) {
    final numbers = <double>[];

    void visit(dynamic item) {
      if (item is num) {
        numbers.add(item.toDouble());
      } else if (item is List) {
        for (final child in item) {
          visit(child);
        }
      } else {
        throw FormatException(
          'Unexpected Brain Tumor model output type: ${item.runtimeType}',
        );
      }
    }

    visit(value);
    return numbers;
  }

  List<double> _softmax(List<double> logits) {
    final maxLogit = logits.reduce(math.max);
    final exponentials = logits.map((v) => math.exp(v - maxLogit)).toList();
    final sum = exponentials.reduce((a, b) => a + b);
    return exponentials.map((v) => v / sum).toList();
  }

  Future<void> dispose() async {
    final session = _session;
    _session = null;
    await session?.close();
  }
}
