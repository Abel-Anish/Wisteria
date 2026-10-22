import 'package:flutter/material.dart';

import '../../core/database/database.dart';
import '../../core/theme/wisteria_theme.dart';
import '../patients/new_patient_registration_page.dart';
import '../patients/patient_page.dart';
import '../shared/wisteria_page_route.dart';

/// Panel A — Main Workspace Landing Page
///
/// Displays two hero cards: New Patient (faded medical-red) & Registered Patients (clinical teal).
class MainWorkspacePanel extends StatelessWidget {
  final WisteriaDatabase database;

  const MainWorkspacePanel({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 48, 48, 80),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Greeting ──
                  _buildGreeting(context),

                  const SizedBox(height: 48),

                  // ── Main cards ──
                  Expanded(
                    child: _buildMainCards(context, constraints.maxWidth),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final colors = WisteriaColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, Doctor',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Your clinical workspace',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: colors.textSecondary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildMainCards(BuildContext context, double maxWidth) {
    final isNarrow = maxWidth < 700;
    final colors = WisteriaColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final redAccent =
        isDark ? const Color(0xFFC998A2) : const Color(0xFF96162C);

    if (isNarrow) {
      return Column(
        children: [
          Expanded(
            child: _WorkspaceHeroCard(
              title: 'New Patient',
              subtitle: 'Register a new patient record',
              icon: Icons.person_add_rounded,
              accentColor: redAccent,
              tintColor: WisteriaColors.pink,
              imagePath: 'assets/images/new_patients.jpg',
              onTap: () => _navigateToNewPatient(context),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _WorkspaceHeroCard(
              title: 'Registered Patients',
              subtitle: 'Browse and search patient directory',
              icon: Icons.folder_shared_rounded,
              accentColor: colors.primary,
              tintColor: colors.primary,
              imagePath: 'assets/images/registered_patients.jpg',
              onTap: () => _navigateToRegisteredPatients(context),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _WorkspaceHeroCard(
            title: 'New Patient',
            subtitle: 'Register a new patient record',
            icon: Icons.person_add_rounded,
            accentColor: redAccent,
            tintColor: WisteriaColors.pink,
            imagePath: 'assets/images/new_patients.jpg',
            onTap: () => _navigateToNewPatient(context),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _WorkspaceHeroCard(
            title: 'Registered Patients',
            subtitle: 'Browse and search patient directory',
            icon: Icons.folder_shared_rounded,
            accentColor: colors.primary,
            tintColor: colors.primary,
            imagePath: 'assets/images/registered_patients.jpg',
            onTap: () => _navigateToRegisteredPatients(context),
          ),
        ),
      ],
    );
  }

  void _navigateToNewPatient(BuildContext context) {
    Navigator.of(context).push(
      WisteriaPageRoute(
        page: NewPatientRegistrationPage(database: database),
      ),
    );
  }

  void _navigateToRegisteredPatients(BuildContext context) {
    Navigator.of(context).push(
      WisteriaPageRoute(
        page: PatientPage(database: database, initialShowRegistry: true),
      ),
    );
  }
}

/// Sharp, visually prominent hero card for main workspace landing page.
class _WorkspaceHeroCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Color? tintColor;
  final String? imagePath;
  final VoidCallback onTap;

  const _WorkspaceHeroCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.tintColor,
    this.imagePath,
    required this.onTap,
  });

  @override
  State<_WorkspaceHeroCard> createState() => _WorkspaceHeroCardState();
}

class _WorkspaceHeroCardState extends State<_WorkspaceHeroCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPink = widget.tintColor == WisteriaColors.pink;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final t = _animation.value;
            final hoverBorderColor = isDark && !isPink
                ? const Color(0xFF4D4D4D)
                : widget.accentColor.withValues(alpha: 0.65);
            final borderColor = Color.lerp(
              colors.border,
              hoverBorderColor,
              t,
            )!;

            return Transform.translate(
              offset: Offset(0, -1 * t),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: isDark ? (6 + (5 * t)) : (4 + (4 * t)),
                      offset: Offset(0, isDark ? (2 + (2 * t)) : (1 + (2 * t))),
                      color: Colors.black.withValues(
                        alpha: isDark ? (0.22 + 0.08 * t) : (0.04 + 0.04 * t),
                      ),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Base surface fallback
                      Container(
                        color: isDark
                            ? (isPink
                                ? const Color(0xFF1E1722)
                                : colors.surface)
                            : colors.surface,
                      ),
                      // Background photo
                      if (widget.imagePath != null)
                        Positioned.fill(
                          child: Image.asset(
                            widget.imagePath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                      // Subtle pink/red or teal tinted gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.0, 0.40, 0.70, 1.0],
                              colors: isDark
                                  ? (isPink
                                      ? [
                                          const Color(0xFF96162C).withValues(
                                            alpha: 0.10,
                                          ),
                                          const Color(0xFF261922).withValues(
                                            alpha: 0.30,
                                          ),
                                          const Color(0xFF20161E).withValues(
                                            alpha: 0.58,
                                          ),
                                          const Color(0xFF16151E).withValues(
                                            alpha: 0.82,
                                          ),
                                        ]
                                      : [
                                          const Color(0xFF2D2D2D).withValues(
                                            alpha: 0.10,
                                          ),
                                          const Color(0xFF1D1D1D).withValues(
                                            alpha: 0.30,
                                          ),
                                          const Color(0xFF141414).withValues(
                                            alpha: 0.60,
                                          ),
                                          const Color(0xFF0D0D0D).withValues(
                                            alpha: 0.85,
                                          ),
                                        ])
                                  : (isPink
                                      ? [
                                          const Color(0xFFC998A2).withValues(
                                            alpha: 0.06,
                                          ),
                                          const Color(0xFFF7EBEF).withValues(
                                            alpha: 0.18,
                                          ),
                                          const Color(0xFFFBF2F4).withValues(
                                            alpha: 0.52,
                                          ),
                                          const Color(0xFFFFFFFF).withValues(
                                            alpha: 0.85,
                                          ),
                                        ]
                                      : [
                                          const Color(0xFF098FA6).withValues(
                                            alpha: 0.04,
                                          ),
                                          const Color(0xFFE4F0F3).withValues(
                                            alpha: 0.18,
                                          ),
                                          const Color(0xFFEAF4F6).withValues(
                                            alpha: 0.52,
                                          ),
                                          const Color(0xFFFFFFFF).withValues(
                                            alpha: 0.85,
                                          ),
                                        ]),
                            ),
                          ),
                        ),
                      ),
                      // Foreground card content
                      Padding(
                        padding: const EdgeInsets.all(36),
                        child: child,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Icon ──
              _buildIcon(isDark),

              const Spacer(),

              // ── Title ──
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),

              const SizedBox(height: 10),

              // ── Subtitle ──
              Text(
                widget.subtitle,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 20),

              // ── Action hint ──
              Row(
                children: [
                  Text(
                    'Open',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: widget.accentColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: widget.accentColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(bool isDark) {
    final isPink = widget.tintColor == WisteriaColors.pink;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: isDark
            ? (isPink
                ? const Color(0xFF241A22).withValues(alpha: _isHovered ? 0.90 : 0.80)
                : const Color(0xFF1D1D1D).withValues(alpha: _isHovered ? 0.95 : 0.85))
            : Colors.white.withValues(alpha: _isHovered ? 0.95 : 0.88),
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        border: Border.all(
          color: isDark && !isPink
              ? (_isHovered ? const Color(0xFF666666) : const Color(0xFF333333))
              : (_isHovered
                  ? widget.accentColor.withValues(alpha: 0.50)
                  : widget.accentColor.withValues(alpha: 0.25)),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(0, 2),
            color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.05),
          ),
        ],
      ),
      child: Icon(
        widget.icon,
        size: 26,
        color: isDark && !isPink ? Colors.white : widget.accentColor,
      ),
    );
  }
}
