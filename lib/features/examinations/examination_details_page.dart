import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/database.dart';
import '../../core/database/repositories/examination_repository.dart';
import '../../core/database/repositories/medical_image_repository.dart';
import '../../core/database/repositories/medical_model_repository.dart';
import '../../core/database/repositories/model_run_repository.dart';
import '../../core/models/system_model_catalog.dart';
import '../../core/services/onnx_inference_service.dart';
import '../../core/storage/medical_image_storage.dart';
import '../../core/theme/wisteria_theme.dart';
import '../shared/wisteria_back_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Modality validation helper
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
// Saved Examination Record Details Page
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

  bool _isLoading = true;
  bool _isLoadingInferenceData = true;
  bool _isRunningInference = false;
  bool _isSavingResult = false;
  bool _isAddingImage = false;
  String? _inferenceError;
  Examination? _examination;
  List<MedicalImage> _medicalImages = [];

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

  Future<void> _loadInferenceData() async {
    try {
      final models = await _modelRepository.getAllModels();
      final choices = <_InstalledModelChoice>[];

      for (final model in models) {
        final version = await _modelRepository.getInstalledVersion(model.id);
        if (version == null) continue;

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

        if (_selectedImageId == null && _medicalImages.isNotEmpty) {
          _selectedImageId = _medicalImages.first.id;
        }

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

  _InstalledModelChoice? get _selectedChoice {
    if (_selectedModelVersionId == null) return null;
    for (final c in _installedModels) {
      if (c.version.id == _selectedModelVersionId) return c;
    }
    return null;
  }

  // ── Inference Execution ───────────────────────────────────────────────────

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
        const SnackBar(
          content: Text('Inference completed and saved.'),
          behavior: SnackBarBehavior.floating,
        ),
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

  // ── Save Result Action ────────────────────────────────────────────────────

  Future<void> _saveResult() async {
    final examination = _examination;
    if (examination == null) return;

    setState(() => _isSavingResult = true);

    try {
      await _repository.updateExamination(
        examinationId: examination.id,
        status: 'COMPLETED',
      );

      await _loadExamination();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Examination result confirmed and saved to record.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save result: $e'),
          backgroundColor: WisteriaColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSavingResult = false);
      }
    }
  }

  // ── Image Management ──────────────────────────────────────────────────────

  Future<void> _addMedicalImage() async {
    setState(() => _isAddingImage = true);

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
        setState(() => _isAddingImage = false);
      }
    }
  }

  Future<void> _deleteMedicalImage(MedicalImage image) async {
    final colors = WisteriaColors.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colors.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            side: BorderSide(color: colors.border),
          ),
          title: Text(
            'Delete Medical Image',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          content: Text(
            'Delete "${image.originalFileName}" from this examination? Attached inference runs associated with this image will remain preserved in historical logs.',
            style: TextStyle(
              fontSize: 13,
              color: colors.textSecondary,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colors.error,
                foregroundColor: colors.textOnPrimary,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await _imageStorage.deleteImage(image.filePath);
    await _imageRepository.deleteMedicalImage(image.id);

    if (_selectedImageId == image.id) {
      _selectedImageId = null;
    }

    await _loadMedicalImages();
  }

  Future<String?> _showModalityDialog() async {
    final colors = WisteriaColors.of(context);
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
          backgroundColor: colors.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            side: BorderSide(color: colors.border),
          ),
          title: Text(
            'Select Modality',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: modalities.map((modality) {
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                ),
                title: Text(
                  modality,
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                ),
                onTap: () => Navigator.pop(context, modality),
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

  void _showImagePreviewDialog(MedicalImage image) {
    showDialog(
      context: context,
      builder: (context) {
        final colors = WisteriaColors.of(context);
        return Dialog(
          backgroundColor: colors.surfaceLowest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            side: BorderSide(color: colors.border),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860, maxHeight: 720),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                        ),
                        child: Icon(Icons.image_outlined, size: 16, color: colors.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              image.originalFileName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Modality: ${image.modality}  •  Acquired: ${_formatDateTime(image.clinicalDate)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: colors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close preview',
                        icon: const Icon(Icons.close_rounded, size: 20),
                        color: colors.textMuted,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    child: Image.file(
                      File(image.filePath),
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image_outlined, size: 48, color: colors.textMuted),
                          const SizedBox(height: 12),
                          Text(
                            'Unable to display medical image',
                            style: TextStyle(color: colors.textMuted, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Format: ${image.fileFormat.toUpperCase()}',
                        style: TextStyle(fontSize: 12, color: colors.textMuted),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Dismiss'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Build Page ────────────────────────────────────────────────────────────

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
                  label: 'Patient Record',
                  onTap: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_off_outlined,
                          size: 48,
                          color: colors.textMuted,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Examination record not found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isMri = examination.examinationType.toUpperCase().contains('MRI') ||
        examination.examinationType.toUpperCase().contains('BRAIN');

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              decoration: BoxDecoration(
                color: colors.surfaceLow,
                border: Border(
                  bottom: BorderSide(color: colors.border, width: 1),
                ),
              ),
              child: Row(
                children: [
                  WisteriaBackButton(
                    label: 'Patient Record',
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    height: 18,
                    width: 1,
                    color: colors.border,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Examination Record Details',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  // Quick examination status pill
                  _buildStatusPill(examination.status, colors),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1320),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isDesktopWide = constraints.maxWidth >= 1020;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Prominent Examination Header Banner
                            _buildHeaderHero(examination, isMri, colors),

                            const SizedBox(height: 24),

                            // Responsive Body: 2-column on desktop wide, single column stacked on smaller
                            if (isDesktopWide)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left Column (55%): Info, Notes, Images
                                  Expanded(
                                    flex: 55,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // 2. Examination Information
                                        _buildExaminationInfoCard(examination, colors),
                                        const SizedBox(height: 20),

                                        // 3. Doctor Notes
                                        _buildDoctorNotesCard(examination, colors),
                                        const SizedBox(height: 20),

                                        // 4. Medical Images
                                        _buildMedicalImagesCard(colors),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 24),

                                  // Right Column (45%): AI Findings & Test Actions
                                  Expanded(
                                    flex: 45,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // 5 & 6. AI Analysis & Results + Run More Test & Save Result
                                        _buildAIAnalysisSection(colors),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 2. Examination Information
                                  _buildExaminationInfoCard(examination, colors),
                                  const SizedBox(height: 20),

                                  // 5 & 6. AI Analysis & Results + Run More Test & Save Result
                                  _buildAIAnalysisSection(colors),
                                  const SizedBox(height: 20),

                                  // 4. Medical Images
                                  _buildMedicalImagesCard(colors),
                                  const SizedBox(height: 20),

                                  // 3. Doctor Notes
                                  _buildDoctorNotesCard(examination, colors),
                                ],
                              ),

                            const SizedBox(height: 48),
                          ],
                        );
                      },
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

  // ── 1. Header Hero Card ───────────────────────────────────────────────────

  Widget _buildHeaderHero(
    Examination examination,
    bool isMri,
    WisteriaColorPalette colors,
  ) {
    final typeAccent = isMri ? const Color(0xFF8E24AA) : colors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Specialty/Modality Icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: typeAccent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(WisteriaRadius.sm),
              border: Border.all(
                color: typeAccent.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              isMri ? Icons.psychology_outlined : Icons.favorite_border_rounded,
              color: typeAccent,
              size: 26,
            ),
          ),
          const SizedBox(width: 20),

          // Examination Title & Subtitle Metadata
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        examination.examinationType,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildStatusPill(examination.status, colors),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: colors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatDateTime(examination.examinationDate),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '•',
                      style: TextStyle(color: colors.textMuted, fontSize: 12),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.folder_shared_outlined,
                          size: 14,
                          color: colors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Record ID: #${examination.id.length > 8 ? examination.id.substring(0, 8).toUpperCase() : examination.id.toUpperCase()}',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Quick Action Header Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.textSecondary,
                  side: BorderSide(color: colors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                  ),
                ),
                onPressed: _isAddingImage ? null : _addMedicalImage,
                icon: const Icon(Icons.add_photo_alternate_outlined, size: 16),
                label: const Text('Add Image', style: TextStyle(fontSize: 12)),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                  ),
                ),
                onPressed: _isSavingResult ? null : _saveResult,
                icon: _isSavingResult
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.textOnPrimary,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline_rounded, size: 16),
                label: Text(
                  _isSavingResult ? 'Saving...' : 'Save Result',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 2. Examination Information Card ───────────────────────────────────────

  Widget _buildExaminationInfoCard(
    Examination examination,
    WisteriaColorPalette colors,
  ) {
    return _buildCardWrapper(
      title: 'Examination Information',
      icon: Icons.medical_information_outlined,
      colors: colors,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMultiColumn = constraints.maxWidth > 480;

          return Column(
            children: [
              if (isMultiColumn)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildInfoGridCell(
                        icon: Icons.biotech_outlined,
                        label: 'EXAMINATION TYPE',
                        value: examination.examinationType,
                        colors: colors,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoGridCell(
                        icon: Icons.verified_outlined,
                        label: 'COMPLETION STATUS',
                        customWidget: _buildStatusPill(examination.status, colors),
                        colors: colors,
                      ),
                    ),
                  ],
                )
              else ...[
                _buildInfoGridCell(
                  icon: Icons.biotech_outlined,
                  label: 'EXAMINATION TYPE',
                  value: examination.examinationType,
                  colors: colors,
                ),
                const SizedBox(height: 12),
                _buildInfoGridCell(
                  icon: Icons.verified_outlined,
                  label: 'COMPLETION STATUS',
                  customWidget: _buildStatusPill(examination.status, colors),
                  colors: colors,
                ),
              ],

              const SizedBox(height: 12),

              if (isMultiColumn)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildInfoGridCell(
                        icon: Icons.history_edu_outlined,
                        label: 'CLINICAL CONTEXT / RANGE',
                        value: examination.previousDataRange.isNotEmpty
                            ? examination.previousDataRange
                            : 'Standard Clinical Evaluation',
                        colors: colors,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoGridCell(
                        icon: Icons.calendar_today_outlined,
                        label: 'RECORDED DATE & TIME',
                        value: _formatDateTime(examination.examinationDate),
                        colors: colors,
                      ),
                    ),
                  ],
                )
              else ...[
                _buildInfoGridCell(
                  icon: Icons.history_edu_outlined,
                  label: 'CLINICAL CONTEXT / RANGE',
                  value: examination.previousDataRange.isNotEmpty
                      ? examination.previousDataRange
                      : 'Standard Clinical Evaluation',
                  colors: colors,
                ),
                const SizedBox(height: 12),
                _buildInfoGridCell(
                  icon: Icons.calendar_today_outlined,
                  label: 'RECORDED DATE & TIME',
                  value: _formatDateTime(examination.examinationDate),
                  colors: colors,
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoGridCell({
    required IconData icon,
    required String label,
    String? value,
    Widget? customWidget,
    required WisteriaColorPalette colors,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: colors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: colors.textMuted,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (customWidget != null)
            customWidget
          else
            Text(
              value ?? '—',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  // ── 3. Doctor Notes Card ──────────────────────────────────────────────────

  Widget _buildDoctorNotesCard(
    Examination examination,
    WisteriaColorPalette colors,
  ) {
    final hasNotes =
        examination.doctorNotes != null && examination.doctorNotes!.trim().isNotEmpty;

    return _buildCardWrapper(
      title: 'Doctor Notes',
      icon: Icons.notes_outlined,
      colors: colors,
      child: hasNotes
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.edit_note_rounded, size: 16, color: colors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Clinician Observation & Assessment',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SelectableText(
                    examination.doctorNotes!.trim(),
                    style: TextStyle(
                      fontSize: 13.5,
                      color: colors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.speaker_notes_off_outlined,
                    size: 20,
                    color: colors.textMuted,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'No doctor notes added.',
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ── 4. Medical Images Card ────────────────────────────────────────────────

  Widget _buildMedicalImagesCard(WisteriaColorPalette colors) {
    return _buildCardWrapper(
      title: 'Medical Images',
      icon: Icons.image_outlined,
      colors: colors,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              borderRadius: BorderRadius.circular(WisteriaRadius.sm),
              border: Border.all(color: colors.border),
            ),
            child: Text(
              '${_medicalImages.length} Attached',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.textOnPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
              ),
            ),
            onPressed: _isAddingImage ? null : _addMedicalImage,
            icon: _isAddingImage
                ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.textOnPrimary,
                    ),
                  )
                : const Icon(Icons.add_photo_alternate_outlined, size: 15),
            label: Text(
              _isAddingImage ? 'Adding...' : 'Add Image',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_medicalImages.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.image_not_supported_outlined,
                    size: 36,
                    color: colors.textMuted,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No medical images added yet.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Attach an X-Ray or MRI image to enable automated AI diagnostic inference.',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ..._medicalImages.map((img) => _buildMedicalImageItem(img, colors)),
        ],
      ),
    );
  }

  Widget _buildMedicalImageItem(
    MedicalImage image,
    WisteriaColorPalette colors,
  ) {
    final isSelected = _selectedImageId == image.id;
    final isMri = image.modality.toUpperCase() == 'MRI';
    final tagColor = isMri ? const Color(0xFF8E24AA) : colors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(
          color: isSelected ? colors.primary : colors.borderSubtle,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        onTap: () {
          setState(() {
            _selectedImageId = image.id;
            _inferenceError = null;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Thumbnail with click-to-preview
              GestureDetector(
                onTap: () => _showImagePreviewDialog(image),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: 96,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                      border: Border.all(color: colors.border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          File(image.filePath),
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: colors.textMuted,
                              size: 26,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          bottom: 4,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: const Icon(
                              Icons.zoom_in_rounded,
                              size: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Image Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            image.originalFileName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isSelected)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                              border: Border.all(
                                color: colors.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              'ANALYSIS TARGET',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: colors.primary,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        // Modality badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: tagColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                            border: Border.all(
                              color: tagColor.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Text(
                            image.modality.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: tagColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          image.fileFormat.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('•', style: TextStyle(color: colors.textMuted, fontSize: 11)),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 11,
                          color: colors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDateTime(image.clinicalDate),
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              IconButton(
                tooltip: 'Preview full resolution',
                icon: Icon(
                  Icons.fullscreen_rounded,
                  size: 18,
                  color: colors.textSecondary,
                ),
                onPressed: () => _showImagePreviewDialog(image),
              ),
              IconButton(
                tooltip: 'Delete image',
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: colors.error.withValues(alpha: 0.8),
                ),
                onPressed: () => _deleteMedicalImage(image),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── 5 & 6. AI Analysis & Results Section ──────────────────────────────────

  Widget _buildAIAnalysisSection(WisteriaColorPalette colors) {
    return _buildCardWrapper(
      title: 'AI Analysis',
      icon: Icons.auto_awesome_outlined,
      colors: colors,
      trailing: _savedInferences.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: colors.success.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                border: Border.all(
                  color: colors.success.withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                '${_savedInferences.length} EVALUATION${_savedInferences.length == 1 ? '' : 'S'}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.success,
                  letterSpacing: 0.4,
                ),
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Clinical Advisory Notice
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              color: colors.warning.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(WisteriaRadius.sm),
              border: Border.all(
                color: colors.warning.withValues(alpha: 0.18),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: colors.warning,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'AI-generated assistance only. Model output is not a definitive medical diagnosis and must be reviewed and correlated by a qualified clinician.',
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_isLoadingInferenceData)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: CircularProgressIndicator(color: colors.primary),
              ),
            )
          else ...[
            // ── Saved Findings Display ──
            if (_savedInferences.isNotEmpty) ...[
              Text(
                'SAVED INFERENCE FINDINGS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.textMuted,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 12),
              ..._savedInferences.map((inf) => _buildSavedInferenceCard(inf, colors)),
              const SizedBox(height: 20),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                  border: Border.all(color: colors.borderSubtle),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 32,
                      color: colors.textMuted,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No saved AI findings recorded yet',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Execute an inference test on an attached image to evaluate diagnostic findings.',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],

            // ── Run More Test & Execution Controls ──
            _buildRunTestControls(colors),
          ],
        ],
      ),
    );
  }

  // ── Saved Finding Result Card ─────────────────────────────────────────────

  Widget _buildSavedInferenceCard(
    _SavedInference inference,
    WisteriaColorPalette colors,
  ) {
    final finding =
        inference.findings.isNotEmpty ? inference.findings.first : null;
    final prediction = finding?.value ?? 'Unknown';
    final confidence = finding?.confidence != null
        ? double.tryParse(finding!.confidence!)
        : null;

    Map<String, dynamic>? rawOutput;
    try {
      final raw = inference.result.rawModelOutput;
      if (raw != null && raw.isNotEmpty) {
        rawOutput = jsonDecode(raw) as Map<String, dynamic>?;
      }
    } catch (_) {}

    final isBrainTumor = rawOutput?['modelType'] == 'brain_tumor' ||
        inference.modelName.toLowerCase().contains('brain');

    final isPneumonia = prediction.toUpperCase() == 'PNEUMONIA';
    final isNoTumor = prediction.toLowerCase() == 'notumor';
    final isAlertCondition = isPneumonia || (!isNoTumor && isBrainTumor);
    final alertColor = isAlertCondition ? colors.warning : colors.success;

    // Actual probability scores for Pneumonia
    double? normalProb = rawOutput?['normalProbability'] is num
        ? (rawOutput!['normalProbability'] as num).toDouble()
        : null;
    double? pneumoniaProb = rawOutput?['pneumoniaProbability'] is num
        ? (rawOutput!['pneumoniaProbability'] as num).toDouble()
        : null;

    // Fallback if raw JSON lacked explicit normalProbability
    if (normalProb == null && pneumoniaProb == null && confidence != null) {
      if (isPneumonia) {
        pneumoniaProb = confidence;
        normalProb = (1.0 - confidence).clamp(0.0, 1.0);
      } else if (prediction.toUpperCase() == 'NORMAL') {
        normalProb = confidence;
        pneumoniaProb = (1.0 - confidence).clamp(0.0, 1.0);
      }
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primary Prediction Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: alertColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(WisteriaRadius.sm),
                topRight: Radius.circular(WisteriaRadius.sm),
              ),
              border: Border(
                bottom: BorderSide(
                  color: alertColor.withValues(alpha: 0.22),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: alertColor.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    border: Border.all(
                      color: alertColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    isAlertCondition
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_outline_rounded,
                    color: alertColor,
                    size: 24,
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
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: alertColor,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        confidence != null
                            ? 'Model Confidence: ${(confidence * 100).toStringAsFixed(1)}%'
                            : 'Evaluated Classification Finding',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.surfaceLow,
                    borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bookmark_added_rounded, size: 12, color: colors.success),
                      const SizedBox(width: 5),
                      Text(
                        'SAVED',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: colors.success,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Probability Breakdown
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Actual Pneumonia & Normal Progress Bars
                if (!isBrainTumor && (normalProb != null || pneumoniaProb != null)) ...[
                  Text(
                    'PROBABILITY DISTRIBUTION',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.textMuted,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (normalProb != null) ...[
                    _buildProbabilityBar(
                      label: 'NORMAL',
                      percentage: normalProb,
                      color: colors.success,
                      colors: colors,
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (pneumoniaProb != null) ...[
                    _buildProbabilityBar(
                      label: 'PNEUMONIA',
                      percentage: pneumoniaProb,
                      color: colors.warning,
                      colors: colors,
                    ),
                  ],
                  const SizedBox(height: 14),
                ],

                // Brain Tumor Multi-Class Bars
                if (isBrainTumor && rawOutput != null) ...[
                  Text(
                    'CLASS PROBABILITIES',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.textMuted,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (rawOutput['glioma'] is num) ...[
                    _buildProbabilityBar(
                      label: 'Glioma',
                      percentage: (rawOutput['glioma'] as num).toDouble(),
                      color: const Color(0xFFE53935),
                      colors: colors,
                    ),
                    const SizedBox(height: 6),
                  ],
                  if (rawOutput['meningioma'] is num) ...[
                    _buildProbabilityBar(
                      label: 'Meningioma',
                      percentage: (rawOutput['meningioma'] as num).toDouble(),
                      color: const Color(0xFFFB8C00),
                      colors: colors,
                    ),
                    const SizedBox(height: 6),
                  ],
                  if (rawOutput['pituitary'] is num) ...[
                    _buildProbabilityBar(
                      label: 'Pituitary',
                      percentage: (rawOutput['pituitary'] as num).toDouble(),
                      color: const Color(0xFF8E24AA),
                      colors: colors,
                    ),
                    const SizedBox(height: 6),
                  ],
                  if (rawOutput['notumor'] is num) ...[
                    _buildProbabilityBar(
                      label: 'No Tumor',
                      percentage: (rawOutput['notumor'] as num).toDouble(),
                      color: colors.success,
                      colors: colors,
                    ),
                  ],
                  const SizedBox(height: 14),
                ],

                // Model Identifier & Timestamp Details
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: colors.surfaceLow,
                    borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    border: Border.all(color: colors.borderSubtle),
                  ),
                  child: Column(
                    children: [
                      _buildMetaDetailRow(
                        icon: Icons.memory_rounded,
                        label: 'Model Identifier',
                        value: inference.modelName,
                        colors: colors,
                      ),
                      const SizedBox(height: 8),
                      _buildMetaDetailRow(
                        icon: Icons.access_time_rounded,
                        label: 'Execution Timestamp',
                        value: _formatDateTime(inference.run.executionTimestamp),
                        colors: colors,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Probability Progress Bar Component ────────────────────────────────────

  Widget _buildProbabilityBar({
    required String label,
    required double percentage,
    required Color color,
    required WisteriaColorPalette colors,
  }) {
    final pctString = (percentage * 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              Text(
                '$pctString%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: percentage >= 0.5 ? color : colors.textMuted,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            child: LinearProgressIndicator(
              value: percentage.clamp(0.0, 1.0),
              backgroundColor: colors.borderSubtle,
              color: color,
              minHeight: 7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required WisteriaColorPalette colors,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: colors.textMuted),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colors.textMuted,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }

  // ── 6. Run More Test & Execution Controls ─────────────────────────────────

  Widget _buildRunTestControls(WisteriaColorPalette colors) {
    final hasImages = _medicalImages.isNotEmpty;
    final hasModels = _installedModels.isNotEmpty;
    final choice = _selectedChoice;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.biotech_outlined, size: 16, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                'RUN ADDITIONAL AI INFERENCE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Active target image indicator
          if (hasImages) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.surfaceLow,
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Row(
                children: [
                  Icon(Icons.image_outlined, size: 14, color: colors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Target Image: ',
                    style: TextStyle(fontSize: 12, color: colors.textMuted),
                  ),
                  Expanded(
                    child: Text(
                      _selectedImageId != null
                          ? _medicalImages
                              .firstWhere(
                                (img) => img.id == _selectedImageId,
                                orElse: () => _medicalImages.first,
                              )
                              .originalFileName
                          : _medicalImages.first.originalFileName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],

          // Active model card
          if (choice != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.surfaceLow,
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Row(
                children: [
                  Icon(Icons.memory_rounded, size: 14, color: colors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          choice.model.name,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${choice.catalog.modality} • v${choice.version.version}',
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.textMuted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colors.success.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    ),
                    child: Text(
                      'ONNX LOCAL',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: colors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Error notification if present
          if (_inferenceError != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: colors.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                border: Border.all(color: colors.error.withValues(alpha: 0.25)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline_rounded, size: 16, color: colors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _inferenceError!,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (_isRunningInference) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(WisteriaRadius.sm),
              child: LinearProgressIndicator(
                color: colors.primary,
                backgroundColor: colors.borderSubtle,
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 12),
          ],

          // ── Visually Distinct Actions: Run More Test & Save Result ──
          Row(
            children: [
              // 1. Run More Test (Distinct Outlined/Secondary Style)
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.primary,
                    side: BorderSide(
                      color: colors.primary.withValues(alpha: 0.6),
                      width: 1.2,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    ),
                  ),
                  onPressed: _isRunningInference || !hasImages || !hasModels
                      ? null
                      : _runInference,
                  icon: _isRunningInference
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.primary,
                          ),
                        )
                      : const Icon(Icons.science_outlined, size: 18),
                  label: Text(
                    _isRunningInference
                        ? 'Running inference...'
                        : _selectedChoice != null
                            ? 'Run ${_selectedChoice!.model.name}'
                            : (_savedInferences.isEmpty
                                ? 'Run Inference'
                                : 'Run More Test'),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // 2. Save Result (Distinct Solid Teal Primary Style)
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.textOnPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    ),
                  ),
                  onPressed: _isSavingResult ? null : _saveResult,
                  icon: _isSavingResult
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.textOnPrimary,
                          ),
                        )
                      : const Icon(Icons.bookmark_added_rounded, size: 18),
                  label: Text(
                    _isSavingResult ? 'Saving...' : 'Save Result',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Common Card Wrapper ───────────────────────────────────────────────────

  Widget _buildCardWrapper({
    required String title,
    required IconData icon,
    Widget? trailing,
    required WisteriaColorPalette colors,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Icon(icon, size: 16, color: colors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),

          const SizedBox(height: 18),

          child,
        ],
      ),
    );
  }

  // ── Status Pill Component ─────────────────────────────────────────────────

  Widget _buildStatusPill(String status, WisteriaColorPalette colors) {
    final s = status.toUpperCase();
    final isCompleted = s == 'COMPLETED';
    final pillColor = isCompleted ? colors.success : colors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: pillColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(
          color: pillColor.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: pillColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            s,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: pillColor,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper formatters ─────────────────────────────────────────────────────

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

  String _formatPredictionLabel(String prediction, bool isBrainTumor) {
    if (!isBrainTumor) return prediction.toUpperCase();

    switch (prediction.toLowerCase()) {
      case 'glioma':
        return 'Glioma Tumor';
      case 'meningioma':
        return 'Meningioma Tumor';
      case 'notumor':
        return 'No Tumor Detected';
      case 'pituitary':
        return 'Pituitary Tumor';
      default:
        return prediction;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Model Choice and Saved Inference Models
// ─────────────────────────────────────────────────────────────────────────────

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
