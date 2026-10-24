import 'package:flutter/material.dart';

import '../../core/database/database.dart';
import '../../core/database/repositories/patient_repository.dart';
import '../../core/theme/wisteria_theme.dart';
import '../shared/wisteria_back_button.dart';
import '../shared/wisteria_page_route.dart';
import 'patient_details_page.dart';
import 'widgets/patient_age_avatar.dart';

/// Registered Patients Directory Page.
/// Displays patient directory with search, blood group filter, count, and patient cards grid.
/// Patient registration is initiated exclusively through the New Patient card on the landing page.
class PatientPage extends StatefulWidget {
  final WisteriaDatabase database;
  final bool initialShowRegistry;
  final bool autoOpenAddPatient;

  const PatientPage({
    super.key,
    required this.database,
    this.initialShowRegistry = true,
    this.autoOpenAddPatient = false,
  });

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  late final PatientRepository _patientRepository;

  List<Patient> _patients = [];
  bool _isLoading = true;
  String? _error;

  final TextEditingController _searchController = TextEditingController();
  String? _bloodGroupFilter;

  @override
  void initState() {
    super.initState();
    _patientRepository = PatientRepository(widget.database);
    _searchController.addListener(_onSearchChanged);
    _loadPatients();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      _loadPatients();
    } else {
      _searchPatients(query);
    }
  }

  Future<void> _searchPatients(String query) async {
    try {
      final patients = await _patientRepository.searchPatients(query);
      if (!mounted) return;
      setState(() {
        _patients = _applyFilter(patients);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Search failed: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPatients() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final patients = await _patientRepository.getAllPatients();
      if (!mounted) return;
      setState(() {
        _patients = _applyFilter(patients);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load patients: $e';
        _isLoading = false;
      });
    }
  }

  List<Patient> _applyFilter(List<Patient> patients) {
    if (_bloodGroupFilter == null || _bloodGroupFilter!.isEmpty) {
      return patients;
    }
    return patients
        .where(
          (p) =>
              p.bloodGroup != null &&
              p.bloodGroup!.toLowerCase() == _bloodGroupFilter!.toLowerCase(),
        )
        .toList();
  }

  void _setBloodGroupFilter(String? filter) {
    setState(() {
      _bloodGroupFilter = filter;
    });
    if (_searchController.text.trim().isEmpty) {
      _loadPatients();
    } else {
      _searchPatients(_searchController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  WisteriaBackButton(
                    label: 'Workspace',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // ── Main Content ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // ── Header + Search & Blood Group Filter ──
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Registered Patients',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Search and browse clinical patient directory',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Search bar and blood group dropdown
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  style: TextStyle(
                                    color: colors.textPrimary,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    hintText:
                                        'Search by name, ID, or phone number...',
                                    prefixIcon: Icon(
                                      Icons.search_rounded,
                                      color: colors.textMuted,
                                      size: 20,
                                    ),
                                    suffixIcon:
                                        _searchController.text.isNotEmpty
                                        ? IconButton(
                                            onPressed: () =>
                                                _searchController.clear(),
                                            icon: Icon(
                                              Icons.clear_rounded,
                                              size: 18,
                                              color: colors.textMuted,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Blood group filter (theme aware & sharp corners)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                height: 48,
                                decoration: BoxDecoration(
                                  color: colors.surfaceLowest,
                                  borderRadius: BorderRadius.zero,
                                  border: Border.all(color: colors.border),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _bloodGroupFilter,
                                    hint: Text(
                                      'Blood Group',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: colors.textMuted,
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: colors.textSecondary,
                                    ),
                                    dropdownColor: colors.surfaceContainer,
                                    style: TextStyle(
                                      color: colors.textPrimary,
                                      fontSize: 13,
                                      fontFamily: 'Inter',
                                    ),
                                    items: [
                                      DropdownMenuItem(
                                        value: '',
                                        child: Text(
                                          'All Blood Groups',
                                          style: TextStyle(
                                            color: colors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      ...[
                                        'A+',
                                        'A-',
                                        'B+',
                                        'B-',
                                        'AB+',
                                        'AB-',
                                        'O+',
                                        'O-',
                                      ].map(
                                        (bg) => DropdownMenuItem(
                                          value: bg,
                                          child: Text(
                                            bg,
                                            style: TextStyle(
                                              color: colors.textPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      _setBloodGroupFilter(
                                        value == '' ? null : value,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Patient Grid / States ──
                    Expanded(
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: colors.primary,
                              ),
                            )
                          : _error != null
                          ? _buildErrorState(colors)
                          : _patients.isEmpty
                          ? _buildEmptyState(
                              colors,
                              message: _searchController.text.isEmpty
                                  ? 'No registered patients found'
                                  : 'No patients match your search',
                            )
                          : _buildPatientGrid(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(WisteriaColorPalette colors) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: colors.error),
          const SizedBox(height: 16),
          Text(
            _error ?? 'An error occurred',
            style: TextStyle(fontSize: 14, color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _loadPatients,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    WisteriaColorPalette colors, {
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.zero,
              border: Border.all(color: colors.primary.withValues(alpha: 0.15)),
            ),
            child: Icon(
              Icons.people_outline_rounded,
              size: 30,
              color: colors.primary.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Register a new patient using the New Patient card on the workspace landing page.',
            style: TextStyle(fontSize: 13, color: colors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPatientGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        if (constraints.maxWidth >= 1100) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth >= 800) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth >= 500) {
          crossAxisCount = 2;
        } else {
          crossAxisCount = 1;
        }

        return GridView.builder(
          padding: const EdgeInsets.only(bottom: 32),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.25,
          ),
          itemCount: _patients.length,
          itemBuilder: (context, index) {
            final patient = _patients[index];
            return _PatientCard(
              patient: patient,
              onTap: () async {
                final deleted = await Navigator.push<bool>(
                  context,
                  WisteriaPageRoute(
                    page: PatientDetailsPage(
                      database: widget.database,
                      patientId: patient.id,
                    ),
                  ),
                );

                if (deleted == true) {
                  await _loadPatients();
                }
              },
            );
          },
        );
      },
    );
  }
}

/// Redesigned Sharp Patient Card with Theme Awareness & Age-Appropriate Offline Avatar.
class _PatientCard extends StatefulWidget {
  final Patient patient;
  final VoidCallback onTap;

  const _PatientCard({required this.patient, required this.onTap});

  @override
  State<_PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<_PatientCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final patient = widget.patient;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: isDark
                ? (_isHovered ? const Color(0xFF4D4D4D) : colors.surface)
                : (_isHovered ? colors.surfaceLow : colors.surface),
            borderRadius: BorderRadius.zero,
            border: Border.all(
              color: isDark
                  ? (_isHovered ? const Color(0xFF666666) : colors.border)
                  : (_isHovered
                        ? colors.primary.withValues(alpha: 0.5)
                        : colors.border),
              width: 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.25 : 0.12,
                      ),
                    ),
                  ]
                : [],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              PatientProfileBackground(
                age: patient.age,
                dateOfBirth: patient.dateOfBirth,
                gender: patient.gender,
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: isDark ? 0.58 : 0.64),
                    ],
                    stops: const [0.42, 1.0],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Preserve the card's navigation affordance without a profile icon.
                    Align(
                      alignment: Alignment.topRight,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isDark
                              ? (_isHovered
                                    ? const Color(0xFF3D3D3D)
                                    : Colors.transparent)
                              : (_isHovered
                                    ? colors.primary.withValues(alpha: 0.12)
                                    : Colors.transparent),
                          borderRadius: BorderRadius.zero,
                        ),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                          color: isDark
                              ? (_isHovered ? Colors.white : colors.textMuted)
                              : (_isHovered
                                    ? colors.primary
                                    : colors.textMuted),
                        ),
                      ),
                    ),

                    const Spacer(),

                    Text(
                      patient.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 3),

                    Text(
                      patient.id,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.78),
                        fontFamily: 'monospace',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        if (patient.age != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.90),
                              borderRadius: BorderRadius.zero,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.55),
                              ),
                            ),
                            child: Text(
                              '${patient.age} yrs',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: colors.textOnPrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
