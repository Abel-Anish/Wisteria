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

/// AI-first New Examination workflow.
///
/// Stages:
///   0 — Specialty Selection (Cardiology / Neurology / Ophthalmology)
///   A — Examination Setup (type, image selection)
///   B — Run AI Analysis
///   C — Review AI Results
///   D — Doctor Notes (revealed after successful inference)
///   E — Save Examination
class CreateExaminationPage extends StatefulWidget {
  final WisteriaDatabase database;
  final String patientId;
  final String patientName;

  const CreateExaminationPage({
    super.key,
    required this.database,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<CreateExaminationPage> createState() => _CreateExaminationPageState();
}

class _CreateExaminationPageState extends State<CreateExaminationPage> {
  static const _uuid = Uuid();

  // Repositories
  late final ExaminationRepository _examRepo;
  late final MedicalImageRepository _imageRepo;
  late final MedicalModelRepository _modelRepo;
  late final ModelRunRepository _runRepo;
  late final MedicalImageStorage _imageStorage;

  // ── Specialty selection ──
  String? _selectedSpecialty; // 'Cardiology', 'Neurology', 'Ophthalmology'
  List<_InstalledModelChoice> _installedModels = [];

  // Mapping specialty → model IDs
  static const Map<String, String> _specialtyToModelId = {
    'Cardiology': MedicalModelRepository.bundledModelId,
    'Neurology': MedicalModelRepository.brainTumorModelId,
  };

  // ── Stage tracking ──
  bool _inferenceCompleted = false;
  bool _examinationSaved = false;

  // ── Examination metadata ──
  String get _examinationType => _isBrainTumorActive ? 'MRI' : 'Chest X-Ray';
  static const String _previousDataRange = '6 Months';

  // ── Image ──
  File? _selectedImageFile;
  String? _selectedImageOriginalName;
  String? _savedImageId;
  String? _savedImagePath;

  // ── Model ──
  String? _bundledModelId;
  String? _bundledVersionId;
  bool _modelAvailable = false;
  bool _loadingModel = true;
  String? _modelError;

  // ── Inference ──
  bool _runningInference = false;
  String? _inferenceError;
  PneumoniaInferenceResult? _inferenceResult;
  BrainTumorInferenceResult? _brainTumorResult;

  // ── Doctor notes ──
  final _notesController = TextEditingController();

  // ── Save ──
  bool _saving = false;
  String? _saveError;

  // Draft examination created in DB
  String? _draftExaminationId;

  // Safe navigation tracking to prevent popping parent route
  bool _isNavigatingBack = false;

  @override
  void initState() {
    super.initState();
    _examRepo = ExaminationRepository(widget.database);
    _imageRepo = MedicalImageRepository(widget.database);
    _modelRepo = MedicalModelRepository(widget.database);
    _runRepo = ModelRunRepository(widget.database);
    _imageStorage = MedicalImageStorage();
    _ensureModel();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  /// Ensure bundled pneumonia model exists in DB.
  Future<void> _ensureModel() async {
    try {
      final ids = await _modelRepo.ensureBundledPneumoniaModel();
      await _loadInstalledModels();
      if (!mounted) return;
      setState(() {
        _bundledModelId = ids.modelId;
        _bundledVersionId = ids.versionId;
        _modelAvailable = true;
        _loadingModel = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _modelError = 'Could not load AI model: $e';
        _loadingModel = false;
      });
    }
  }

  /// Load all installed models.
  Future<void> _loadInstalledModels() async {
    try {
      final models = await _modelRepo.getAllModels();
      final choices = <_InstalledModelChoice>[];
      for (final model in models) {
        final version = await _modelRepo.getInstalledVersion(model.id);
        if (version == null) continue;
        final catalogEntry = SystemModelCatalog.getById(model.id);
        if (catalogEntry == null || !catalogEntry.isSupported) continue;
        choices.add(_InstalledModelChoice(
          model: model,
          version: version,
          catalog: catalogEntry,
        ));
      }
      if (!mounted) return;
      setState(() {
        _installedModels = choices;
      });
    } catch (e) {
      // Silent; UI will show loading error if needed.
    }
  }

  /// Pick an image file from disk.
  Future<void> _pickImage() async {
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'bmp'],
    );

    if (picked == null || picked.path == null) return;
    if (!mounted) return;

    final file = File(picked.path!);
    if (!await file.exists()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selected file does not exist.')),
      );
      return;
    }

    setState(() {
      _selectedImageFile = file;
      _selectedImageOriginalName = picked.name;
      // Reset inference if image changes
      _inferenceResult = null;
      _brainTumorResult = null;
      _inferenceCompleted = false;
      _inferenceError = null;
    });
  }

