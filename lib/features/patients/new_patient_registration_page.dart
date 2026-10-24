import 'package:flutter/material.dart';

import '../../core/database/database.dart';
import '../../core/database/repositories/patient_repository.dart';
import '../../core/theme/wisteria_theme.dart';
import '../shared/wisteria_back_button.dart';

/// Clean, standalone registration screen for registering new patients.
/// Features standard Wisteria teal/neutral theme styling, sharp rectangular geometry,
/// and mandatory validation for all patient fields.
class NewPatientRegistrationPage extends StatefulWidget {
  final WisteriaDatabase database;

  const NewPatientRegistrationPage({super.key, required this.database});

  @override
  State<NewPatientRegistrationPage> createState() =>
      _NewPatientRegistrationPageState();
}

class _NewPatientRegistrationPageState
    extends State<NewPatientRegistrationPage> {
  late final PatientRepository _patientRepository;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _otherContactController = TextEditingController();
  final _addressController = TextEditingController();

  final _nameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _ageFocusNode = FocusNode();
  final _bloodGroupFocusNode = FocusNode();
  final _otherContactFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();

  String? _selectedBloodGroup;
  String? _selectedGender;
  bool _isSubmitting = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  static const List<String> _genders = ['Male', 'Female', 'Other'];

  static const List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void initState() {
    super.initState();
    _patientRepository = PatientRepository(widget.database);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _bloodGroupController.dispose();
    _otherContactController.dispose();
    _addressController.dispose();

    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _ageFocusNode.dispose();
    _bloodGroupFocusNode.dispose();
    _otherContactFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  void _focusFirstInvalid() {
    if (_nameController.text.trim().isEmpty) {
      _nameFocusNode.requestFocus();
      return;
    }

    final phoneTrimmed = _phoneController.text.trim();
    final phoneRegex = RegExp(r'^\+?[0-9\s\-()]{7,15}$');
    final digitCount = RegExp(r'\d').allMatches(phoneTrimmed).length;
    if (phoneTrimmed.isEmpty ||
        !phoneRegex.hasMatch(phoneTrimmed) ||
        digitCount < 7) {
      _phoneFocusNode.requestFocus();
      return;
    }

    final ageVal = int.tryParse(_ageController.text.trim());
    if (ageVal == null || ageVal < 0 || ageVal > 150) {
      _ageFocusNode.requestFocus();
      return;
    }

    if (_selectedBloodGroup == null || _selectedBloodGroup!.isEmpty) {
      _bloodGroupFocusNode.requestFocus();
      return;
    }

    final otherTrimmed = _otherContactController.text.trim();
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    final isOtherEmail = emailRegex.hasMatch(otherTrimmed);
    final isOtherPhone =
        phoneRegex.hasMatch(otherTrimmed) &&
        RegExp(r'\d').allMatches(otherTrimmed).length >= 7;

    if (otherTrimmed.isEmpty || (!isOtherEmail && !isOtherPhone)) {
      _otherContactFocusNode.requestFocus();
      return;
    }

    if (_addressController.text.trim().isEmpty) {
      _addressFocusNode.requestFocus();
      return;
    }
  }

  Future<void> _submitForm() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });

    if (!_formKey.currentState!.validate()) {
      _focusFirstInvalid();
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final patientId = 'patient-${DateTime.now().microsecondsSinceEpoch}';

      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final age = int.parse(_ageController.text.trim());
      final bloodGroup =
          _selectedBloodGroup ?? _bloodGroupController.text.trim();
      final otherContact = _otherContactController.text.trim();
      final address = _addressController.text.trim();

      await _patientRepository.createPatient(
        id: patientId,
        name: name,
        phoneNumber: phone,
        age: age,
        bloodGroup: bloodGroup,
        gender: _selectedGender,
        otherContact: otherContact,
        address: address,
      );

      if (!mounted) return;

      final colors = WisteriaColors.of(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Patient "$name" registered successfully',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          backgroundColor: colors.primaryMuted,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
          ),
        ),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register patient: $e'),
          backgroundColor: WisteriaColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = WisteriaColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Navigation Bar ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: colors.border)),
              ),
              child: Row(
                children: [
                  WisteriaBackButton(
                    label: 'Workspace',
                    onTap: () => Navigator.of(context).pop(false),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // ── Standalone Form Content Area ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 18,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Page Header
                        Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.transparent
                                    : colors.primary.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.zero,
                                border: isDark
                                    ? null
                                    : Border.all(
                                        color: colors.primary.withValues(
                                          alpha: 0.18,
                                        ),
                                      ),
                              ),
                              child: Icon(
                                Icons.person_add_rounded,
                                color: isDark ? Colors.white : colors.primary,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'New Patient Registration',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: colors.textPrimary,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Enter patient details to add a new record',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Form Card (Sharp Geometry)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 22,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surfaceLow,
                            borderRadius: BorderRadius.zero,
                            border: Border.all(color: colors.border, width: 1),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.25 : 0.04,
                                ),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            autovalidateMode: _autovalidateMode,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Field 1: Patient Name (Mandatory)
                                _buildFieldLabel(
                                  'Patient Name',
                                  isRequired: true,
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  key: const Key('name_field'),
                                  controller: _nameController,
                                  focusNode: _nameFocusNode,
                                  style: TextStyle(color: colors.textPrimary),
                                  decoration: _buildInputDecoration(
                                    hint: '',
                                    icon: Icons.person_outline_rounded,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Patient name is required.';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 14),

                                // Row: Phone & Age (Mandatory)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildFieldLabel(
                                            'Phone Number',
                                            isRequired: true,
                                          ),
                                          const SizedBox(height: 6),
                                          TextFormField(
                                            key: const Key('phone_field'),
                                            controller: _phoneController,
                                            focusNode: _phoneFocusNode,
                                            keyboardType: TextInputType.phone,
                                            style: TextStyle(
                                              color: colors.textPrimary,
                                            ),
                                            decoration: _buildInputDecoration(
                                              hint: '',
                                              icon: Icons.phone_outlined,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty) {
                                                return 'Phone number is required.';
                                              }
                                              final trimmed = value.trim();
                                              final phoneRegex = RegExp(
                                                r'^\+?[0-9\s\-()]{7,15}$',
                                              );
                                              final digitCount = RegExp(
                                                r'\d',
                                              ).allMatches(trimmed).length;
                                              if (!phoneRegex.hasMatch(
                                                    trimmed,
                                                  ) ||
                                                  digitCount < 7 ||
                                                  digitCount > 15) {
                                                return 'Enter a valid phone number.';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildFieldLabel(
                                            'Age',
                                            isRequired: true,
                                          ),
                                          const SizedBox(height: 6),
                                          TextFormField(
                                            key: const Key('age_field'),
                                            controller: _ageController,
                                            focusNode: _ageFocusNode,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: colors.textPrimary,
                                            ),
                                            decoration: _buildInputDecoration(
                                              hint: '',
                                              icon: Icons.cake_outlined,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty) {
                                                return 'Age is required.';
                                              }
                                              final ageVal = int.tryParse(
                                                value.trim(),
                                              );
                                              if (ageVal == null ||
                                                  ageVal < 0 ||
                                                  ageVal > 150) {
                                                return 'Enter a valid age between 0 and 150.';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                // Row: Blood Group & Gender
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildFieldLabel(
                                            'Blood Group',
                                            isRequired: true,
                                          ),
                                          const SizedBox(height: 6),
                                          DropdownButtonFormField<String>(
                                            key: const Key('blood_group_field'),
                                            focusNode: _bloodGroupFocusNode,
                                            initialValue: _selectedBloodGroup,
                                            isExpanded: true,
                                            dropdownColor: colors.surfaceLow,
                                            style: TextStyle(
                                              color: colors.textPrimary,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                            ),
                                            decoration: _buildInputDecoration(
                                              hint: 'Select',
                                              icon: Icons.bloodtype_outlined,
                                            ),
                                            items: _bloodGroups
                                                .map(
                                                  (bg) => DropdownMenuItem(
                                                    value: bg,
                                                    child: Text(bg),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                _selectedBloodGroup = val;
                                                _bloodGroupController.text =
                                                    val ?? '';
                                              });
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.trim().isEmpty ||
                                                  value == 'Select') {
                                                return 'Please select a blood group.';
                                              }
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildFieldLabel('Gender'),
                                          const SizedBox(height: 6),
                                          DropdownButtonFormField<String>(
                                            key: const Key('gender_field'),
                                            initialValue: _selectedGender,
                                            isExpanded: true,
                                            dropdownColor: colors.surfaceLow,
                                            style: TextStyle(
                                              color: colors.textPrimary,
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                            ),
                                            decoration: _buildInputDecoration(
                                              hint: 'Select gender',
                                              icon: Icons.wc_rounded,
                                            ),
                                            items: _genders
                                                .map(
                                                  (g) => DropdownMenuItem(
                                                    value: g,
                                                    child: Text(g),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                _selectedGender = val;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 14),

                                // Field: Other Contact (Mandatory)
                                _buildFieldLabel(
                                  'Other Contact',
                                  isRequired: true,
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  key: const Key('other_contact_field'),
                                  controller: _otherContactController,
                                  focusNode: _otherContactFocusNode,
                                  style: TextStyle(color: colors.textPrimary),
                                  decoration: _buildInputDecoration(
                                    hint: 'Email or emergency contact',
                                    icon: Icons.alternate_email_rounded,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Other contact is required.';
                                    }
                                    final trimmed = value.trim();
                                    final emailRegex = RegExp(
                                      r'^[\w\.-]+@[\w\.-]+\.\w+$',
                                    );
                                    final phoneRegex = RegExp(
                                      r'^\+?[0-9\s\-()]{7,15}$',
                                    );
                                    final digitCount = RegExp(
                                      r'\d',
                                    ).allMatches(trimmed).length;

                                    final isEmail = emailRegex.hasMatch(
                                      trimmed,
                                    );
                                    final isPhone =
                                        phoneRegex.hasMatch(trimmed) &&
                                        digitCount >= 7;

                                    if (!isEmail && !isPhone) {
                                      return 'Enter a valid email or emergency contact.';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 14),

                                // Field: Contact Address (Mandatory)
                                _buildFieldLabel(
                                  'Contact Address',
                                  isRequired: true,
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  key: const Key('address_field'),
                                  controller: _addressController,
                                  focusNode: _addressFocusNode,
                                  maxLines: 3,
                                  style: TextStyle(color: colors.textPrimary),
                                  decoration: _buildInputDecoration(
                                    hint:
                                        'Street address, city, state, postal code',
                                    icon: Icons.location_on_outlined,
                                    alignLabelWithHint: true,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Contact address is required.';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 20),

                                // Action Buttons (Sharp Geometry)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Cancel Action
                                    OutlinedButton(
                                      onPressed: _isSubmitting
                                          ? null
                                          : () => Navigator.of(
                                              context,
                                            ).pop(false),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: colors.textSecondary,
                                        side: BorderSide(color: colors.border),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            WisteriaRadius.sm,
                                          ),
                                        ),
                                      ),
                                      child: const Text('Cancel'),
                                    ),

                                    const SizedBox(width: 14),

                                    // Primary Action: Register Patient
                                    ElevatedButton.icon(
                                      onPressed: _isSubmitting
                                          ? null
                                          : _submitForm,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colors.primaryMuted,
                                        foregroundColor: colors.textOnPrimary,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 28,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            WisteriaRadius.sm,
                                          ),
                                        ),
                                      ),
                                      icon: _isSubmitting
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.person_add_rounded,
                                              size: 18,
                                            ),
                                      label: Text(
                                        _isSubmitting
                                            ? 'Registering...'
                                            : 'Register Patient',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    final colors = WisteriaColors.of(context);
    const asteriskColor = Color(0xFFEF4444);

    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: asteriskColor,
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
    bool alignLabelWithHint = false,
  }) {
    final colors = WisteriaColors.of(context);
    const errorColor = Color(0xFFEF4444);

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: colors.textMuted, fontSize: 13),
      prefixIcon: Icon(icon, size: 18, color: colors.textMuted),
      filled: true,
      fillColor: colors.surfaceLowest,
      alignLabelWithHint: alignLabelWithHint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      errorStyle: const TextStyle(
        fontSize: 12,
        height: 1.2,
        color: errorColor,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        borderSide: const BorderSide(color: errorColor, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        borderSide: const BorderSide(color: errorColor, width: 1.5),
      ),
    );
  }
}
