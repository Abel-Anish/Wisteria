import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';
import '../../core/database/database.dart';
import '../../core/database/repositories/examination_repository.dart';
import '../../core/database/repositories/medical_image_repository.dart';
import '../../core/storage/medical_image_storage.dart';
import '../../core/theme/wisteria_theme.dart';
import '../shared/wisteria_back_button.dart';
import '../../core/database/repositories/medical_model_repository.dart';
import '../../core/database/repositories/model_run_repository.dart';
import '../../core/models/system_model_catalog.dart';
import '../../core/services/onnx_inference_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Allowed modality for each model
// ─────────────────────────────────────────────────────────────────────────────

/// Returns `null` when the image modality is compatible with the model.
/// Returns a human-readable error string when incompatible.
String? _validateModality({
  required String imageModality,
  required String modelModality,
  required String modelDisplayName,
}) {
  final img = imageModality.trim().toLowerCase();
  final mod = modelModality.trim().toLowerCase();

  // Exact match is always valid.
  if (img == mod) return null;

  // Pneumonia model accepts X-Ray only.
  if (mod == 'x-ray' && img != 'x-ray') {
    return 'The $modelDisplayName model requires a chest X-Ray image, '
        'but the selected image has modality "$imageModality". '
        'Please select an X-Ray image.';
  }

  // Brain Tumor model accepts MRI only.
  if (mod == 'mri' && img != 'mri') {
    return 'The $modelDisplayName model requires a brain MRI image, '
        'but the selected image has modality "$imageModality". '
        'Please select an MRI image.';
  }

  return null;
}

// ─────────────────────────────────────────────────────────────────────────────
// Page widget
// ─────────────────────────────────────────────────────────────────────────────

class ExaminationDetailsPage extends StatefulWidget {
  final WisteriaDatabase database;
  final String examinationId;

  const ExaminationDetailsPage({
    super.key,
    required this.database,
    required this.examinationId,
  });

  @override
  State<ExaminationDetailsPage> createState() => _ExaminationDetailsPageState();
}

class _ExaminationDetailsPageState extends State<ExaminationDetailsPage> {
  late final ExaminationRepository _repository;
  late final MedicalImageRepository _imageRepository;
  late final MedicalImageStorage _imageStorage;
  late final MedicalModelRepository _modelRepository;
  late final ModelRunRepository _modelRunRepository;

  List<_InstalledModelChoice> _installedModels = [];
  List<_SavedInference> _savedInferences = [];

  String? _selectedImageId;
  String? _selectedModelVersionId;

  bool _isLoadingInferenceData = true;
  bool _isRunningInference = false;
  String? _inferenceError;
  Examination? _examination;
  List<MedicalImage> _medicalImages = [];
  bool _isLoading = true;
  bool _isAddingImage = false;

  @override
  void initState() {
    super.initState();

    _repository = ExaminationRepository(widget.database);
    _imageRepository = MedicalImageRepository(widget.database);
    _imageStorage = MedicalImageStorage();
    _modelRepository = MedicalModelRepository(widget.database);
    _modelRunRepository = ModelRunRepository(widget.database);
    _loadExamination();
    _loadMedicalImages();
    _loadInferenceData();
  }

  Future<void> _loadExamination() async {
    final examination = await _repository.getExaminationById(
      widget.examinationId,
    );

    if (!mounted) return;

    setState(() {
      _examination = examination;
      _isLoading = false;
    });
  }

  Future<void> _loadMedicalImages() async {
    final images = await _imageRepository.getImagesForExamination(
      widget.examinationId,
    );

    if (!mounted) return;

    setState(() {
      _medicalImages = images;
      if (_selectedImageId == null && images.isNotEmpty) {
        _selectedImageId = images.first.id;
      }
    });
  }

  Future<void> _addMedicalImage() async {
    setState(() {
      _isAddingImage = true;
    });

    try {
      final selectedFile = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'bmp'],
      );

      if (selectedFile == null || selectedFile.path == null) {
        return;
      }

      final examination = _examination;

      if (examination == null) {
        return;
      }

      final modality = await _showModalityDialog();

      if (modality == null) {
        return;
      }

      final clinicalDate = await _showClinicalDateDialog(
        examination.examinationDate,
      );

      if (clinicalDate == null) {
        return;
      }

      final savedPath = await _imageStorage.saveImage(
        patientId: examination.patientId,
        examinationId: examination.id,
        originalFilePath: selectedFile.path!,
      );

      final extension = selectedFile.extension?.toLowerCase() ?? 'unknown';

