import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/database/repositories/medical_model_repository.dart';
import '../../core/services/onnx_inference_service.dart';
import '../../core/theme/wisteria_theme.dart';

/// Discriminator for which model is active in this test session.
enum _ActiveModel { pneumonia, brainTumor }

/// Model-aware ONNX inference test page.
///
/// Pass [modelId] from the model management screen. The page resolves the
/// correct inference service, preprocessing, and result UI automatically.
///
/// Supported [modelId] values:
///   • [MedicalModelRepository.bundledModelId]  → Pneumonia ResNet18
///   • [MedicalModelRepository.brainTumorModelId] → Brain Tumor ResNet18
class ModelInferenceTestPage extends StatefulWidget {
  /// The stable model ID from [MedicalModelRepository] / [SystemModelCatalog].
  final String modelId;

  const ModelInferenceTestPage({super.key, required this.modelId});

  @override
  State<ModelInferenceTestPage> createState() => _ModelInferenceTestPageState();
}

class _ModelInferenceTestPageState extends State<ModelInferenceTestPage> {
  // ── Active model resolution ──
  late final _ActiveModel _model;

  // ── UI state ──
  File? _selectedImage;
  bool _loadingModel = false;
  bool _runningInference = false;
  String? _error;

  // Results — exactly one will be non-null after a successful run.
  PneumoniaInferenceResult? _pneumoniaResult;
  BrainTumorInferenceResult? _brainTumorResult;

  @override
  void initState() {
    super.initState();
    // Resolve the active model from the ID.
    if (widget.modelId == MedicalModelRepository.brainTumorModelId) {
      _model = _ActiveModel.brainTumor;
    } else {
      // Default + explicit pneumonia model ID.
      _model = _ActiveModel.pneumonia;
    }
  }

  // ── Helpers ──

  String get _modelDisplayName => switch (_model) {
        _ActiveModel.pneumonia => 'Pneumonia ResNet18',
        _ActiveModel.brainTumor => 'Brain Tumor ResNet18',
      };

  String get _modalityLabel => switch (_model) {
        _ActiveModel.pneumonia => 'Chest X-ray',
        _ActiveModel.brainTumor => 'Brain MRI',
      };

  String get _pickImageLabel => switch (_model) {
        _ActiveModel.pneumonia => 'Choose X-ray image',
        _ActiveModel.brainTumor => 'Choose MRI image',
      };

  String get _modelDescription => switch (_model) {
        _ActiveModel.pneumonia =>
          'Binary classification of chest X-ray images.\n'
              'Classes: NORMAL, PNEUMONIA\n'
              'Architecture: ResNet-18 · Runtime: ONNX · v1.0.0',
        _ActiveModel.brainTumor =>
          'Four-class brain tumor classification from MRI images.\n'
              'Classes: Glioma, Meningioma, No Tumor, Pituitary\n'
              'Architecture: ResNet-18 · Runtime: ONNX · v1.0.0',
      };

  bool get _hasResult =>
      _pneumoniaResult != null || _brainTumorResult != null;

  // ── Actions ──

  Future<void> _pickImage() async {
    final picked = await FilePicker.pickFile(type: FileType.image);
    if (!mounted || picked == null || picked.path == null) return;

    setState(() {
      _selectedImage = File(picked.path!);
      _pneumoniaResult = null;
      _brainTumorResult = null;
      _error = null;
    });
  }

