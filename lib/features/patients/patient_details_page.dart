import 'package:flutter/material.dart';

import '../../core/database/database.dart';
import '../../core/database/repositories/patient_repository.dart';
import '../../core/theme/wisteria_theme.dart';
import '../examinations/create_examination_page.dart';
import '../shared/wisteria_back_button.dart';
import '../shared/wisteria_page_route.dart';
import 'patient_analytics_page.dart';
import 'patient_examination_records_page.dart';
import 'patient_information_page.dart';
import 'patient_medical_history_page.dart';
import 'widgets/patient_dashboard_card.dart';

/// Redesigned Wisteria Patient Dashboard.
///
/// Contains exactly five separate image-based cards:
/// 1. Patient Information (`assets/images/patient info.jpg`)
/// 2. New Examination (`assets/images/new examination.jpg`)
/// 3. Patient Analytics (`assets/images/patient analytics.jpg`)
/// 4. Medical History & Trends (`assets/images/medical history.jpg`)
/// 5. Examination Records (`assets/images/examination record.jpg`)
///
/// Each card navigates to its own dedicated page while maintaining
/// data integrity, smooth animations, and responsive layout across desktop
/// and smaller screens.
class PatientDetailsPage extends StatefulWidget {
  final WisteriaDatabase database;
  final String patientId;