  /// Resolves the correct model ID from the selected specialty.
  String? get _activeModelId {
    if (_selectedSpecialty == null) return null;
    return _specialtyToModelId[_selectedSpecialty!];
  }

  /// Whether the active specialty uses the brain tumor model.
  bool get _isBrainTumorActive =>
      _activeModelId == MedicalModelRepository.brainTumorModelId;

  /// The image modality label for the active specialty.
  String get _activeModality => _isBrainTumorActive ? 'MRI' : 'X-Ray';

  /// The active model's display name.
  String get _activeModelDisplayName {
    final id = _activeModelId;
    if (id == null) return 'AI Model';
    final catalog = SystemModelCatalog.getById(id);
    return catalog?.displayName ?? 'AI Model';
  }

  /// Create draft examination + save image to DB, then run ONNX inference.
  Future<void> _runAIAnalysis() async {
    final imageFile = _selectedImageFile;
    if (imageFile == null) return;
    if (!_modelAvailable || _bundledModelId == null) return;

    setState(() {
      _runningInference = true;
      _inferenceError = null;
      _inferenceResult = null;
      _brainTumorResult = null;
    });

    try {
      // Step 1: Create draft examination if not already created.
      if (_draftExaminationId == null) {
        final examId = _uuid.v4();
        await _examRepo.createExamination(
          id: examId,
          patientId: widget.patientId,
          examinationType: _examinationType,
          dateTime: DateTime.now(),
          doctorNotes: null,
          previousDataRange: _previousDataRange,
        );
        _draftExaminationId = examId;
      }

      // Step 2: Save image to local storage + DB if not already saved.
      if (_savedImageId == null) {
        final extension =
            _selectedImageOriginalName?.split('.').last.toLowerCase() ??
                'unknown';

        final savedPath = await _imageStorage.saveImage(
          patientId: widget.patientId,
          examinationId: _draftExaminationId!,
          originalFilePath: imageFile.path,
        );

        final imageId = _uuid.v4();

        await _imageRepo.createMedicalImage(
          id: imageId,
          examinationId: _draftExaminationId!,
          filePath: savedPath,
          originalFileName: _selectedImageOriginalName ?? 'unknown',
          fileFormat: extension,
          modality: _activeModality,
          clinicalDate: DateTime.now(),
        );

        _savedImageId = imageId;
        _savedImagePath = savedPath;
      }

      // Step 3: Run ONNX inference using the correct model.
      final inferenceFile = File(_savedImagePath ?? imageFile.path);

      if (_isBrainTumorActive) {
        final service = BrainTumorInferenceService.instance;
        await service.initialize();
        final result = await service.analyzeImage(inferenceFile);
        if (!mounted) return;
        setState(() {
          _brainTumorResult = result;
          _inferenceCompleted = true;
          _runningInference = false;
        });
      } else {
        final service = OnnxInferenceService.instance;
        await service.initialize();
        final result = await service.analyzeImage(inferenceFile);
        if (!mounted) return;
        setState(() {
          _inferenceResult = result;
          _inferenceCompleted = true;
          _runningInference = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _inferenceError = 'AI analysis failed: $e';
        _runningInference = false;
      });
    }
  }

  /// Save the full examination with inference result and doctor notes.
  Future<void> _saveExamination() async {
    if (_examinationSaved) return; // Idempotent guard
    if (_draftExaminationId == null) return;
    if (_inferenceResult == null && _brainTumorResult == null) return;

    setState(() {
      _saving = true;
      _saveError = null;
    });

    try {
      // Determine which model produced the result and persist accordingly.
      final modelId = _activeModelId ?? _bundledModelId!;
      final versionId = _installedModels
          .where((m) => m.model.id == modelId)
          .map((m) => m.version.id)
          .firstOrNull ??
          (_isBrainTumorActive
              ? MedicalModelRepository.brainTumorVersionId
              : _bundledVersionId!);

      if (_brainTumorResult != null) {
        final result = _brainTumorResult!;
        await _runRepo.saveSuccessfulBrainTumorRun(
          runId: _uuid.v4(),
          resultId: _uuid.v4(),
          findingId: _uuid.v4(),
          examinationId: _draftExaminationId!,
          modelId: modelId,
          modelVersionId: versionId,
          inputImageId: _savedImageId!,
          inputImageDate: DateTime.now(),
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
      } else {
        final result = _inferenceResult!;
        await _runRepo.saveSuccessfulRun(
          runId: _uuid.v4(),
          resultId: _uuid.v4(),
          findingId: _uuid.v4(),
          examinationId: _draftExaminationId!,
          modelId: modelId,
          modelVersionId: versionId,
          inputImageId: _savedImageId!,
          inputImageDate: DateTime.now(),
          executionTimestamp: result.executedAt,
          prediction: result.prediction,
          confidence: result.confidence,
          normalProbability: result.normalProbability,
          pneumoniaProbability: result.pneumoniaProbability,
        );
      }

      // Update examination with notes and status.
      final notes = _notesController.text.trim();
      await _examRepo.updateExamination(
        examinationId: _draftExaminationId!,
        doctorNotes: notes.isEmpty ? null : notes,
        status: 'COMPLETED',
      );

      if (!mounted) return;

      setState(() {
        _saving = false;
        _examinationSaved = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Examination saved successfully')),
      );

      // Navigate back, signaling success.
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _saveError = 'Failed to save examination: $e';
      });
    }
  }

  /// Warn about unsaved work before navigating away.
  Future<bool> _confirmDiscard() async {
    // Only warn if meaningful work has been done.
    if (_selectedImageFile == null && !_inferenceCompleted) {
      return true;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        final dlgColors = WisteriaColors.of(context);
        return AlertDialog(
          backgroundColor: dlgColors.surfaceContainer,
          title: Text(
            'Discard Examination?',
            style: TextStyle(
              color: dlgColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'You have unsaved clinical work. If you navigate away, the AI analysis result '
            'and any diagnostic notes will be permanently lost.',
            style: TextStyle(color: dlgColors.textSecondary, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Stay in Workflow'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: dlgColors.error,
                foregroundColor: dlgColors.textOnPrimary,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Discard'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  /// Handles back navigation safely without popping the parent route.
  Future<void> _handleBackNavigation() async {
    if (_isNavigatingBack) return;

    if (_selectedSpecialty != null) {
      final shouldDiscard = await _confirmDiscard();
      if (shouldDiscard && mounted) {
        setState(() {
          _selectedSpecialty = null;
          _selectedImageFile = null;
          _selectedImageOriginalName = null;
          _savedImageId = null;
          _savedImagePath = null;
          _inferenceResult = null;
          _brainTumorResult = null;
          _inferenceCompleted = false;
          _notesController.clear();
        });
      }
      return;
    }

    if (_examinationSaved) {
      _isNavigatingBack = true;
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
      }
      return;
    }

    final shouldDiscard = await _confirmDiscard();
    if (shouldDiscard && mounted) {
      _isNavigatingBack = true;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(false);
      }
    }
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);

    return PopScope(
      canPop: _isNavigatingBack,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBackNavigation();
      },
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Column(
            children: [
              // ── Top Navigation Bar ──
              _buildTopBar(colors),

              // ── Main Responsive Content Area ──
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 16, 28, 40),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: _selectedSpecialty == null ? 1160 : 1440,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Specialty selection (Stage 0) or active examination workflow (Stages A-E)
                          if (_selectedSpecialty == null) ...[
                            _buildSpecialtySelection(colors),
                          ] else ...[
                            _buildActiveExaminationWorkflow(colors),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Top Navigation Bar ──

  Widget _buildTopBar(WisteriaColorPalette colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border(
          bottom: BorderSide(
            color: colors.borderSubtle,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          WisteriaBackButton(
            label: _selectedSpecialty != null ? 'Specialties' : 'Patient Details',
            onTap: _handleBackNavigation,
          ),
          const SizedBox(width: 16),
          Container(
            height: 16,
            width: 1,
            color: colors.border,
          ),
          const SizedBox(width: 16),
          Text(
            'New Clinical Examination',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: colors.textMuted,
              letterSpacing: 0.2,
            ),
          ),
          const Spacer(),
          // Patient Identity Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              borderRadius: BorderRadius.circular(WisteriaRadius.sm),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  size: 15,
                  color: colors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.patientName} · ${widget.patientId}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Stage 0: Specialty Selection ──

  Widget _buildSpecialtySelection(WisteriaColorPalette colors) {
    final cards = [
      _SpecialtyCard(
        name: 'Cardiology',
        subtitle: 'Pneumonia Detection · Chest X-Ray',
        description:
            'Automated ResNet-18 neural network analysis for pulmonary opacity, consolidation, and acute bacterial or viral pneumonia screening.',
        imagePath: 'assets/images/cardiology.jpg',
        modality: 'CHEST X-RAY',
        icon: Icons.favorite_rounded,
        accentColor: const Color(0xFF098FA6),
        isComingSoon: false,
        onTap: () {
          setState(() {
            _selectedSpecialty = 'Cardiology';
          });
        },
      ),
      _SpecialtyCard(
        name: 'Neurology',
        subtitle: 'Brain Tumor Detection · MRI',
        description:
            'Multi-class brain MRI scan classification to detect and categorize glioma, meningioma, and pituitary tumors from normal tissue.',
        imagePath: 'assets/images/neurology.jpg',
        modality: 'BRAIN MRI',
        icon: Icons.psychology_rounded,
        accentColor: const Color(0xFF8E24AA),
        isComingSoon: false,
        onTap: () {
          setState(() {
            _selectedSpecialty = 'Neurology';
          });
        },
      ),
      _SpecialtyCard(
        name: 'Ophthalmology',
        subtitle: 'Eye & Vision · Coming Soon',
        description:
            'Automated retinal fundus photography and optical coherence tomography (OCT) diagnostics for diabetic retinopathy and maculopathy.',
        imagePath: 'assets/images/ophthalmology.jpg',
        modality: 'RETINAL / OCT',
        icon: Icons.visibility_rounded,
        accentColor: const Color(0xFF0288D1),
        isComingSoon: true,
        onTap: null, // Disabled: prevents launching unavailable workflow
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Page Header
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Icon(
                Icons.biotech_rounded,
                color: colors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Medical Specialty',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Choose the clinical area for this examination to load the appropriate deep-learning AI model.',
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Three spacious horizontal cards stacked vertically (Option B)
        cards[0],
        const SizedBox(height: 20),
        cards[1],
        const SizedBox(height: 20),
        cards[2],
      ],
    );
  }

  // ── Active Examination Workflow (Stages A to E) ──

  Widget _buildActiveExaminationWorkflow(WisteriaColorPalette colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Active Specialty & Patient Context Strip
        _buildActiveSpecialtyHeader(colors),

        const SizedBox(height: 24),

        // Responsive 2-Column Clinical PACS Workstation Layout
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 1000;

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Medical Image Viewer & Clinical Guidance
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStageA(colors),
                        const SizedBox(height: 20),
                        _buildClinicalDisclaimer(colors),
                      ],
                    ),
                  ),

                  const SizedBox(width: 24),

                  // Right Column: AI Analysis, Diagnostic Results, Doctor Notes, Save
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStageB(colors),
                        if (_inferenceCompleted &&
                            (_inferenceResult != null ||
                                _brainTumorResult != null)) ...[
                          const SizedBox(height: 20),
                          _buildStageC(colors),
                        ],
                        if (_inferenceCompleted) ...[
                          const SizedBox(height: 20),
                          _buildStageD(colors),
                          const SizedBox(height: 20),
                          _buildStageE(colors),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            }

            // Single column layout for narrower viewports
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStageA(colors),
                const SizedBox(height: 20),
                _buildStageB(colors),
                if (_inferenceCompleted &&
                    (_inferenceResult != null ||
                        _brainTumorResult != null)) ...[
                  const SizedBox(height: 20),
                  _buildStageC(colors),
                ],
                if (_inferenceCompleted) ...[
                  const SizedBox(height: 20),
                  _buildStageD(colors),
                  const SizedBox(height: 20),
                  _buildStageE(colors),
                ],
                const SizedBox(height: 20),
                _buildClinicalDisclaimer(colors),
              ],
            );
          },
        ),
      ],
    );
  }

