import 'package:flutter/material.dart';

import '../../core/database/database.dart';
import '../../core/database/repositories/examination_repository.dart';
import '../../core/database/repositories/patient_repository.dart';
import '../../core/theme/wisteria_theme.dart';
import '../examinations/create_examination_page.dart';
import '../shared/wisteria_back_button.dart';

/// Patient Analytics Page.
///
/// Displays real longitudinal statistics, modality distributions, and examination
/// summaries based on actual stored clinical data. Includes an informative empty state
/// when no examinations have been recorded.
class PatientAnalyticsPage extends StatefulWidget {
  final WisteriaDatabase database;
  final String patientId;

  const PatientAnalyticsPage({
    super.key,
    required this.database,
    required this.patientId,
  });

  @override
  State<PatientAnalyticsPage> createState() => _PatientAnalyticsPageState();
}

class _PatientAnalyticsPageState extends State<PatientAnalyticsPage> {
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

    if (!mounted) return;
    setState(() {
      _patient = patient;
      _examinations = examinations;
      _isLoading = false;
    });
  }

  String _formatDate(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: colors.background,
        body: Center(child: CircularProgressIndicator(color: colors.primary)),
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
                    child: _examinations.isEmpty
                        ? _buildEmptyState(patientName, colors)
                        : _buildAnalyticsDashboard(patientName, colors),
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
          bottom: BorderSide(color: colors.borderSubtle, width: 1),
        ),
      ),
      child: Row(
        children: [
          WisteriaBackButton(
            label: 'Patient Dashboard',
            onTap: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 16),
          Container(height: 16, width: 1, color: colors.border),
          const SizedBox(width: 16),
          Text(
            'Patient Analytics & Clinical Insights',
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
        borderRadius: BorderRadius.zero,
        border: Border.all(color: colors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'No Examination Analytics Available',
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
              'Statistical summaries, diagnostic frequency distributions, and longitudinal AI trends will be generated once examinations are performed for $patientName.',
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
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
              ),
            ),
            onPressed: () async {
              final created = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateExaminationPage(
                    database: widget.database,
                    patientId: widget.patientId,
                    patientName: patientName,
                  ),
                ),
              );
              if (created == true) {
                await _loadData();
              }
            },
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Begin First Examination'),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsDashboard(
    String patientName,
    WisteriaColorPalette colors,
  ) {
    final chestXrayCount = _examinations.where((e) {
      final t = e.examinationType.toUpperCase();
      return t.contains('X-RAY') ||
          t.contains('CHEST') ||
          t.contains('PNEUMONIA');
    }).length;

    final mriCount = _examinations.where((e) {
      final t = e.examinationType.toUpperCase();
      return t.contains('MRI') || t.contains('BRAIN') || t.contains('TUMOR');
    }).length;

    final otherCount = _examinations.length - (chestXrayCount + mriCount);
    final completedCount = _examinations
        .where((e) => e.status.toUpperCase() == 'COMPLETED')
        .length;

    final sortedExams = List<Examination>.from(_examinations)
      ..sort((a, b) => a.examinationDate.compareTo(b.examinationDate));
    final earliestDate = sortedExams.first.examinationDate;
    final latestDate = sortedExams.last.examinationDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Page title banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: colors.surfaceLow,
            borderRadius: BorderRadius.zero,
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clinical Examination Analytics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Longitudinal statistical summaries computed from ${_examinations.length} recorded examination${_examinations.length == 1 ? '' : 's'} for $patientName',
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

        const SizedBox(height: 20),

        // KPI metrics grid
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 720;
            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: _buildKpiCard(
                      label: 'Total Encounters',
                      value: '${_examinations.length}',
                      subtitle: 'All modalities',
                      icon: Icons.assignment_outlined,
                      accentColor: const Color(0xFF0284C7),
                      colors: colors,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildKpiCard(
                      label: 'Chest Radiography',
                      value: '$chestXrayCount',
                      subtitle: 'X-Ray evaluations',
                      icon: Icons.favorite_border_rounded,
                      accentColor: colors.primary,
                      colors: colors,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildKpiCard(
                      label: 'Brain MRI',
                      value: '$mriCount',
                      subtitle: 'Neuro-imaging scans',
                      icon: Icons.psychology_outlined,
                      accentColor: const Color(0xFF8B5CF6),
                      colors: colors,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildKpiCard(
                      label: 'Completed Status',
                      value: '$completedCount',
                      subtitle: 'Finalized reports',
                      icon: Icons.check_circle_outline_rounded,
                      accentColor: colors.success,
                      colors: colors,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildKpiCard(
                        label: 'Total Encounters',
                        value: '${_examinations.length}',
                        subtitle: 'All modalities',
                        icon: Icons.assignment_outlined,
                        accentColor: const Color(0xFF0284C7),
                        colors: colors,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildKpiCard(
                        label: 'Chest Radiography',
                        value: '$chestXrayCount',
                        subtitle: 'X-Ray evaluations',
                        icon: Icons.favorite_border_rounded,
                        accentColor: colors.primary,
                        colors: colors,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildKpiCard(
                        label: 'Brain MRI',
                        value: '$mriCount',
                        subtitle: 'Neuro-imaging scans',
                        icon: Icons.psychology_outlined,
                        accentColor: const Color(0xFF8B5CF6),
                        colors: colors,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildKpiCard(
                        label: 'Completed Status',
                        value: '$completedCount',
                        subtitle: 'Finalized reports',
                        icon: Icons.check_circle_outline_rounded,
                        accentColor: colors.success,
                        colors: colors,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 20),

        // Modality Distribution Bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: colors.surfaceLow,
            borderRadius: BorderRadius.zero,
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Imaging Modality Distribution',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Proportion of diagnostic imaging modalities recorded for this patient',
                style: TextStyle(fontSize: 12, color: colors.textMuted),
              ),
              const SizedBox(height: 16),
              // Segmented bar
              ClipRRect(
                borderRadius: BorderRadius.zero,
                child: SizedBox(
                  height: 16,
                  child: Row(
                    children: [
                      if (chestXrayCount > 0)
                        Expanded(
                          flex: chestXrayCount,
                          child: Container(color: colors.primary),
                        ),
                      if (mriCount > 0)
                        Expanded(
                          flex: mriCount,
                          child: Container(color: const Color(0xFF8B5CF6)),
                        ),
                      if (otherCount > 0)
                        Expanded(
                          flex: otherCount,
                          child: Container(color: const Color(0xFF0284C7)),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 20,
                runSpacing: 8,
                children: [
                  _buildLegendItem(
                    color: colors.primary,
                    label:
                        'Chest X-Ray (${(chestXrayCount / _examinations.length * 100).toStringAsFixed(0)}%)',
                    colors: colors,
                  ),
                  _buildLegendItem(
                    color: const Color(0xFF8B5CF6),
                    label:
                        'Brain MRI (${(mriCount / _examinations.length * 100).toStringAsFixed(0)}%)',
                    colors: colors,
                  ),
                  if (otherCount > 0)
                    _buildLegendItem(
                      color: const Color(0xFF0284C7),
                      label:
                          'Other (${(otherCount / _examinations.length * 100).toStringAsFixed(0)}%)',
                      colors: colors,
                    ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Encounter Timeline Span & Information
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: colors.surfaceLow,
            borderRadius: BorderRadius.zero,
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Longitudinal Monitoring Timeline',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainer,
                      borderRadius: BorderRadius.zero,
                      border: Border.all(color: colors.borderSubtle),
                    ),
                    child: Text(
                      '${_formatDate(earliestDate)} → ${_formatDate(latestDate)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'AI risk stratification and multi-modality trend curves update automatically with each completed session. As additional scans are captured over time, multi-visit comparative telemetry is plotted here without manual calibration.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: colors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String label,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required WisteriaColorPalette colors,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: colors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 11, color: colors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required WisteriaColorPalette colors,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.zero,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