      await _imageRepository.createMedicalImage(
        id: const Uuid().v4(),
        examinationId: examination.id,
        filePath: savedPath,
        originalFileName: selectedFile.name,
        fileFormat: extension,
        modality: modality,
        clinicalDate: clinicalDate,
      );

      await _loadMedicalImages();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add medical image: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAddingImage = false;
        });
      }
    }
  }

  Future<void> _loadInferenceData() async {
    try {
      final models = await _modelRepository.getAllModels();
      final choices = <_InstalledModelChoice>[];

      for (final model in models) {
        final version = await _modelRepository.getInstalledVersion(model.id);

        if (version == null) continue;

        // Only include models that are in the catalog and supported.
        final catalogEntry = SystemModelCatalog.getById(model.id);
        if (catalogEntry == null || !catalogEntry.isSupported) continue;

        choices.add(
          _InstalledModelChoice(
            model: model,
            version: version,
            catalog: catalogEntry,
          ),
        );
      }

      final runs = await _modelRunRepository.getRunsForExamination(
        widget.examinationId,
      );

      final saved = <_SavedInference>[];

      for (final run in runs) {
        final result = await _modelRunRepository.getResultForRun(run.id);

        if (result == null) continue;

        final findings = await _modelRunRepository.getFindingsForResult(
          result.id,
        );

        final model = await _modelRepository.getModelById(run.modelId);

        saved.add(
          _SavedInference(
            run: run,
            result: result,
            findings: findings,
            modelName: model?.name ?? 'Unknown model',
          ),
        );
      }

      if (!mounted) return;

      setState(() {
        _installedModels = choices;
        _savedInferences = saved;

        // Auto-select the first image if not already selected.
        if (_selectedImageId == null && _medicalImages.isNotEmpty) {
          _selectedImageId = _medicalImages.first.id;
        }

        // Auto-select matching model version based on image or examination modality.
        if ((_selectedModelVersionId == null ||
                !choices.any(
                  (choice) => choice.version.id == _selectedModelVersionId,
                )) &&
            choices.isNotEmpty) {
          final isMri = (_medicalImages.isNotEmpty &&
                  _medicalImages.first.modality.toUpperCase() == 'MRI') ||
              _examination?.examinationType.toUpperCase() == 'MRI';
          final preferredModelId = isMri
              ? MedicalModelRepository.brainTumorModelId
              : MedicalModelRepository.bundledModelId;

          final matchedChoice = choices
              .where((c) => c.model.id == preferredModelId)
              .firstOrNull;
          _selectedModelVersionId =
              (matchedChoice ?? choices.first).version.id;
        }

        _isLoadingInferenceData = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _inferenceError = 'Could not load inference data: $e';
        _isLoadingInferenceData = false;
      });
    }
  }

  // ── Inference ──────────────────────────────────────────────────────────────

  /// Returns the currently selected model choice, or null if none is selected.
  _InstalledModelChoice? get _selectedChoice {
    if (_selectedModelVersionId == null) return null;
    for (final c in _installedModels) {
      if (c.version.id == _selectedModelVersionId) return c;
    }
    return null;
  }

  Future<void> _runInference() async {
    final imageId = _selectedImageId ??
        (_medicalImages.isNotEmpty ? _medicalImages.first.id : null);
    if (imageId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a medical image first.')),
      );
      return;
    }

    final choice = _selectedChoice;
    if (choice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a model first.')),
      );
      return;
    }

    final image = _medicalImages.firstWhere(
      (img) => img.id == imageId,
    );

    // Modality validation
    final modalityError = _validateModality(
      imageModality: image.modality,
      modelModality: choice.catalog.modality,
      modelDisplayName: choice.model.name,
    );
    if (modalityError != null) {
      setState(() {
        _inferenceError = modalityError;
      });
      return;
    }

    setState(() {
      _isRunningInference = true;
      _inferenceError = null;
    });

    try {
      final modelId = choice.model.id;

      if (modelId == MedicalModelRepository.bundledModelId) {
        await _runPneumoniaInference(image, choice);
      } else if (modelId == MedicalModelRepository.brainTumorModelId) {
        await _runBrainTumorInference(image, choice);
      } else {
        throw UnsupportedError(
          'No inference implementation for model "$modelId". '
          'This model is registered but not yet supported by the inference pipeline.',
        );
      }

      await _loadInferenceData();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inference completed and saved.')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _inferenceError = 'Inference failed: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isRunningInference = false;
        });
      }
    }
  }

  Future<void> _runPneumoniaInference(
    MedicalImage image,
    _InstalledModelChoice choice,
  ) async {
    final service = OnnxInferenceService.instance;
    await service.initialize();

    final result = await service.analyzeImage(File(image.filePath));

    final runId = const Uuid().v4();
    final resultId = const Uuid().v4();
    final findingId = const Uuid().v4();

    await _modelRunRepository.saveSuccessfulRun(
      runId: runId,
      resultId: resultId,
      findingId: findingId,
      examinationId: widget.examinationId,
      modelId: choice.model.id,
      modelVersionId: choice.version.id,
      inputImageId: image.id,
      inputImageDate: image.clinicalDate,
      executionTimestamp: result.executedAt,
      prediction: result.prediction,
      confidence: result.confidence,
      normalProbability: result.normalProbability,
      pneumoniaProbability: result.pneumoniaProbability,
    );
  }

  Future<void> _runBrainTumorInference(
    MedicalImage image,
    _InstalledModelChoice choice,
  ) async {
    final service = BrainTumorInferenceService.instance;
    await service.initialize();

    final result = await service.analyzeImage(File(image.filePath));

    final runId = const Uuid().v4();
    final resultId = const Uuid().v4();
    final findingId = const Uuid().v4();

    await _modelRunRepository.saveSuccessfulBrainTumorRun(
      runId: runId,
      resultId: resultId,
      findingId: findingId,
      examinationId: widget.examinationId,
      modelId: choice.model.id,
      modelVersionId: choice.version.id,
      inputImageId: image.id,
      inputImageDate: image.clinicalDate,
      executionTimestamp: result.executedAt,
      prediction: result.prediction,
      confidence: result.confidence,
      scores: {
        'glioma': result.gliomaScore,
        'meningioma': result.meningiomaScore,
        'notumor': result.noTumorScore,
        'pituitary': result.pituitaryScore,
      },
    );
  }

  // ── Image management ───────────────────────────────────────────────────────

  Future<void> _deleteMedicalImage(MedicalImage image) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Medical Image'),
          content: Text(
            'Delete "${image.originalFileName}" from this examination?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await _imageStorage.deleteImage(image.filePath);
    await _imageRepository.deleteMedicalImage(image.id);

    await _loadMedicalImages();
  }

  Future<String?> _showModalityDialog() async {
    const modalities = [
      'X-Ray',
      'CT',
      'MRI',
      'Ultrasound',
      'Mammography',
      'Other',
    ];

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Modality'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: modalities.map((modality) {
              return ListTile(
                title: Text(modality),
                onTap: () {
                  Navigator.pop(context, modality);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<DateTime?> _showClinicalDateDialog(DateTime initialDate) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: colors.background,
        body: const Center(
          child: CircularProgressIndicator(color: WisteriaColors.primary),
        ),
      );
    }

    final examination = _examination;

    if (examination == null) {
      return Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WisteriaBackButton(
                  label: 'Patient',
                  onTap: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Examination not found',
                      style: TextStyle(color: WisteriaColors.textSecondary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  WisteriaBackButton(
                    label: 'Patient',
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          examination.examinationType,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: WisteriaColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          _formatDateTime(examination.examinationDate),
                          style: const TextStyle(
                            fontSize: 13,
                            color: WisteriaColors.textMuted,
                          ),
                        ),

                        const SizedBox(height: 32),

                        _buildSection(
                          title: 'Examination Information',
                          icon: Icons.medical_information_outlined,
                          children: [
                            _buildInfoRow('Type', examination.examinationType),
                            _buildInfoRow('Status', examination.status),
                            _buildInfoRow(
                              'Context',
                              examination.previousDataRange,
                            ),
                            _buildInfoRow(
                              'Date',
                              _formatDateTime(examination.examinationDate),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        _buildSection(
                          title: 'Doctor Notes',
                          icon: Icons.notes_outlined,
                          children: [
                            Text(
                              examination.doctorNotes?.trim().isNotEmpty == true
                                  ? examination.doctorNotes!
                                  : 'No doctor notes added.',
                              style: const TextStyle(
                                fontSize: 14,
                                color: WisteriaColors.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        _buildSection(
                          title: 'Medical Images',
                          icon: Icons.image_outlined,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Images attached to this examination.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: WisteriaColors.textMuted,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                FilledButton.icon(
                                  onPressed: _isAddingImage
                                      ? null
                                      : _addMedicalImage,
                                  icon: _isAddingImage
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.add_photo_alternate_outlined,
                                        ),
                                  label: Text(
                                    _isAddingImage ? 'Adding...' : 'Add Image',
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            if (_medicalImages.isEmpty)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    WisteriaRadius.md,
                                  ),
                                  border: Border.all(
                                    color: WisteriaColors.border,
                                  ),
                                ),
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 36,
                                      color: WisteriaColors.textMuted,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'No medical images added yet.',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: WisteriaColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ..._medicalImages.map(_buildMedicalImageCard),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ── AI Inference Section ──
                        _buildAIInferenceSection(),

                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── AI Inference Section ───────────────────────────────────────────────────

  Widget _buildAIInferenceSection() {
    return _buildSection(
      title: 'AI Analysis',
      icon: Icons.auto_awesome_outlined,
      children: [
        // ── Disclaimer ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: WisteriaColors.warning.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            border: Border.all(
              color: WisteriaColors.warning.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: WisteriaColors.warning.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'AI-generated assistance only. Model output is not a definitive medical diagnosis and must be reviewed by a qualified clinician.',
                  style: TextStyle(
                    fontSize: 12,
                    color: WisteriaColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (_isLoadingInferenceData)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: WisteriaColors.primary),
            ),
          )
        else ...[
          // ── Run New Inference ──
          if (_medicalImages.isNotEmpty && _installedModels.isNotEmpty) ...[
            const Text(
              'Run Inference',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: WisteriaColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // ── Selected model info card ──
            if (_selectedChoice != null) ...[
              _buildModelInfoCard(_selectedChoice!),
              const SizedBox(height: 16),
            ],

            // ── Run button ──
            FilledButton.icon(
              onPressed:
                  _isRunningInference ||
                      _selectedChoice == null ||
                      _medicalImages.isEmpty
                  ? null
                  : _runInference,
              icon: _isRunningInference
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: WisteriaColors.textOnPrimary,
                      ),
                    )
                  : const Icon(Icons.play_arrow_rounded, size: 20),
              label: Text(
                _isRunningInference
                    ? 'Running inference...'
                    : _selectedChoice != null
                    ? 'Run ${_selectedChoice!.model.name}'
                    : 'Run Inference',
              ),
            ),

            if (_isRunningInference) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(
                color: WisteriaColors.primary,
                backgroundColor: WisteriaColors.surfaceHigh,
              ),
            ],

            if (_inferenceError != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: WisteriaColors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                  border: Border.all(
                    color: WisteriaColors.error.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  _inferenceError!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: WisteriaColors.error,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),
          ] else if (_medicalImages.isEmpty) ...[
            const Text(
              'Add a medical image to run AI inference.',
              style: TextStyle(fontSize: 13, color: WisteriaColors.textMuted),
            ),
            const SizedBox(height: 20),
          ] else if (_installedModels.isEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: WisteriaColors.surfaceContainer,
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                border: Border.all(color: WisteriaColors.border),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.memory_rounded,
                    size: 28,
                    color: WisteriaColors.textMuted,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No local model available',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: WisteriaColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Register a model in Doctor & System → Models to enable AI inference.',
                    style: TextStyle(
                      fontSize: 12,
                      color: WisteriaColors.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // ── Saved Results ──
          if (_savedInferences.isNotEmpty) ...[
            const Text(
              'Saved Results',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: WisteriaColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ..._savedInferences.map(_buildSavedInferenceCard),
          ],
        ],
      ],
    );
  }

  Widget _buildModelInfoCard(_InstalledModelChoice choice) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WisteriaColors.surfaceContainer,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: WisteriaColors.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.memory_rounded,
            size: 18,
            color: WisteriaColors.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  choice.model.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: WisteriaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${choice.model.task} • ${choice.catalog.modality} • v${choice.version.version}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: WisteriaColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: WisteriaColors.success.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'LOCAL',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: WisteriaColors.success,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedInferenceCard(_SavedInference inference) {
    final finding = inference.findings.isNotEmpty
        ? inference.findings.first
        : null;

    final prediction = finding?.value ?? 'Unknown';
    final confidence = finding?.confidence != null
        ? double.tryParse(finding!.confidence!)
        : null;

    // Decode raw model output for additional scores
    Map<String, dynamic>? rawOutput;
    try {
      final raw = inference.result.rawModelOutput;
      if (raw != null && raw.isNotEmpty) {
        rawOutput = jsonDecode(raw) as Map<String, dynamic>?;
      }
    } catch (_) {
      // Ignore decode errors; display only the primary finding.
    }

    final isBrainTumor = rawOutput?['modelType'] == 'brain_tumor';

    // Severity determination for icon/color
    final isPneumonia = prediction.toUpperCase() == 'PNEUMONIA';
    final isNoTumor = prediction.toLowerCase() == 'notumor';
    final isAlertCondition = isPneumonia || (!isNoTumor && isBrainTumor);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: WisteriaColors.background,
        borderRadius: BorderRadius.circular(WisteriaRadius.md),
        border: Border.all(color: WisteriaColors.border),
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
                  color: isAlertCondition
                      ? WisteriaColors.warning.withValues(alpha: 0.10)
                      : WisteriaColors.success.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                ),
                child: Icon(
                  isAlertCondition
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline_rounded,
                  color: isAlertCondition
                      ? WisteriaColors.warning
                      : WisteriaColors.success,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatPredictionLabel(prediction, isBrainTumor),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isAlertCondition
                            ? WisteriaColors.warning
                            : WisteriaColors.success,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Model: ${inference.modelName}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: WisteriaColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (confidence != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: WisteriaColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(confidence * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: WisteriaColors.textPrimary,
                    ),
                  ),
                ),
            ],
          ),

          // ── Brain Tumor score breakdown ──
          if (isBrainTumor && rawOutput != null) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            const Text(
              'Class scores',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: WisteriaColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            _buildScoreRow('Glioma', rawOutput['glioma']),
            _buildScoreRow('Meningioma', rawOutput['meningioma']),
            _buildScoreRow('No Tumor', rawOutput['notumor']),
            _buildScoreRow('Pituitary', rawOutput['pituitary']),
          ],

          // ── Pneumonia score breakdown ──
          if (!isBrainTumor && rawOutput != null) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 12),
            const Text(
              'Class scores',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: WisteriaColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            _buildScoreRow('Normal', rawOutput['normalProbability']),
            _buildScoreRow('Pneumonia', rawOutput['pneumoniaProbability']),
          ],

          const SizedBox(height: 12),
          Text(
            _formatDateTime(inference.run.executionTimestamp),
            style: const TextStyle(
              fontSize: 11,
              color: WisteriaColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, dynamic rawValue) {
    final value = rawValue is num ? rawValue.toDouble() : null;
    final text = value != null
        ? '${(value * 100).toStringAsFixed(2)}%'
        : '—';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: WisteriaColors.textSecondary,
              ),
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: WisteriaColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPredictionLabel(String prediction, bool isBrainTumor) {
    if (!isBrainTumor) return prediction;

    switch (prediction.toLowerCase()) {
      case 'glioma':
        return 'Glioma';
      case 'meningioma':
        return 'Meningioma';
      case 'notumor':
        return 'No Tumor';
      case 'pituitary':
        return 'Pituitary';
      default:
        return prediction;
    }
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: WisteriaColors.surfaceLow,
        borderRadius: BorderRadius.circular(WisteriaRadius.lg),
        border: Border.all(color: WisteriaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: WisteriaColors.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: WisteriaColors.textPrimary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: WisteriaColors.textMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: WisteriaColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalImageCard(MedicalImage image) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(WisteriaRadius.md),
        border: Border.all(color: WisteriaColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(WisteriaRadius.md),
              color: WisteriaColors.surfaceHigh,
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.file(
              File(image.filePath),
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return const Icon(
                  Icons.broken_image_outlined,
                  color: WisteriaColors.textMuted,
                  size: 32,
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  image.originalFileName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: WisteriaColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow('Modality', image.modality),
                _buildInfoRow(
                  'Clinical Date',
                  _formatDateTime(image.clinicalDate),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Delete image',
            icon: const Icon(
              Icons.delete_outline,
              color: WisteriaColors.textMuted,
            ),
            onPressed: () => _deleteMedicalImage(image),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;

    final hour = dateTime.hour == 0
        ? 12
        : dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour;

    final minute = dateTime.minute.toString().padLeft(2, '0');

    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$day/$month/$year • $hour:$minute $period';
  }
}

class _InstalledModelChoice {
  final MedicalModel model;
  final ModelVersion version;
  final CatalogModel catalog;

  const _InstalledModelChoice({
    required this.model,
    required this.version,
    required this.catalog,
  });
}

class _SavedInference {
  final ModelRun run;
  final ModelRunResult result;
  final List<ModelFinding> findings;
  final String modelName;

  const _SavedInference({
    required this.run,
    required this.result,
    required this.findings,
    required this.modelName,
  });
}
