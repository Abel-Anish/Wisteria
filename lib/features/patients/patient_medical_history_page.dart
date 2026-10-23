import 'package:flutter/material.dart';

import '../../core/database/database.dart';
import '../../core/database/repositories/examination_repository.dart';
import '../../core/database/repositories/patient_repository.dart';
import '../../core/theme/wisteria_theme.dart';
import '../examinations/examination_details_page.dart';
import '../shared/wisteria_back_button.dart';

/// Patient Medical History & Trends Page.
///
/// Displays chronological clinical encounter history, previous medical conditions,
/// medications, and prior test results stored in the database for the selected patient.
class PatientMedicalHistoryPage extends StatefulWidget {
  final WisteriaDatabase database;
  final String patientId;

  const PatientMedicalHistoryPage({
    super.key,
    required this.database,
    required this.patientId,
  });

  @override
  State<PatientMedicalHistoryPage> createState() =>
      _PatientMedicalHistoryPageState();
}

class _PatientMedicalHistoryPageState extends State<PatientMedicalHistoryPage> {
  late final PatientRepository _patientRepository;
  late final ExaminationRepository _examinationRepository;

  Patient? _patient;
  List<Examination> _examinations = [];
  List<PreviousMedicalInformation> _conditions = [];
  List<PreviousMedication> _medications = [];
  List<PreviousTestResult> _priorTests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _patientRepository = PatientRepository(widget.database);
    _examinationRepository = ExaminationRepository(widget.database);
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final patient = await _patientRepository.getPatientById(widget.patientId);
    final examinations = await _examinationRepository.getExaminationsForPatient(
      widget.patientId,
    );

    // Query previous medical information tables
    final conditions = await (widget.database.select(
      widget.database.previousMedicalInformations,
    )..where((tbl) => tbl.patientId.equals(widget.patientId))).get();

    final medications = await (widget.database.select(
      widget.database.previousMedications,
    )..where((tbl) => tbl.patientId.equals(widget.patientId))).get();

    final priorTests = await (widget.database.select(
      widget.database.previousTestResults,
    )..where((tbl) => tbl.patientId.equals(widget.patientId))).get();

    // Sort examinations chronologically (newest first for timeline)
    final sortedExams = List<Examination>.from(examinations)
      ..sort((a, b) => b.examinationDate.compareTo(a.examinationDate));