  Future<void> _runInference() async {
    final image = _selectedImage;
    if (image == null) return;

    setState(() {
      _runningInference = true;
      _loadingModel = true;
      _error = null;
      _pneumoniaResult = null;
      _brainTumorResult = null;
    });

    try {
      switch (_model) {
        case _ActiveModel.pneumonia:
          await _runPneumoniaInference(image);
        case _ActiveModel.brainTumor:
          await _runBrainTumorInference(image);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _loadingModel = false;
          _runningInference = false;
        });
      }
    }
  }

  Future<void> _runPneumoniaInference(File image) async {
    final service = OnnxInferenceService.instance;
    await service.initialize();
    if (!mounted) return;
    setState(() => _loadingModel = false);

    final result = await service.analyzeImage(image);
    if (!mounted) return;
    setState(() => _pneumoniaResult = result);
  }

  Future<void> _runBrainTumorInference(File image) async {
    final service = BrainTumorInferenceService.instance;
    await service.initialize();
    if (!mounted) return;
    setState(() => _loadingModel = false);

    final result = await service.analyzeImage(image);
    if (!mounted) return;
    setState(() => _brainTumorResult = result);
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text('Test Model Inference'),
        backgroundColor: colors.background,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // ── Model identity header ──
              _buildModelHeader(colors),
              const SizedBox(height: 24),

              // ── Image picker ──
              OutlinedButton.icon(
                onPressed: _runningInference ? null : _pickImage,
                icon: const Icon(Icons.image_outlined),
                label: Text(_pickImageLabel),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.primary,
                  side: BorderSide(color: colors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                  ),
                ),
              ),

              if (_selectedImage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _selectedImage!.path,
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: Image.file(
                    _selectedImage!,
                    height: 280,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, err, stack) =>
                        const Text('Image preview unavailable.'),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // ── Run inference button ──
              FilledButton.icon(
                onPressed: _selectedImage == null || _runningInference
                    ? null
                    : _runInference,
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(
                  _loadingModel
                      ? 'Loading model...'
                      : _runningInference
                          ? 'Running inference...'
                          : 'Run inference',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                ),
              ),

              if (_runningInference) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(color: colors.primary),
              ],

              // ── Error ──
              if (_error != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: WisteriaColors.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    border: Border.all(
                      color: WisteriaColors.error.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          size: 18, color: WisteriaColors.error),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SelectableText(
                          'Inference failed:\n$_error',
                          style: const TextStyle(
                            color: WisteriaColors.error,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // ── Results ──
              if (_hasResult) ...[
                const SizedBox(height: 24),
                Divider(color: colors.border),
                const SizedBox(height: 12),
                Text(
                  'Model Output',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                if (_pneumoniaResult != null)
                  _buildPneumoniaResults(colors, _pneumoniaResult!),
                if (_brainTumorResult != null)
                  _buildBrainTumorResults(colors, _brainTumorResult!),
                const SizedBox(height: 16),
                Text(
                  'Development test only. This output is not a validated '
                  'diagnosis and must not be used to make clinical decisions.',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModelHeader(WisteriaColorPalette colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(WisteriaRadius.md),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                ),
                child: Icon(Icons.memory_rounded,
                    size: 20, color: colors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _modelDisplayName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      'Modality: $_modalityLabel',
                      style: TextStyle(
                          fontSize: 12, color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: WisteriaColors.success.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.zero,
                ),
                child: const Text(
                  'LOCAL',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: WisteriaColors.success,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _modelDescription,
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPneumoniaResults(
    WisteriaColorPalette colors,
    PneumoniaInferenceResult result,
  ) {
    final isPneumonia = result.prediction == 'PNEUMONIA';
    final resultColor =
        isPneumonia ? WisteriaColors.warning : WisteriaColors.success;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Prediction banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: resultColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            border: Border.all(color: resultColor.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Icon(
                isPneumonia
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline_rounded,
                color: resultColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.prediction,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: resultColor,
                    ),
                  ),
                  Text(
                    'Confidence: ${(result.confidence * 100).toStringAsFixed(2)}%',
                    style: TextStyle(
                        fontSize: 13, color: colors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
        _resultRow(colors, 'Predicted class', result.prediction),
        _resultRow(colors, 'Model confidence',
            '${(result.confidence * 100).toStringAsFixed(2)}%'),
        _resultRow(colors, 'NORMAL probability',
            '${(result.normalProbability * 100).toStringAsFixed(2)}%'),
        _resultRow(colors, 'PNEUMONIA probability',
            '${(result.pneumoniaProbability * 100).toStringAsFixed(2)}%'),
        _resultRow(
            colors, 'Executed at', result.executedAt.toLocal().toString()),
      ],
    );
  }

  Widget _buildBrainTumorResults(
    WisteriaColorPalette colors,
    BrainTumorInferenceResult result,
  ) {
    final displayName = BrainTumorInferenceService.classDisplayNames[
        BrainTumorInferenceService.classLabels.indexOf(result.prediction)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Prediction banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            border: Border.all(
                color: colors.primary.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Icon(Icons.psychology_rounded,
                  color: colors.primary, size: 28),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                  Text(
                    'Confidence: ${(result.confidence * 100).toStringAsFixed(2)}%',
                    style: TextStyle(
                        fontSize: 13, color: colors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
        _resultRow(colors, 'Predicted class', displayName),
        _resultRow(colors, 'Model confidence',
            '${(result.confidence * 100).toStringAsFixed(2)}%'),
        _resultRow(colors, 'Glioma probability',
            '${(result.gliomaScore * 100).toStringAsFixed(2)}%'),
        _resultRow(colors, 'Meningioma probability',
            '${(result.meningiomaScore * 100).toStringAsFixed(2)}%'),
        _resultRow(colors, 'No Tumor probability',
            '${(result.noTumorScore * 100).toStringAsFixed(2)}%'),
        _resultRow(colors, 'Pituitary probability',
            '${(result.pituitaryScore * 100).toStringAsFixed(2)}%'),
        _resultRow(
            colors, 'Executed at', result.executedAt.toLocal().toString()),
      ],
    );
  }

  Widget _resultRow(WisteriaColorPalette colors, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SelectableText(
              value,
              style: TextStyle(
                fontSize: 13,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
