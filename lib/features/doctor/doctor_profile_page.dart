import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../../core/database/database.dart';
import '../../core/database/repositories/doctor_repository.dart';
import '../../core/storage/doctor_document_storage.dart';
import '../../core/theme/wisteria_theme.dart';
import '../shared/wisteria_back_button.dart';
import 'doctor_document_viewer_page.dart';

class DoctorProfilePage extends StatefulWidget {
  final WisteriaDatabase database;

  const DoctorProfilePage({super.key, required this.database});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  late final DoctorRepository _doctorRepository;
  late final DoctorDocumentStorage _documentStorage;

  final _formKey = GlobalKey<FormState>();

  final _doctorNameController = TextEditingController();
  final _specializationController = TextEditingController();
  final _clinicNameController = TextEditingController();
  final _clinicAddressController = TextEditingController();
  final _clinicPhoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _signatureController = TextEditingController();

  String? _documentPath;
  String? _documentFileName;

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isEditing = false;
  bool _isPickingDocument = false;

  @override
  void initState() {
    super.initState();
    _doctorRepository = DoctorRepository(widget.database);
    _documentStorage = DoctorDocumentStorage();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _doctorRepository.getProfile();

    if (!mounted) return;

    if (profile != null) {
      _doctorNameController.text = profile.doctorName;
      _specializationController.text = profile.specialization ?? '';
      _clinicNameController.text = profile.clinicName ?? '';
      _clinicAddressController.text = profile.clinicAddress ?? '';
      _clinicPhoneController.text = profile.clinicPhoneNumber ?? '';
      _emailController.text = profile.email ?? '';
      _signatureController.text = profile.signature ?? '';
      _documentPath = profile.documentPath;
      _documentFileName = profile.documentFileName;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _doctorRepository.saveProfile(
        id: 'local-doctor',
        doctorName: _doctorNameController.text.trim(),
        specialization: _optionalValue(_specializationController),
        clinicName: _optionalValue(_clinicNameController),
        clinicAddress: _optionalValue(_clinicAddressController),
        clinicPhoneNumber: _optionalValue(_clinicPhoneController),
        email: _optionalValue(_emailController),
        signature: _optionalValue(_signatureController),
        documentPath: _documentPath,
        documentFileName: _documentFileName,
      );

      if (!mounted) return;

      setState(() {
        _isEditing = false;
        _isSaving = false;
      });

      final colors = WisteriaColors.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Doctor profile saved successfully'),
          backgroundColor: colors.primaryMuted,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save doctor profile: $e'),
          backgroundColor: WisteriaColors.error,
        ),
      );
    }
  }

  Future<void> _pickDoctorDocument() async {
    setState(() {
      _isPickingDocument = true;
    });

    try {
      final selectedFile = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (selectedFile == null || selectedFile.path == null) {
        return;
      }

      final savedPath = await _documentStorage.saveDocument(selectedFile.path!);

      if (!mounted) return;

      setState(() {
        _documentPath = savedPath;
        _documentFileName = selectedFile.name;
      });

      await _saveDocumentPathToProfile(savedPath, selectedFile.name);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add document: $e'),
          backgroundColor: WisteriaColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingDocument = false;
        });
      }
    }
  }

  Future<void> _saveDocumentPathToProfile(String path, String name) async {
    try {
      await _doctorRepository.saveProfile(
        id: 'local-doctor',
        doctorName: _doctorNameController.text.trim().isNotEmpty
            ? _doctorNameController.text.trim()
            : 'Doctor',
        specialization: _optionalValue(_specializationController),
        clinicName: _optionalValue(_clinicNameController),
        clinicAddress: _optionalValue(_clinicAddressController),
        clinicPhoneNumber: _optionalValue(_clinicPhoneController),
        email: _optionalValue(_emailController),
        signature: _optionalValue(_signatureController),
        documentPath: path,
        documentFileName: name,
      );
    } catch (_) {}
  }

  Future<void> _openDocument() async {
    if (_documentPath == null || _documentPath!.isEmpty) return;

    final file = File(_documentPath!);
    if (!await file.exists()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document file not found on disk.')),
      );
      return;
    }

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DoctorDocumentViewerPage(
          documentPath: _documentPath!,
          documentName: _documentFileName ?? 'Doctor Document',
        ),
      ),
    );
  }

  String? _optionalValue(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  void _cancelEditing() {
    _loadProfile();
    setState(() {
      _isEditing = false;
    });
  }

  @override
  void dispose() {
    _doctorNameController.dispose();
    _specializationController.dispose();
    _clinicNameController.dispose();
    _clinicAddressController.dispose();
    _clinicPhoneController.dispose();
    _emailController.dispose();
    _signatureController.dispose();
    super.dispose();
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

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: colors.border)),
              ),
              child: Row(
                children: [
                  WisteriaBackButton(
                    label: 'Dashboard',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.textMuted,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: _isEditing
                        ? _buildEditProfile()
                        : _buildProfileView(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),

        const SizedBox(height: 28),

        // Responsive Two-Column Layout for Desktop
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 640;
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildDoctorInfoCard()),
                  const SizedBox(width: 20),
                  Expanded(child: _buildClinicInfoCard()),
                ],
              );
            } else {
              return Column(
                children: [
                  _buildDoctorInfoCard(),
                  const SizedBox(height: 20),
                  _buildClinicInfoCard(),
                ],
              );
            }
          },
        ),

        const SizedBox(height: 20),

        // Compact PDF Document Panel
        _buildDocumentCard(),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildHeader() {
    final colors = WisteriaColors.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Doctor Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage your professional information, clinic details, and credentials.',
                style: TextStyle(fontSize: 14, color: colors.textSecondary),
              ),
            ],
          ),
        ),

        if (!_isEditing)
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primaryMuted,
              foregroundColor: colors.textOnPrimary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
              ),
            ),
            icon: const Icon(Icons.edit_outlined, size: 16),
            label: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }

  Widget _buildDoctorInfoCard() {
    final colors = WisteriaColors.of(context);
    final name = _doctorNameController.text.trim();
    final spec = _specializationController.text.trim();
    final email = _emailController.text.trim();
    final hasName = name.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Doctor Information', Icons.badge_outlined),
          const SizedBox(height: 20),

          Text(
            'Doctor Name',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hasName ? 'Dr. $name' : 'Not configured',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: hasName ? colors.textPrimary : colors.textMuted,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 18),
          Divider(color: colors.borderSubtle, height: 1),
          const SizedBox(height: 18),

          _buildProfileFieldRow(
            'Specialization',
            spec.isNotEmpty ? spec : 'Not provided',
            Icons.workspace_premium_outlined,
          ),
          const SizedBox(height: 16),

          _buildProfileFieldRow(
            'Email Address',
            email.isNotEmpty ? email : 'Not provided',
            Icons.email_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildClinicInfoCard() {
    final colors = WisteriaColors.of(context);
    final clinicName = _clinicNameController.text.trim();
    final clinicAddr = _clinicAddressController.text.trim();
    final clinicPhone = _clinicPhoneController.text.trim();
    final signature = _signatureController.text.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Clinic & Professional Details',
            Icons.local_hospital_outlined,
          ),
          const SizedBox(height: 20),

          _buildProfileFieldRow(
            'Clinic Name',
            clinicName.isNotEmpty ? clinicName : 'Not provided',
            Icons.business_outlined,
          ),
          const SizedBox(height: 14),

          _buildProfileFieldRow(
            'Clinic Address',
            clinicAddr.isNotEmpty ? clinicAddr : 'Not provided',
            Icons.location_on_outlined,
          ),
          const SizedBox(height: 14),

          _buildProfileFieldRow(
            'Clinic Phone Number',
            clinicPhone.isNotEmpty ? clinicPhone : 'Not provided',
            Icons.phone_outlined,
          ),
          const SizedBox(height: 14),

          _buildProfileFieldRow(
            'Doctor Signature',
            signature.isNotEmpty ? signature : 'Not provided',
            Icons.draw_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileFieldRow(String label, String value, IconData icon) {
    final colors = WisteriaColors.of(context);
    final isNotProvided = value == 'Not provided';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isNotProvided ? colors.textMuted : colors.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isNotProvided ? FontWeight.w400 : FontWeight.w500,
                  color: isNotProvided ? colors.textMuted : colors.textPrimary,
                  fontStyle: isNotProvided
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDocumentCard() {
    final colors = WisteriaColors.of(context);
    final hasDocument = _documentPath != null && _documentPath!.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
              _buildSectionHeader(
                'Doctor Document',
                Icons.picture_as_pdf_outlined,
              ),
              if (hasDocument)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.zero,
                    border: Border.all(
                      color: colors.success.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 13,
                        color: colors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Uploaded',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.success,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          if (hasDocument) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surfaceLowest,
                borderRadius: BorderRadius.zero,
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Row(
                children: [
                  // Compact PDF Thumbnail Box
                  Container(
                    width: 56,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.zero,
                      border: Border.all(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.picture_as_pdf_rounded,
                          color: Color(0xFFEF4444),
                          size: 24,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'PDF',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // File metadata
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _documentFileName ??
                              (_documentPath != null
                                  ? path.basename(_documentPath!)
                                  : 'doctor_document.pdf'),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Medical License / Credentials • PDF Document',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Action Buttons
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _openDocument,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.primary,
                          side: BorderSide(
                            color: colors.primary.withValues(alpha: 0.4),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              WisteriaRadius.sm,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.open_in_new_rounded, size: 15),
                        label: const Text(
                          'View PDF',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _isPickingDocument
                            ? null
                            : _pickDoctorDocument,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.textSecondary,
                          side: BorderSide(color: colors.border),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              WisteriaRadius.sm,
                            ),
                          ),
                        ),
                        icon: _isPickingDocument
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.upload_file_rounded, size: 15),
                        label: Text(
                          _isPickingDocument ? 'Uploading...' : 'Replace',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            // Empty State
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: colors.surfaceLowest,
                borderRadius: BorderRadius.zero,
                border: Border.all(color: colors.borderSubtle),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Icon(
                      Icons.upload_file_outlined,
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
                          'No Doctor Document Uploaded',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Upload a PDF copy of your medical license, certification, or clinic credentials.',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _isPickingDocument ? null : _pickDoctorDocument,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primaryMuted,
                      foregroundColor: colors.textOnPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                      ),
                    ),
                    icon: _isPickingDocument
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.upload_file_rounded, size: 16),
                    label: Text(
                      _isPickingDocument ? 'Uploading...' : 'Upload Document',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEditProfile() {
    final colors = WisteriaColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),

        const SizedBox(height: 28),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: colors.surfaceLow,
            borderRadius: BorderRadius.zero,
            border: Border.all(color: colors.border),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Doctor Information', Icons.badge_outlined),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _doctorNameController,
                  style: TextStyle(color: colors.textPrimary),
                  decoration: const InputDecoration(labelText: 'Doctor Name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Doctor name is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _specializationController,
                  style: TextStyle(color: colors.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Specialization',
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: colors.textPrimary),
                  decoration: const InputDecoration(labelText: 'Email Address'),
                ),

                const SizedBox(height: 32),

                _buildSectionHeader(
                  'Clinic & Professional Details',
                  Icons.local_hospital_outlined,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _clinicNameController,
                  style: TextStyle(color: colors.textPrimary),
                  decoration: const InputDecoration(labelText: 'Clinic Name'),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _clinicAddressController,
                  maxLines: 3,
                  style: TextStyle(color: colors.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Clinic Address',
                    alignLabelWithHint: true,
                  ),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _clinicPhoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: colors.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Clinic Phone Number',
                  ),
                ),

                const SizedBox(height: 32),

                _buildSectionHeader('Doctor Signature', Icons.draw_outlined),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _signatureController,
                  maxLines: 2,
                  style: TextStyle(color: colors.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Signature Information / Details',
                    alignLabelWithHint: true,
                  ),
                ),

                const SizedBox(height: 32),

                _buildSectionHeader(
                  'Doctor Document',
                  Icons.picture_as_pdf_outlined,
                ),

                const SizedBox(height: 16),

                if (_documentFileName != null || _documentPath != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.surfaceLowest,
                      borderRadius: BorderRadius.zero,
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.picture_as_pdf_outlined,
                          color: Color(0xFFEF4444),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            _documentFileName ??
                                (_documentPath != null
                                    ? path.basename(_documentPath!)
                                    : 'Selected Document'),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    'No PDF selected.',
                    style: TextStyle(fontSize: 13, color: colors.textMuted),
                  ),

                const SizedBox(height: 14),

                OutlinedButton.icon(
                  onPressed: _isPickingDocument ? null : _pickDoctorDocument,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.primary,
                    side: BorderSide(color: colors.border),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                    ),
                  ),
                  icon: _isPickingDocument
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.upload_file_outlined),
                  label: Text(
                    _isPickingDocument
                        ? 'Selecting...'
                        : _documentFileName == null && _documentPath == null
                        ? 'Add PDF Document'
                        : 'Replace PDF Document',
                  ),
                ),

                const SizedBox(height: 36),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: _isSaving ? null : _cancelEditing,
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

                    ElevatedButton.icon(
                      onPressed: _isSaving ? null : _saveProfile,
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
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_rounded, size: 18),
                      label: Text(
                        _isSaving ? 'Saving...' : 'Save Changes',
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

        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final colors = WisteriaColors.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: colors.primary),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: colors.primary,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