  const PatientDetailsPage({
    super.key,
    required this.database,
    required this.patientId,
  });

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  late final PatientRepository _patientRepository;
  Patient? _patient;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _patientRepository = PatientRepository(widget.database);
    _loadPatient();
  }

  Future<void> _loadPatient() async {
    final patient = await _patientRepository.getPatientById(widget.patientId);
    if (!mounted) return;

    setState(() {
      _patient = patient;
      _isLoading = false;
    });
  }

  Future<void> _openPatientInfo() async {
    final result = await Navigator.push<dynamic>(
      context,
      WisteriaPageRoute(
        page: PatientInformationPage(
          database: widget.database,
          patientId: widget.patientId,
        ),
      ),
    );

    if (result == 'deleted') {
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } else if (result == 'updated') {
      await _loadPatient();
    }
  }

  Future<void> _openNewExamination() async {
    final patient = _patient;
    if (patient == null) return;

    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CreateExaminationPage(
          database: widget.database,
          patientId: patient.id,
          patientName: patient.name,
        ),
      ),
    );
  }

  Future<void> _openPatientAnalytics() async {
    await Navigator.push(
      context,
      WisteriaPageRoute(
        page: PatientAnalyticsPage(
          database: widget.database,
          patientId: widget.patientId,
        ),
      ),
    );
  }

  Future<void> _openMedicalHistory() async {
    await Navigator.push(
      context,
      WisteriaPageRoute(
        page: PatientMedicalHistoryPage(
          database: widget.database,
          patientId: widget.patientId,
        ),
      ),
    );
  }

  Future<void> _openExaminationRecords() async {
    await Navigator.push(
      context,
      WisteriaPageRoute(
        page: PatientExaminationRecordsPage(
          database: widget.database,
          patientId: widget.patientId,
        ),
      ),
    );
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

    if (_patient == null) {
      return Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(colors),
              Expanded(
                child: Center(
                  child: Text(
                    'Patient record not found',
                    style: TextStyle(color: colors.textSecondary, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Navigation Bar ──
            _buildTopBar(colors),

            // ── Main Dashboard Layout: Exactly Five Image Cards ──
            Expanded(
              child: LayoutBuilder(
                builder: (context, viewportConstraints) {
                  final desktopCardHeight =
                      ((viewportConstraints.maxHeight - 60 - 20) / 2).clamp(
                        225.0,
                        300.0,
                      );

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 24, 28, 36),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1320),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;

                            if (width >= 960) {
                              // Desktop layout: Row 1 has 2 cards, Row 2 has 3 cards
                              return _buildDesktopLayout(
                                cardHeight: desktopCardHeight,
                              );
                            } else if (width >= 640) {
                              // Tablet layout: 2-column adaptive layout
                              return _buildTabletLayout();
                            } else {
                              // Mobile/Narrow layout: 1-column stacked cards
                              return _buildMobileLayout();
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
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
            label: 'Patients Directory',
            onTap: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 16),
          Container(height: 16, width: 1, color: colors.border),
          const SizedBox(width: 16),
          Text(
            'Patient Record Overview',
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

  // ── Desktop Layout: 2 Cards Row 1, 3 Cards Row 2 ──
  Widget _buildDesktopLayout({required double cardHeight}) {
    return Column(
      children: [
        // Row 1: Patient Information & New Examination
        Row(
          children: [
            Expanded(child: _buildPatientInfoCard(height: cardHeight)),
            const SizedBox(width: 20),
            Expanded(child: _buildNewExaminationCard(height: cardHeight)),
          ],
        ),
        const SizedBox(height: 20),
        // Row 2: Patient Analytics, Medical History & Trends, Examination Records
        Row(
          children: [
            Expanded(child: _buildPatientAnalyticsCard(height: cardHeight)),
            const SizedBox(width: 20),
            Expanded(child: _buildMedicalHistoryCard(height: cardHeight)),
            const SizedBox(width: 20),
            Expanded(child: _buildExaminationRecordsCard(height: cardHeight)),
          ],
        ),
      ],
    );
  }

  // ── Tablet Layout: Adaptive 2 columns ──
  Widget _buildTabletLayout() {
    const cardHeight = 210.0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildPatientInfoCard(height: cardHeight)),
            const SizedBox(width: 16),
            Expanded(child: _buildNewExaminationCard(height: cardHeight)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildPatientAnalyticsCard(height: cardHeight)),
            const SizedBox(width: 16),
            Expanded(child: _buildMedicalHistoryCard(height: cardHeight)),
          ],
        ),
        const SizedBox(height: 16),
        _buildExaminationRecordsCard(height: cardHeight),
      ],
    );
  }

  // ── Mobile/Narrow Layout: Single Column Stacked ──
  Widget _buildMobileLayout() {
    const cardHeight = 195.0;

    return Column(
      children: [
        _buildPatientInfoCard(height: cardHeight),
        const SizedBox(height: 16),
        _buildNewExaminationCard(height: cardHeight),
        const SizedBox(height: 16),
        _buildPatientAnalyticsCard(height: cardHeight),
        const SizedBox(height: 16),
        _buildMedicalHistoryCard(height: cardHeight),
        const SizedBox(height: 16),
        _buildExaminationRecordsCard(height: cardHeight),
      ],
    );
  }

  // ── Card 1: Patient Information ──
  Widget _buildPatientInfoCard({required double height}) {
    return PatientDashboardCard(
      key: const Key('card_patient_info'),
      imagePath: 'assets/images/patient info.jpg',
      title: 'Patient Information',
      description: 'Clinical demographic profile & contact details',
      badgeColor: const Color(0xFF0284C7),
      height: height,
      onTap: _openPatientInfo,
    );
  }

  // ── Card 2: New Examination ──
  Widget _buildNewExaminationCard({required double height}) {
    return PatientDashboardCard(
      key: const Key('card_new_examination'),
      imagePath: 'assets/images/new examination.jpg',
      title: 'New Examination',
      description: 'AI-assisted clinical evaluation & reporting',
      badgeColor: const Color(0xFF8B5CF6),
      height: height,
      onTap: _openNewExamination,
    );
  }

  // ── Card 3: Patient Analytics ──
  Widget _buildPatientAnalyticsCard({required double height}) {
    return PatientDashboardCard(
      key: const Key('card_patient_analytics'),
      imagePath: 'assets/images/patient analytics.jpg',
      title: 'Patient Analytics',
      description:
          'Longitudinal statistical summaries, automated diagnostic trends, and AI risk stratification',
      badgeColor: const Color(0xFF0891B2),
      height: height,
      onTap: _openPatientAnalytics,
    );
  }

  // ── Card 4: Medical History & Trends ──
  Widget _buildMedicalHistoryCard({required double height}) {
    return PatientDashboardCard(
      key: const Key('card_medical_history'),
      imagePath: 'assets/images/medical history.jpg',
      title: 'Medical History & Trends',
      description:
          'Historical encounter timelines, vital trend tracking, and multi-modality historical comparison',
      badgeColor: const Color(0xFFF43F5E),
      height: height,
      onTap: _openMedicalHistory,
    );
  }

  // ── Card 5: Examination Records ──
  Widget _buildExaminationRecordsCard({required double height}) {
    return PatientDashboardCard(
      key: const Key('card_examination_records'),
      imagePath: 'assets/images/examination record.jpg',
      title: 'Examination Records',
      description: 'Recorded examinations with AI diagnostic findings',
      badgeColor: const Color(0xFF0D9488),
      height: height,
      onTap: _openExaminationRecords,
    );
  }
}