  // ── Active Specialty Context Banner ──

  Widget _buildActiveSpecialtyHeader(WisteriaColorPalette colors) {
    final isCardiology = _selectedSpecialty == 'Cardiology';
    final specialtyAccent =
        isCardiology ? colors.primary : const Color(0xFF8E24AA);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: specialtyAccent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(WisteriaRadius.sm),
              border: Border.all(
                color: specialtyAccent.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              isCardiology
                  ? Icons.favorite_rounded
                  : Icons.psychology_rounded,
              color: specialtyAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _selectedSpecialty ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: specialtyAccent.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                        border: Border.all(
                          color: specialtyAccent.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        _activeModality,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: specialtyAccent,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  isCardiology
                      ? 'Pneumonia Detection · Chest X-Ray Workflow'
                      : 'Brain Tumor Detection · MRI Workflow',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          // Change specialty button (disabled if inference finished to preserve integrity)
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.textSecondary,
              side: BorderSide(color: colors.border),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
              ),
            ),
            onPressed: _inferenceCompleted || _runningInference
                ? null
                : () {
                    setState(() {
                      _selectedSpecialty = null;
                      _selectedImageFile = null;
                      _selectedImageOriginalName = null;
                      _inferenceResult = null;
                      _brainTumorResult = null;
                      _inferenceCompleted = false;
                      _inferenceError = null;
                    });
                  },
            icon: const Icon(Icons.swap_horiz_rounded, size: 16),
            label: const Text(
              'Change',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stage A: Examination Setup & Medical Image Viewer ──

  Widget _buildStageA(WisteriaColorPalette colors) {
    return _buildSection(
      number: '1',
      title: 'Examination Setup',
      icon: Icons.assignment_outlined,
      colors: colors,
      children: [
        // Patient Information Context Row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Row(
            children: [
              Icon(Icons.person_outline_rounded, size: 16, color: colors.primary),
              const SizedBox(width: 8),
              Text(
                widget.patientName,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '·',
                style: TextStyle(color: colors.textMuted),
              ),
              const SizedBox(width: 8),
              Text(
                widget.patientId,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        // Medical Image Section Header
        Row(
          children: [
            Icon(Icons.image_outlined, size: 16, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              'Medical Image',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        if (_selectedImageFile != null)
          _buildSelectedImagePreview(colors)
        else
          _buildImagePicker(colors),
      ],
    );
  }

  Widget _buildImagePicker(WisteriaColorPalette colors) {
    return InkWell(
      borderRadius: BorderRadius.circular(WisteriaRadius.sm),
      onTap: _runningInference ? null : _pickImage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(WisteriaRadius.sm),
          border: Border.all(
            color: colors.border,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                size: 26,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              _isBrainTumorActive
                  ? 'Click to select a brain MRI image'
                  : 'Click to select a chest X-ray image',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'JPG, PNG, WebP, BMP',
              style: TextStyle(
                fontSize: 12,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.tonalIcon(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                ),
              ),
              onPressed: _runningInference ? null : _pickImage,
              icon: const Icon(Icons.folder_open_rounded, size: 16),
              label: const Text(
                'Browse Image File',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImagePreview(WisteriaColorPalette colors) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medical Image PACS Display Canvas
          Container(
            width: double.infinity,
            height: 340,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(WisteriaRadius.sm),
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: Image.file(
                    _selectedImageFile!,
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, err, stack) => Icon(
                      Icons.broken_image_outlined,
                      size: 48,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      _activeModality,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Metadata and change image bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.insert_drive_file_outlined,
                  size: 18,
                  color: colors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedImageOriginalName ?? 'Selected Medical Image',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _selectedImageFile!.path,
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.textMuted,
                          fontFamily: 'monospace',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (!_inferenceCompleted)
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: colors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                    ),
                    onPressed: _runningInference ? null : _pickImage,
                    icon: const Icon(Icons.refresh_rounded, size: 15),
                    label: const Text(
                      'Replace',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Clinical Disclaimer ──

  Widget _buildClinicalDisclaimer(WisteriaColorPalette colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_user_outlined,
            size: 20,
            color: colors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Wisteria Clinical AI operates entirely offline using local ONNX neural network execution. '
              'Inference results are assistive diagnostic aids and do not replace professional medical judgment.',
              style: TextStyle(
                fontSize: 12,
                color: colors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stage B: AI Analysis ──

  Widget _buildStageB(WisteriaColorPalette colors) {
    return _buildSection(
      number: '2',
      title: 'AI Analysis',
      icon: Icons.memory_rounded,
      colors: colors,
      children: [
        if (_loadingModel)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: CircularProgressIndicator(color: colors.primary),
            ),
          )
        else if (_modelError != null)
          _buildErrorCard(_modelError!, colors)
        else ...[
          // Model card
          Builder(
            builder: (_) {
              final catalog = _activeModelId != null
                  ? SystemModelCatalog.getById(_activeModelId!)
                  : null;
              final modelName = catalog?.displayName ??
                  (_isBrainTumorActive
                      ? 'Brain Tumor ResNet18'
                      : 'Pneumonia ResNet18');
              final modelMeta = catalog != null
                  ? '${catalog.task} · ${catalog.modality} · ${catalog.runtime} · v${catalog.version}'
                  : (_isBrainTumorActive
                      ? 'Tumor Classification · MRI · ONNX Runtime · v1.0.0'
                      : 'Pneumonia Classification · X-Ray · ONNX Runtime · v1.0.0');

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                      ),
                      child: Icon(
                        Icons.developer_board_rounded,
                        size: 20,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            modelName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            modelMeta,
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.textMuted,
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
                        color: colors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                        border: Border.all(
                          color: colors.success.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        'LOCAL ONNX',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: colors.success,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 18),

          // Run Inference Button
          if (!_inferenceCompleted)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                  ),
                ),
                onPressed: _runningInference ||
                        _selectedImageFile == null ||
                        !_modelAvailable
                    ? null
                    : _runAIAnalysis,
                icon: _runningInference
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.textOnPrimary,
                        ),
                      )
                    : const Icon(Icons.play_arrow_rounded, size: 20),
                label: Text(
                  _runningInference
                      ? 'Executing Neural Inference...'
                      : _selectedImageFile == null
                          ? 'Select an image first'
                          : 'Run $_activeModelDisplayName Analysis',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          if (_runningInference) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              color: colors.primary,
              backgroundColor: colors.surfaceContainer,
            ),
          ],

          if (_inferenceError != null) ...[
            const SizedBox(height: 14),
            _buildErrorCard(_inferenceError!, colors),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _runningInference ? null : _runAIAnalysis,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retry AI Inference'),
              ),
            ),
          ],

          if (_inferenceCompleted)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                border: Border.all(
                  color: colors.success.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: colors.success,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'AI analysis completed successfully',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.success,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }

  // ── Stage C: AI Results ──

  Widget _buildStageC(WisteriaColorPalette colors) {
    if (_brainTumorResult != null) {
      return _buildStageCBrainTumor(_brainTumorResult!, colors);
    }
    return _buildStageCPneumonia(_inferenceResult!, colors);
  }

  Widget _buildStageCPneumonia(
    PneumoniaInferenceResult result,
    WisteriaColorPalette colors,
  ) {
    final isPneumonia = result.prediction == 'PNEUMONIA';
    final alertColor = isPneumonia ? colors.warning : colors.success;

    return _buildSection(
      number: '3',
      title: 'AI Classification Findings',
      icon: Icons.analytics_outlined,
      colors: colors,
      children: [
        // Primary Prediction Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: alertColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            border: Border.all(
              color: alertColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: alertColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                ),
                child: Icon(
                  isPneumonia
                      ? Icons.warning_amber_rounded
                      : Icons.check_circle_outline_rounded,
                  color: alertColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.prediction,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: alertColor,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Model Confidence: ${(result.confidence * 100).toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Probability Distribution Bars
        _buildProbabilityBar(
          label: 'NORMAL',
          percentage: result.normalProbability,
          color: colors.success,
          colors: colors,
        ),
        const SizedBox(height: 10),
        _buildProbabilityBar(
          label: 'PNEUMONIA',
          percentage: result.pneumoniaProbability,
          color: colors.warning,
          colors: colors,
        ),

        const SizedBox(height: 16),

        _buildResultRow('Model Identifier', 'Pneumonia ResNet-18 (v1.0.0)', colors),
        _buildResultRow('Execution Timestamp', _formatDateTime(result.executedAt), colors),

        const SizedBox(height: 12),
        _buildAILabel(colors),
      ],
    );
  }

  Widget _buildStageCBrainTumor(
    BrainTumorInferenceResult result,
    WisteriaColorPalette colors,
  ) {
    final isNoTumor = result.prediction == 'notumor';
    final displayName = BrainTumorInferenceService.classDisplayNames[
        BrainTumorInferenceService.classLabels.indexOf(result.prediction)];
    final alertColor = isNoTumor ? colors.success : colors.warning;

    return _buildSection(
      number: '3',
      title: 'AI Classification Findings',
      icon: Icons.analytics_outlined,
      colors: colors,
      children: [
        // Primary Prediction Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: alertColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            border: Border.all(
              color: alertColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: alertColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                ),
                child: Icon(
                  isNoTumor
                      ? Icons.check_circle_outline_rounded
                      : Icons.warning_amber_rounded,
                  color: alertColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: alertColor,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Model Confidence: ${(result.confidence * 100).toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Multi-class probability bars
        _buildProbabilityBar(
          label: 'Glioma',
          percentage: result.gliomaScore,
          color: const Color(0xFFE53935),
          colors: colors,
        ),
        const SizedBox(height: 8),
        _buildProbabilityBar(
          label: 'Meningioma',
          percentage: result.meningiomaScore,
          color: const Color(0xFFFB8C00),
          colors: colors,
        ),
        const SizedBox(height: 8),
        _buildProbabilityBar(
          label: 'Pituitary',
          percentage: result.pituitaryScore,
          color: const Color(0xFF8E24AA),
          colors: colors,
        ),
        const SizedBox(height: 8),
        _buildProbabilityBar(
          label: 'No Tumor',
          percentage: result.noTumorScore,
          color: colors.success,
          colors: colors,
        ),

        const SizedBox(height: 16),

        _buildResultRow('Model Identifier', 'Brain Tumor ResNet-18 (v1.0.0)', colors),
        _buildResultRow('Execution Timestamp', _formatDateTime(result.executedAt), colors),

        const SizedBox(height: 12),
        _buildAILabel(colors),
      ],
    );
  }

  Widget _buildProbabilityBar({
    required String label,
    required double percentage,
    required Color color,
    required WisteriaColorPalette colors,
  }) {
    final pctString = (percentage * 100).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
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
                  fontWeight: FontWeight.w600,
                  color: percentage > 0.4 ? color : colors.textMuted,
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
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAILabel(WisteriaColorPalette colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_outlined,
            size: 13,
            color: colors.primary,
          ),
          const SizedBox(width: 6),
          Text(
            'Automated Local AI Evaluation',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ── Stage D: Doctor Notes ──

  Widget _buildStageD(WisteriaColorPalette colors) {
    return _buildSection(
      number: '4',
      title: 'Clinical Observations & Notes',
      icon: Icons.edit_note_rounded,
      colors: colors,
      children: [
        Text(
          'Record clinician assessment, clinical correlation, and treatment notes for this examination.',
          style: TextStyle(
            fontSize: 12,
            color: colors.textMuted,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _notesController,
          maxLines: 4,
          style: TextStyle(color: colors.textPrimary, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Enter clinical observations, assessment, and next steps...',
            hintStyle: TextStyle(color: colors.textMuted, fontSize: 13),
            fillColor: colors.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(WisteriaRadius.sm),
              borderSide: BorderSide(color: colors.border),
            ),
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }

  // ── Stage E: Save Examination ──

  Widget _buildStageE(WisteriaColorPalette colors) {
    return _buildSection(
      number: '5',
      title: 'Finalize Examination',
      icon: Icons.save_outlined,
      colors: colors,
      children: [
        if (_saveError != null) ...[
          _buildErrorCard(_saveError!, colors),
          const SizedBox(height: 16),
        ],

        Text(
          'Commit the AI inference findings, medical image reference, and clinical notes to the patient record.',
          style: TextStyle(
            fontSize: 12,
            color: colors.textMuted,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),

        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor:
                  _examinationSaved ? colors.success : colors.primary,
              foregroundColor: colors.textOnPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
              ),
            ),
            onPressed:
                _saving || _examinationSaved ? null : _saveExamination,
            icon: _saving
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.textOnPrimary,
                    ),
                  )
                : _examinationSaved
                    ? const Icon(Icons.check_rounded, size: 20)
                    : const Icon(Icons.save_rounded, size: 20),
            label: Text(
              _saving
                  ? 'Committing to Patient Record...'
                  : _examinationSaved
                      ? 'Examination Saved'
                      : 'Save & Complete Examination',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Reusable Section Container ──

  Widget _buildSection({
    required String number,
    required String title,
    required IconData icon,
    required WisteriaColorPalette colors,
    required List<Widget> children,
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
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Center(
                  child: Text(
                    number,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                icon,
                size: 18,
                color: colors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

  Widget _buildResultRow(
    String label,
    String value,
    WisteriaColorPalette colors,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colors.textMuted,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String message, WisteriaColorPalette colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(
          color: colors.error.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 18,
            color: colors.error,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: colors.error,
                height: 1.4,
              ),
            ),
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
    return '$day/$month/$year · $hour:$minute $period';
  }
}

// ── Specialty Card Component with Image, Hover & Theme Adaptation ──

class _SpecialtyCard extends StatefulWidget {
  final String name;
  final String subtitle;
  final String description;
  final String imagePath;
  final String modality;
  final IconData icon;
  final Color accentColor;
  final bool isComingSoon;
  final VoidCallback? onTap;

  const _SpecialtyCard({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.modality,
    required this.icon,
    required this.accentColor,
    required this.isComingSoon,
    required this.onTap,
  });

  @override
  State<_SpecialtyCard> createState() => _SpecialtyCardState();
}

class _SpecialtyCardState extends State<_SpecialtyCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = !widget.isComingSoon && widget.onTap != null;

    final borderColor = isEnabled && _isHovered
        ? colors.primary.withValues(alpha: 0.75)
        : colors.border;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 680;
        final imageWidth = isCompact
            ? double.infinity
            : (constraints.maxWidth * 0.30).clamp(240.0, 320.0);

        Widget imagePanel = SizedBox(
          width: imageWidth,
          height: isCompact ? 140 : 165,
          child: ClipRRect(
            borderRadius: isCompact
                ? BorderRadius.vertical(top: Radius.circular(WisteriaRadius.sm))
                : BorderRadius.horizontal(
                    left: Radius.circular(WisteriaRadius.sm),
                  ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  color: isDark
                      ? const Color(0xFF0D131A)
                      : colors.surfaceContainer,
                ),
                Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => Container(
                    color: colors.surfaceContainer,
                    child: Icon(
                      widget.icon,
                      size: 40,
                      color: colors.textMuted,
                    ),
                  ),
                ),
                // Subtle gradient overlay for optimal badge contrast
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.45, 1.0],
                      colors: isDark
                          ? [
                              Colors.black.withValues(alpha: 0.20),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.65),
                            ]
                          : [
                              Colors.black.withValues(alpha: 0.12),
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.50),
                            ],
                    ),
                  ),
                ),
                // Modality Badge (Bottom Left)
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(widget.icon, size: 12, color: Colors.white),
                        const SizedBox(width: 5),
                        Text(
                          widget.modality,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        Widget contentWidget = Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 16 : 24,
            vertical: isCompact ? 14 : 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Availability Badge
                  if (widget.isComingSoon)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE65100).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                        border: Border.all(
                          color: const Color(0xFFE65100).withValues(alpha: 0.35),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 11,
                            color: Color(0xFFE65100),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'COMING SOON',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFE65100),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 11,
                            color: colors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'ACTIVE AI',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: colors.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                widget.subtitle,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: widget.isComingSoon ? colors.textMuted : colors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 12.5,
                  color: colors.textSecondary,
                  height: 1.45,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );

        Widget actionWidget = Padding(
          padding: EdgeInsets.only(
            right: isCompact ? 16 : 24,
            left: isCompact ? 16 : 12,
            bottom: isCompact ? 16 : 0,
          ),
          child: widget.isComingSoon
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainer,
                    borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    border: Border.all(color: colors.borderSubtle),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 14,
                        color: colors.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Unavailable',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colors.textMuted,
                        ),
                      ),
                    ],
                  ),
                )
              : AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _isHovered ? colors.primary : colors.surfaceContainer,
                    borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    border: Border.all(
                      color: _isHovered ? colors.primary : colors.border,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Select Specialty',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: _isHovered
                              ? colors.textOnPrimary
                              : colors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: _isHovered
                            ? colors.textOnPrimary
                            : colors.primary,
                      ),
                    ],
                  ),
                ),
        );

        return MouseRegion(
          cursor: isEnabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          onEnter: (_) {
            if (isEnabled) setState(() => _isHovered = true);
          },
          onExit: (_) {
            if (isEnabled) setState(() => _isHovered = false);
          },
          child: GestureDetector(
            onTap: isEnabled ? widget.onTap : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              transform: Matrix4.translationValues(
                0,
                isEnabled && _isHovered ? -2 : 0,
                0,
              ),
              decoration: BoxDecoration(
                color: colors.surfaceLow,
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                border: Border.all(
                  color: borderColor,
                  width: isEnabled && _isHovered ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: isEnabled && _isHovered ? 16 : 4,
                    offset: Offset(0, isEnabled && _isHovered ? 5 : 2),
                    color: Colors.black.withValues(
                      alpha: isDark
                          ? (isEnabled && _isHovered ? 0.35 : 0.16)
                          : (isEnabled && _isHovered ? 0.10 : 0.03),
                    ),
                  ),
                ],
              ),
              child: isCompact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imagePanel,
                        contentWidget,
                        actionWidget,
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        imagePanel,
                        Expanded(child: contentWidget),
                        actionWidget,
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

// ── Data classes ──

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

