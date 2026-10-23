import 'package:flutter/material.dart';

import '../../core/database/database.dart';
import '../../core/database/repositories/patient_repository.dart';
import '../../core/theme/wisteria_theme.dart';
import '../shared/wisteria_back_button.dart';
import 'widgets/patient_age_avatar.dart';

/// Dedicated Patient Information Detail Page.
///
/// Displays clinical demographics, contact details, and residential information.
/// Provides Edit Profile and Delete actions in the header with full validation,
/// database updates, and confirmation safeguards.
class PatientInformationPage extends StatefulWidget {
  final WisteriaDatabase database;
  final String patientId;

  const PatientInformationPage({
    super.key,
    required this.database,
    required this.patientId,
  });

  @override
  State<PatientInformationPage> createState() => _PatientInformationPageState();
}

class _PatientInformationPageState extends State<PatientInformationPage> {
  late final PatientRepository _patientRepository;
  Patient? _patient;
  bool _isLoading = true;
  bool _hasModified = false;

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

  Future<void> _editPatient() async {
    final patient = _patient;
    if (patient == null) return;

    final nameController = TextEditingController(text: patient.name);
    final phoneController = TextEditingController(text: patient.phoneNumber ?? '');
    final ageController = TextEditingController(
      text: patient.age != null ? patient.age.toString() : '',
    );
    final bloodGroupController = TextEditingController(text: patient.bloodGroup ?? '');
    final otherContactController = TextEditingController(text: patient.otherContact ?? '');
    final addressController = TextEditingController(text: patient.address ?? '');
    String? selectedGender = patient.gender;

    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        final dlgColors = WisteriaColors.of(context);
        return AlertDialog(
          backgroundColor: dlgColors.surfaceContainer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Edit Patient Profile',
            style: TextStyle(
              color: dlgColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
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
                    StatefulBuilder(
                      builder: (ctx, setDropState) {
                        return DropdownButtonFormField<String?>(
                          key: const Key('edit_gender_field'),
                          initialValue: selectedGender,
                          dropdownColor: dlgColors.surfaceContainer,
                          style: TextStyle(color: dlgColors.textPrimary),
                          decoration: const InputDecoration(labelText: 'Gender'),
                          items: const [
                            DropdownMenuItem(value: 'Male', child: Text('Male')),
                            DropdownMenuItem(value: 'Female', child: Text('Female')),
                            DropdownMenuItem(value: 'Other', child: Text('Other')),
                          ],
                          onChanged: (val) {
                            setDropState(() => selectedGender = val);
                          },
                        );
                      },
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
                              labelText: 'Email / Secondary Contact',
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

                try {
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
                    gender: selectedGender,
                    otherContact: otherContactController.text.trim().isEmpty
                        ? null
                        : otherContactController.text.trim(),
                    address: addressController.text.trim().isEmpty
                        ? null
                        : addressController.text.trim(),
                  );

                  if (!context.mounted) return;
                  Navigator.pop(context, true);
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update patient: $e')),
                  );
                }
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
      _hasModified = true;
      await _loadPatient();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient profile updated successfully')),
      );
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Delete Patient Record?',
            style: TextStyle(
              color: dlgColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to permanently delete the patient record for "${patient.name}"? '
            'All associated clinical records, images, and examinations will be permanently removed. This action cannot be undone.',
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

    try {
      await _patientRepository.deletePatient(patient.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Patient record for "${patient.name}" deleted successfully'),
          backgroundColor: WisteriaColors.of(context).error,
        ),
      );
      Navigator.of(context).pop('deleted');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete patient: $e')),
      );
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

    final patient = _patient!;

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
                        // Profile Header with Edit and Delete
                        _buildProfileHeader(patient, colors),

                        const SizedBox(height: 24),

                        // Demographics & Clinical Information Card
                        _buildDemographicsCard(patient, colors),

                        const SizedBox(height: 20),

                        // Contact & Residence Card
                        _buildContactCard(patient, colors),
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
            onTap: () => Navigator.of(context).pop(_hasModified ? 'updated' : null),
          ),
          const SizedBox(width: 16),
          Container(
            height: 16,
            width: 1,
            color: colors.border,
          ),
          const SizedBox(width: 16),
          Text(
            'Patient Information Details',
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

  Widget _buildProfileHeader(Patient patient, WisteriaColorPalette colors) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 2),
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 650;

          final avatarAndName = Row(
            children: [
              PatientAgeAvatar(
                age: patient.age,
                size: 60,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainer,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: colors.borderSubtle),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.tag_rounded,
                                size: 12,
                                color: colors.textMuted,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                patient.id,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  color: colors.textMuted,
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
            ],
          );

