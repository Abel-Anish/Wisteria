import 'package:flutter/material.dart';
import '../examinations/create_examination_page.dart';
import '../../core/database/database.dart';
import '../../core/database/repositories/patient_repository.dart';
import '../../core/theme/wisteria_theme.dart';
import '../shared/wisteria_back_button.dart';
import '../../core/database/repositories/examination_repository.dart';

import '../examinations/examination_details_page.dart';
import 'widgets/patient_age_avatar.dart';

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
  late final ExaminationRepository _examinationRepository;

  Patient? _patient;
  List<Examination> _examinations = [];

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();

    _patientRepository = PatientRepository(widget.database);
    _examinationRepository = ExaminationRepository(widget.database);

    _loadPatient();
    _loadExaminations();
  }

  Future<void> _loadPatient() async {
    final patient = await _patientRepository.getPatientById(widget.patientId);

    if (!mounted) return;

    setState(() {
      _patient = patient;
      _isLoading = false;
    });
  }

  Future<void> _loadExaminations() async {
    final examinations = await _examinationRepository.getExaminationsForPatient(
      widget.patientId,
    );

    if (!mounted) return;

    setState(() {
      _examinations = examinations;
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

  Future<void> _editPatient() async {
    final patient = _patient;
    if (patient == null) return;

    final nameController = TextEditingController(text: patient.name);
    final phoneController = TextEditingController(
      text: patient.phoneNumber ?? '',
    );
    final ageController = TextEditingController(
      text: patient.age?.toString() ?? '',
    );
    final bloodGroupController = TextEditingController(
      text: patient.bloodGroup ?? '',
    );
    final otherContactController = TextEditingController(
      text: patient.otherContact ?? '',
    );
    final addressController = TextEditingController(
      text: patient.address ?? '',
    );

    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        final dlgColors = WisteriaColors.of(context);
        return AlertDialog(
          backgroundColor: dlgColors.surfaceContainer,
          title: Text(
            'Edit Patient Record',
            style: TextStyle(
              color: dlgColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SizedBox(
            width: 520,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      style: TextStyle(color: dlgColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'Full Name *'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: ageController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: dlgColors.textPrimary),
                            decoration: const InputDecoration(labelText: 'Age'),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextFormField(
                            controller: bloodGroupController,
                            style: TextStyle(color: dlgColors.textPrimary),
                            decoration: const InputDecoration(
                              labelText: 'Blood Group',
                              hintText: 'e.g. O+, A-',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: phoneController,
                            style: TextStyle(color: dlgColors.textPrimary),
                            decoration: const InputDecoration(
                              labelText: 'Primary Phone',
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextFormField(
                            controller: otherContactController,
                            style: TextStyle(color: dlgColors.textPrimary),
                            decoration: const InputDecoration(
                              labelText: 'Secondary Contact',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: addressController,
                      maxLines: 3,
                      style: TextStyle(color: dlgColors.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'Residential Address',
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: dlgColors.primary,
                foregroundColor: dlgColors.textOnPrimary,
              ),
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                await _patientRepository.updatePatient(
                  id: patient.id,
                  name: nameController.text.trim(),
                  phoneNumber: phoneController.text.trim().isEmpty
                      ? null
                      : phoneController.text.trim(),
                  age: int.tryParse(ageController.text.trim()),
                  bloodGroup: bloodGroupController.text.trim().isEmpty
                      ? null
                      : bloodGroupController.text.trim(),
                  otherContact: otherContactController.text.trim().isEmpty
                      ? null
                      : otherContactController.text.trim(),
                  address: addressController.text.trim().isEmpty
                      ? null
                      : addressController.text.trim(),
                );

                if (!context.mounted) return;
                Navigator.pop(context, true);
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    phoneController.dispose();
    ageController.dispose();
    bloodGroupController.dispose();
    otherContactController.dispose();
    addressController.dispose();

    if (result == true) {
      await _loadPatient();
    }
  }

  Future<void> _deletePatient() async {
    final patient = _patient;
    if (patient == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final dlgColors = WisteriaColors.of(context);
        return AlertDialog(
          backgroundColor: dlgColors.surfaceContainer,
          title: Text(
            'Delete Patient Record?',
            style: TextStyle(
              color: dlgColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to permanently delete the patient record for "${patient.name}"? '
            'All associated clinical data will be removed. This action cannot be undone.',
            style: TextStyle(color: dlgColors.textSecondary, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: dlgColors.error,
                foregroundColor: dlgColors.textOnPrimary,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete Permanently'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await _patientRepository.deletePatient(patient.id);
    if (!mounted) return;
    Navigator.pop(context, true);
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

    if (_patient == null) {
      return Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    WisteriaBackButton(
                      label: 'Patients',
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
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

    final patient = _patient!;

    return Scaffold(
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
                    constraints: const BoxConstraints(maxWidth: 1280),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Compact Patient Identity Header (Full Width)
                        _buildCompactPatientHeader(patient, colors),

                        const SizedBox(height: 20),

                        // 2. Patient Information & New Examination (Side by Side)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 860;

                            if (isWide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: _buildBiodataCard(patient, colors),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    flex: 6,
                                    child: _buildNewExaminationCard(
                                      patient,
                                      colors,
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildBiodataCard(patient, colors),
                                const SizedBox(height: 16),
                                _buildNewExaminationCard(patient, colors),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // 3. Patient Analytics & Medical History (Side by Side Pair)
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 860;

                            if (isWide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _buildAnalyticsCard(colors),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: _buildMedicalHistoryCard(colors),
                                  ),
                                ],
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildAnalyticsCard(colors),
                                const SizedBox(height: 14),
                                _buildMedicalHistoryCard(colors),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        // 4. Examinations Records (Full Width Bottom)
                        _buildExaminationsSection(patient, colors),
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
            label: 'Patients Directory',
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

  // ── 1. Compact Full-Width Patient Identity Header ──

  Widget _buildCompactPatientHeader(
    Patient patient,
    WisteriaColorPalette colors,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            offset: const Offset(0, 1),
            color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.03),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Age-appropriate Avatar
          PatientAgeAvatar(
            age: patient.age,
            size: 44,
            customAccent: colors.primary,
          ),

          const SizedBox(width: 16),

          // Name and ID badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  patient.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 5),

                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    // Monospace Patient ID badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2.5,
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
                            Icons.fingerprint_rounded,
                            size: 12,
                            color: colors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            patient.id,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: colors.textSecondary,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Completed Examinations Count Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            size: 12,
                            color: colors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_examinations.length} Exam${_examinations.length == 1 ? '' : 's'}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: colors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Actions aligned to the right
          _ClinicalActionButton(
            icon: Icons.edit_outlined,
            label: 'Edit Patient',
            tooltip: 'Update patient information',
            onTap: _editPatient,
            color: colors.primary,
          ),
          const SizedBox(width: 10),
          _ClinicalActionButton(
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            tooltip: 'Remove patient record',
            onTap: _deletePatient,
            color: colors.error,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  // ── 2. Left Card: Patient Information (No Horizontal Dividers) ──

  Widget _buildBiodataCard(Patient patient, WisteriaColorPalette colors) {
    return _buildSectionCard(
      title: 'Patient Information',
      subtitle: 'Clinical demographic profile & contact details',
      icon: Icons.person_outline_rounded,
      colors: colors,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isTwoCol = constraints.maxWidth >= 360;

          if (isTwoCol) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildInfoGridItem(
                        icon: Icons.cake_outlined,
                        label: 'Age',
                        value: patient.age != null
                            ? '${patient.age} years'
                            : 'Not provided',
                        colors: colors,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoGridItem(
                        icon: Icons.bloodtype_outlined,
                        label: 'Blood Group',
                        value: patient.bloodGroup ?? 'Not provided',
                        colors: colors,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildInfoGridItem(
                        icon: Icons.phone_outlined,
                        label: 'Primary Phone',
                        value: patient.phoneNumber ?? 'Not provided',
                        colors: colors,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoGridItem(
                        icon: Icons.alternate_email_rounded,
                        label: 'Secondary Contact',
                        value: patient.otherContact ?? 'Not provided',
                        colors: colors,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoGridItem(
                  icon: Icons.location_on_outlined,
                  label: 'Residential Address',
                  value: patient.address ?? 'Not provided',
                  colors: colors,
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoGridItem(
                icon: Icons.cake_outlined,
                label: 'Age',
                value: patient.age != null
                    ? '${patient.age} years'
                    : 'Not provided',
                colors: colors,
              ),
              const SizedBox(height: 12),
              _buildInfoGridItem(
                icon: Icons.bloodtype_outlined,
                label: 'Blood Group',
                value: patient.bloodGroup ?? 'Not provided',
                colors: colors,
              ),
              const SizedBox(height: 12),
              _buildInfoGridItem(
                icon: Icons.phone_outlined,
                label: 'Primary Phone',
                value: patient.phoneNumber ?? 'Not provided',
                colors: colors,
              ),
              const SizedBox(height: 12),
              _buildInfoGridItem(
                icon: Icons.alternate_email_rounded,
                label: 'Secondary Contact',
                value: patient.otherContact ?? 'Not provided',
                colors: colors,
              ),
              const SizedBox(height: 12),
              _buildInfoGridItem(
                icon: Icons.location_on_outlined,
                label: 'Residential Address',
                value: patient.address ?? 'Not provided',
                colors: colors,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoGridItem({
    required IconData icon,
    required String label,
    required String value,
    required WisteriaColorPalette colors,
  }) {
    final isProvided = value != 'Not provided' && value.trim().isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isProvided
                ? colors.primary.withValues(alpha: 0.10)
                : colors.surfaceContainer,
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            border: Border.all(
              color: isProvided
                  ? colors.primary.withValues(alpha: 0.20)
                  : colors.borderSubtle,
            ),
          ),
          child: Icon(
            icon,
            size: 15,
            color: isProvided ? colors.primary : colors.textMuted,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: colors.textMuted,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isProvided ? FontWeight.w500 : FontWeight.w400,
                  color: isProvided
                      ? colors.textPrimary
                      : colors.textMuted.withValues(alpha: 0.6),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── 2. Right Card: Prominent New Examination Card ──

  Widget _buildNewExaminationCard(
    Patient patient,
    WisteriaColorPalette colors,
  ) {
    return _ProminentNewExamCard(
      onTap: () async {
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
          await _loadExaminations();
        }
      },
    );
  }

  // ── 3. Left Card: Patient Analytics Card ──

  Widget _buildAnalyticsCard(WisteriaColorPalette colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.info.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(WisteriaRadius.sm),
              border: Border.all(
                color: colors.info.withValues(alpha: 0.18),
              ),
            ),
            child: Icon(
              Icons.analytics_outlined,
              size: 18,
              color: colors.info,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Patient Analytics',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildComingSoonBadge(colors),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'Longitudinal statistical summaries, automated diagnostic trends, and AI risk stratification across patient visits.',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 3. Right Card: Medical History & Trends Card ──

  Widget _buildMedicalHistoryCard(WisteriaColorPalette colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.tertiary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(WisteriaRadius.sm),
              border: Border.all(
                color: colors.tertiary.withValues(alpha: 0.18),
              ),
            ),
            child: Icon(
              Icons.timeline_rounded,
              size: 18,
              color: colors.tertiary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Medical History & Trends',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildComingSoonBadge(colors),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'Historical encounter timelines, vital trend tracking, and multi-modality historical comparison charts.',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonBadge(WisteriaColorPalette colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule_rounded,
            size: 10,
            color: colors.warning.withValues(alpha: 0.85),
          ),
          const SizedBox(width: 4),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colors.textMuted,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ── 4. Examinations Records Section (Full Width Bottom) ──

  Widget _buildExaminationsSection(
    Patient patient,
    WisteriaColorPalette colors,
  ) {
    return _buildSectionCard(
      title: 'Examinations Records',
      subtitle:
          '${_examinations.length} recorded examination${_examinations.length == 1 ? '' : 's'} with AI diagnostic findings',
      icon: Icons.medical_information_outlined,
      colors: colors,
      headerTrailing: _examinations.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                '${_examinations.length} Completed',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                ),
              ),
            )
          : null,
      child: _examinations.isEmpty
          ? _buildEmptyExaminationsState(patient, colors)
          : Column(
              children: _examinations.map(
                (examination) => _buildExaminationCard(examination, colors),
              ).toList(),
            ),
    );
  }

  Widget _buildEmptyExaminationsState(
    Patient patient,
    WisteriaColorPalette colors,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            ),
            child: Icon(
              Icons.folder_open_outlined,
              size: 20,
              color: colors.primary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No Examinations Recorded',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Text(
              'No clinical diagnostic runs or AI evaluations have been created for ${patient.name} yet.',
              style: TextStyle(
                fontSize: 12,
                color: colors.textMuted,
                height: 1.35,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExaminationCard(
    Examination examination,
    WisteriaColorPalette colors,
  ) {
    final isMri = examination.examinationType.toUpperCase().contains('MRI') ||
        examination.examinationType.toUpperCase().contains('BRAIN');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _InteractiveExaminationTile(
        examination: examination,
        formattedDate: _formatDateTime(examination.examinationDate),
        isMri: isMri,
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExaminationDetailsPage(
                database: widget.database,
                examinationId: examination.id,
              ),
            ),
          );

          if (mounted) {
            await _loadExaminations();
          }
        },
      ),
    );
  }

  // ── Generic Section Card Wrapper ──

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required WisteriaColorPalette colors,
    required Widget child,
    Widget? headerTrailing,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  icon,
                  size: 17,
                  color: colors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              ?headerTrailing,
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

// ── Interactive Examination Tile Component ──

class _InteractiveExaminationTile extends StatefulWidget {
  final Examination examination;
  final String formattedDate;
  final bool isMri;
  final VoidCallback onTap;

  const _InteractiveExaminationTile({
    required this.examination,
    required this.formattedDate,
    required this.isMri,
    required this.onTap,
  });

  @override
  State<_InteractiveExaminationTile> createState() =>
      _InteractiveExaminationTileState();
}

class _InteractiveExaminationTileState
    extends State<_InteractiveExaminationTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: _isHovered
                ? (isDark ? colors.surfaceContainer : colors.surface)
                : colors.surfaceContainer,
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            border: Border.all(
              color: _isHovered
                  ? colors.primary.withValues(alpha: 0.6)
                  : colors.borderSubtle,
              width: 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      color: colors.primary.withValues(
                        alpha: isDark ? 0.12 : 0.06,
                      ),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.isMri
                      ? const Color(0xFF8E24AA).withValues(alpha: 0.10)
                      : colors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
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
                  color: widget.isMri ? const Color(0xFF8E24AA) : colors.primary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.examination.examinationType,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 12,
                          color: colors.textMuted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status Pill
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Text(
                  widget.examination.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                    letterSpacing: 0.4,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Forward Arrow
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: _isHovered ? colors.primary : colors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Prominent New Examination Card Component ──

class _ProminentNewExamCard extends StatefulWidget {
  final VoidCallback onTap;

  const _ProminentNewExamCard({required this.onTap});

  @override
  State<_ProminentNewExamCard> createState() => _ProminentNewExamCardState();
}

class _ProminentNewExamCardState extends State<_ProminentNewExamCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? (_isHovered ? const Color(0xFF1E2833) : const Color(0xFF16212B))
                : (_isHovered ? const Color(0xFFEAF5F7) : const Color(0xFFF1F8F9)),
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
            border: Border.all(
              color: _isHovered
                  ? colors.primary.withValues(alpha: 0.75)
                  : colors.primary.withValues(alpha: 0.35),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: _isHovered ? 16 : 6,
                offset: const Offset(0, 3),
                color: colors.primary.withValues(
                  alpha: isDark ? (_isHovered ? 0.22 : 0.12) : (_isHovered ? 0.14 : 0.06),
                ),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(
                        alpha: _isHovered ? 0.22 : 0.14,
                      ),
                      borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Icon(
                      Icons.add_circle_outline_rounded,
                      size: 24,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'New Examination',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primary.withValues(alpha: 0.15),
                                borderRadius:
                                    BorderRadius.circular(WisteriaRadius.sm),
                              ),
                              child: Text(
                                'PRIMARY',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: colors.primary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'AI-assisted clinical evaluation & reporting',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                'Launch an examination workflow with automated local ONNX neural network inference for chest radiography or brain MRI imaging.',
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textSecondary,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // Direct Action Button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.textOnPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    ),
                  ),
                  onPressed: widget.onTap,
                  icon: const Icon(Icons.play_arrow_rounded, size: 19),
                  label: const Text(
                    'Begin Examination',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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
}

// ── Clinical Action Button in Top Bar ──

class _ClinicalActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback onTap;
  final Color color;
  final bool isDestructive;

  const _ClinicalActionButton({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.onTap,
    required this.color,
    this.isDestructive = false,
  });

  @override
  State<_ClinicalActionButton> createState() => _ClinicalActionButtonState();
}

class _ClinicalActionButtonState extends State<_ClinicalActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _isHovered
                  ? widget.color.withValues(alpha: 0.12)
                  : colors.surfaceContainer,
              borderRadius: BorderRadius.circular(WisteriaRadius.sm),
              border: Border.all(
                color: _isHovered
                    ? widget.color.withValues(alpha: 0.4)
                    : colors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 15,
                  color: _isHovered ? widget.color : colors.textSecondary,
                ),
                const SizedBox(width: 7),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _isHovered ? widget.color : colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