    if (!mounted) return;
    setState(() {
      _patient = patient;
      _examinations = sortedExams;
      _conditions = conditions;
      _medications = medications;
      _priorTests = priorTests;
      _isLoading = false;
    });
  }

  String _formatDateTime(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year.toString();
    final hour = dt.hour == 0 ? 12 : (dt.hour > 12 ? dt.hour - 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$day/$month/$year · $hour:$minute $ampm';
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
    final hasAnyHistory = _examinations.isNotEmpty ||
        _conditions.isNotEmpty ||
        _medications.isNotEmpty ||
        _priorTests.isNotEmpty;

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
                    child: hasAnyHistory
                        ? _buildHistoryContent(patientName, colors)
                        : _buildEmptyState(patientName, colors),
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
            'Medical History & Historical Trends',
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
              color: const Color(0xFFF43F5E).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFF43F5E).withValues(alpha: 0.25),
              ),
            ),
            child: const Icon(
              Icons.timeline_rounded,
              size: 32,
              color: Color(0xFFF43F5E),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No Medical History Recorded',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Text(
              'No previous clinical encounters, prior medications, or diagnostic history have been registered for $patientName yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: colors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryContent(String patientName, WisteriaColorPalette colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Page banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: colors.surfaceLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF43F5E).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF43F5E).withValues(alpha: 0.3)),
                ),
                child: const Icon(
                  Icons.history_edu_rounded,
                  color: Color(0xFFF43F5E),
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Historical Timeline & Encounters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Chronological progression and recorded past clinical data for $patientName',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Section: Chronological Encounter Timeline
        if (_examinations.isNotEmpty) ...[
          _buildSectionHeader(
            title: 'Diagnostic Encounters Timeline',
            subtitle: 'Chronologically ordered historical examinations',
            icon: Icons.timeline_rounded,
            color: const Color(0xFFF43F5E),
            colors: colors,
          ),
          const SizedBox(height: 14),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _examinations.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final exam = _examinations[index];
              return _buildEncounterTile(exam, colors);
            },
          ),
          const SizedBox(height: 24),
        ],

        // Section: Past Medical Conditions
        if (_conditions.isNotEmpty) ...[
          _buildSectionHeader(
            title: 'Prior Diagnoses & Medical Conditions',
            subtitle: 'Historical clinical conditions on record',
            icon: Icons.medical_services_outlined,
            color: colors.primary,
            colors: colors,
          ),
          const SizedBox(height: 14),
          ..._conditions.map((c) => _buildSimpleItemCard(
                title: c.title,
                description: c.description,
                extraInfo: c.source != null ? 'Source: ${c.source}' : null,
                colors: colors,
              )),
          const SizedBox(height: 24),
        ],

        // Section: Prior Medications
        if (_medications.isNotEmpty) ...[
          _buildSectionHeader(
            title: 'Past Medications',
            subtitle: 'Documented pharmaceuticals and dosages',
            icon: Icons.medication_outlined,
            color: const Color(0xFF8B5CF6),
            colors: colors,
          ),
          const SizedBox(height: 14),
          ..._medications.map((m) => _buildSimpleItemCard(
                title: m.medicineName,
                description: [
                  if (m.dosage != null) 'Dosage: ${m.dosage}',
                  if (m.duration != null) 'Duration: ${m.duration}',
                  if (m.reasonOrCondition != null) 'Condition: ${m.reasonOrCondition}',
                ].join(' · '),
                colors: colors,
              )),
          const SizedBox(height: 24),
        ],

        // Section: Prior Test Results
        if (_priorTests.isNotEmpty) ...[
          _buildSectionHeader(
            title: 'Prior Laboratory & Clinical Tests',
            subtitle: 'Historical lab reports and clinical summaries',
            icon: Icons.science_outlined,
            color: const Color(0xFF0284C7),
            colors: colors,
          ),
          const SizedBox(height: 14),
          ..._priorTests.map((t) => _buildSimpleItemCard(
                title: t.testName,
                description: t.summary ?? t.keyFindings ?? 'No summary recorded',
                extraInfo: t.hospitalOrClinic,
                colors: colors,
              )),
        ],
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required WisteriaColorPalette colors,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.5,
                color: colors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEncounterTile(Examination exam, WisteriaColorPalette colors) {
    final isMri = exam.examinationType.toUpperCase().contains('MRI') ||
        exam.examinationType.toUpperCase().contains('BRAIN');

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
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
            await _loadHistory();
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isMri
                        ? const Color(0xFF8B5CF6).withValues(alpha: 0.12)
                        : colors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isMri
                          ? const Color(0xFF8B5CF6).withValues(alpha: 0.25)
                          : colors.primary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Icon(
                    isMri ? Icons.psychology_outlined : Icons.favorite_border_rounded,
                    color: isMri ? const Color(0xFF8B5CF6) : colors.primary,
                    size: 22,
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
                            exam.examinationType,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: colors.surfaceContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              exam.status,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDateTime(exam.examinationDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.textMuted,
                        ),
                      ),
                      if (exam.doctorNotes != null && exam.doctorNotes!.trim().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          exam.doctorNotes!,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textSecondary,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: colors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleItemCard({
    required String title,
    required String description,
    String? extraInfo,
    required WisteriaColorPalette colors,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              if (extraInfo != null)
                Text(
                  extraInfo,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.textMuted,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 12.5,
              color: colors.textSecondary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