          final actionButtons = Row(
            mainAxisSize: isNarrow ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: isNarrow ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.textPrimary,
                  side: BorderSide(color: colors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _editPatient,
                icon: const Icon(Icons.edit_outlined, size: 16),
                label: const Text('Edit Profile'),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.error.withValues(alpha: 0.15),
                  foregroundColor: colors.error,
                  side: BorderSide(color: colors.error.withValues(alpha: 0.3)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _deletePatient,
                icon: const Icon(Icons.delete_outline_rounded, size: 16),
                label: const Text('Delete'),
              ),
            ],
          );

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                avatarAndName,
                const SizedBox(height: 16),
                actionButtons,
              ],
            );
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: avatarAndName),
              const SizedBox(width: 20),
              actionButtons,
            ],
          );
        },
      ),
    );
  }

  Widget _buildDemographicsCard(Patient patient, WisteriaColorPalette colors) {
    return _buildSectionContainer(
      title: 'Clinical Demographics',
      subtitle: 'Primary physiological indicators and demographic categorization',
      icon: Icons.badge_outlined,
      iconColor: const Color(0xFF0284C7),
      colors: colors,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 600;
          return Column(
            children: [
              if (isWide) ...[
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailField(
                        icon: Icons.cake_outlined,
                        label: 'Age',
                        value: patient.age != null ? '${patient.age} years' : 'Not provided',
                        colors: colors,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildDetailField(
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
                  children: [
                    Expanded(
                      child: _buildDetailField(
                        icon: Icons.people_outline_rounded,
                        label: 'Gender',
                        value: patient.gender ?? 'Not provided',
                        colors: colors,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildDetailField(
                        icon: Icons.medical_services_outlined,
                        label: 'Clinical Status',
                        value: 'Active Record',
                        colors: colors,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                _buildDetailField(
                  icon: Icons.cake_outlined,
                  label: 'Age',
                  value: patient.age != null ? '${patient.age} years' : 'Not provided',
                  colors: colors,
                ),
                const SizedBox(height: 14),
                _buildDetailField(
                  icon: Icons.bloodtype_outlined,
                  label: 'Blood Group',
                  value: patient.bloodGroup ?? 'Not provided',
                  colors: colors,
                ),
                const SizedBox(height: 14),
                _buildDetailField(
                  icon: Icons.people_outline_rounded,
                  label: 'Gender',
                  value: patient.gender ?? 'Not provided',
                  colors: colors,
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildContactCard(Patient patient, WisteriaColorPalette colors) {
    return _buildSectionContainer(
      title: 'Contact & Residential Profile',
      subtitle: 'Primary and secondary points of contact along with residence',
      icon: Icons.contacts_outlined,
      iconColor: const Color(0xFF0D9488),
      colors: colors,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 600;
          return Column(
            children: [
              if (isWide) ...[
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailField(
                        icon: Icons.phone_outlined,
                        label: 'Primary Phone',
                        value: patient.phoneNumber ?? 'Not provided',
                        colors: colors,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildDetailField(
                        icon: Icons.alternate_email_rounded,
                        label: 'Email / Secondary Contact',
                        value: patient.otherContact ?? 'Not provided',
                        colors: colors,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDetailField(
                  icon: Icons.home_outlined,
                  label: 'Residential Address',
                  value: patient.address ?? 'Not provided',
                  colors: colors,
                ),
              ] else ...[
                _buildDetailField(
                  icon: Icons.phone_outlined,
                  label: 'Primary Phone',
                  value: patient.phoneNumber ?? 'Not provided',
                  colors: colors,
                ),
                const SizedBox(height: 14),
                _buildDetailField(
                  icon: Icons.alternate_email_rounded,
                  label: 'Email / Secondary Contact',
                  value: patient.otherContact ?? 'Not provided',
                  colors: colors,
                ),
                const SizedBox(height: 14),
                _buildDetailField(
                  icon: Icons.home_outlined,
                  label: 'Residential Address',
                  value: patient.address ?? 'Not provided',
                  colors: colors,
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionContainer({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required WisteriaColorPalette colors,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isDark ? iconColor.withValues(alpha: 0.15) : iconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: iconColor.withValues(alpha: 0.25)),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildDetailField({
    required IconData icon,
    required String label,
    required String value,
    required WisteriaColorPalette colors,
  }) {
    final isProvided = value != 'Not provided' && value.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: isProvided ? colors.primary : colors.textMuted,
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
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isProvided ? FontWeight.w500 : FontWeight.w400,
                    color: isProvided
                        ? colors.textPrimary
                        : colors.textMuted.withValues(alpha: 0.7),
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
}
