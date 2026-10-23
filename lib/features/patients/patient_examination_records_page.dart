import 'package:flutter/material.dart';

import '../../core/database/database.dart';
import '../../core/database/repositories/examination_repository.dart';
import '../../core/database/repositories/patient_repository.dart';
import '../../core/theme/wisteria_theme.dart';
import '../examinations/create_examination_page.dart';
import '../examinations/examination_details_page.dart';
import '../shared/wisteria_back_button.dart';

/// Patient Examination Records Page.
///
/// Dedicated full-screen repository of all saved clinical examinations,
/// status tracking, and AI diagnostic runs for the selected patient.
class PatientExaminationRecordsPage extends StatefulWidget {
  final WisteriaDatabase database;
  final String patientId;

  const PatientExaminationRecordsPage({
    super.key,
    required this.database,
    required this.patientId,
  });

  @override
  State<PatientExaminationRecordsPage> createState() =>
      _PatientExaminationRecordsPageState();
}

class _PatientExaminationRecordsPageState
    extends State<PatientExaminationRecordsPage> {
  late final PatientRepository _patientRepository;
  late final ExaminationRepository _examinationRepository;

  Patient? _patient;
  List<Examination> _examinations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _patientRepository = PatientRepository(widget.database);
    _examinationRepository = ExaminationRepository(widget.database);
    _loadData();
  }

  Future<void> _loadData() async {
    final patient = await _patientRepository.getPatientById(widget.patientId);
    final examinations = await _examinationRepository.getExaminationsForPatient(
      widget.patientId,
    );

    // Sort newest first
    final sortedExams = List<Examination>.from(examinations)
      ..sort((a, b) => b.examinationDate.compareTo(a.examinationDate));

    if (!mounted) return;
    setState(() {
      _patient = patient;
      _examinations = sortedExams;
      _isLoading = false;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();

    final hour = dateTime.hour == 0
        ? 12
        : dateTime.hour > 12
            ? dateTime.hour - 12
            : dateTime.hour;

    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$day/$month/$year · $hour:$minute $period';
  }

  Future<void> _startNewExamination() async {
    final patient = _patient;
    if (patient == null) return;

    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateExaminationPage(
          database: widget.database,
          patientId: patient.id,
          patientName: patient.name,
        ),
      ),
    );

    if (created == true && mounted) {
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(
          child: CircularProgressIndicator(color: colors.primary),
        ),
      );
    }

    final patientName = _patient?.name ?? 'Patient';

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Navigation Bar ──
            _buildTopBar(colors),

            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header banner
                        _buildHeaderBanner(patientName, colors),

                        const SizedBox(height: 24),

                        // Examination List or Empty State
                        if (_examinations.isEmpty)
                          _buildEmptyState(patientName, colors)
                        else
                          _buildExaminationsList(colors),
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
            label: 'Patient Dashboard',
            onTap: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 16),
          Container(
            height: 16,
            width: 1,
            color: colors.border,
          ),
          const SizedBox(width: 16),
          Text(
            'Recorded Examinations Archive',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: colors.textMuted,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner(String patientName, WisteriaColorPalette colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF0D9488).withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: Color(0xFF0D9488),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Examination Records',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_examinations.length} saved examination${_examinations.length == 1 ? '' : 's'} with AI diagnostic findings for $patientName',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.textOnPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _startNewExamination,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('New Examination'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String patientName, WisteriaColorPalette colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.borderSubtle),
            ),
            child: Icon(
              Icons.folder_open_outlined,
              size: 32,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No Examinations Recorded',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Text(
              'No clinical diagnostic runs or AI evaluations have been created for $patientName yet. Start a new examination to capture imaging and run AI inference.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: colors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.textOnPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _startNewExamination,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Begin First Examination'),
          ),
        ],
      ),
    );
  }

  Widget _buildExaminationsList(WisteriaColorPalette colors) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _examinations.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final exam = _examinations[index];
        final isMri = exam.examinationType.toUpperCase().contains('MRI') ||
            exam.examinationType.toUpperCase().contains('BRAIN');

        return _ExaminationRecordCard(
          examination: exam,
          formattedDate: _formatDateTime(exam.examinationDate),
          isMri: isMri,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ExaminationDetailsPage(
                  database: widget.database,
                  examinationId: exam.id,
                ),
              ),
            );
            if (mounted) {
              await _loadData();
            }
          },
        );
      },
    );
  }
}

class _ExaminationRecordCard extends StatefulWidget {
  final Examination examination;
  final String formattedDate;
  final bool isMri;
  final VoidCallback onTap;

  const _ExaminationRecordCard({
    required this.examination,
    required this.formattedDate,
    required this.isMri,
    required this.onTap,
  });

  @override
  State<_ExaminationRecordCard> createState() => _ExaminationRecordCardState();
}

class _ExaminationRecordCardState extends State<_ExaminationRecordCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isCompleted =
        widget.examination.status.trim().toUpperCase() == 'COMPLETED';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _isHovered
                ? (isDark ? colors.surfaceContainer : colors.surface)
                : colors.surfaceLow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isHovered
                  ? colors.primary.withValues(alpha: 0.6)
                  : colors.border,
              width: 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.transparent
                      : (widget.isMri
                          ? const Color(0xFF8E24AA).withValues(alpha: 0.10)
                          : colors.primary.withValues(alpha: 0.10)),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.isMri
                        ? const Color(0xFF8E24AA).withValues(alpha: 0.25)
                        : colors.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Icon(
                  widget.isMri
                      ? Icons.psychology_outlined
                      : Icons.favorite_border_rounded,
                  color: isDark
                      ? (widget.isMri ? const Color(0xFFCE93D8) : Colors.white)
                      : (widget.isMri
                          ? const Color(0xFF8E24AA)
                          : colors.primary),
                  size: 24,
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
                          widget.examination.examinationType,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
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
                            color: isCompleted
                                ? colors.success.withValues(alpha: 0.12)
                                : colors.warning.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isCompleted
                                  ? colors.success.withValues(alpha: 0.25)
                                  : colors.warning.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Text(
                            widget.examination.status,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isCompleted
                                  ? colors.success
                                  : colors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
                    if (widget.examination.doctorNotes != null &&
                        widget.examination.doctorNotes!.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        widget.examination.doctorNotes!,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: colors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Report',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: colors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
