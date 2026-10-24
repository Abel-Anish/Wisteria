import 'package:flutter/material.dart';

import '../../core/database/database.dart';
import '../../core/theme/wisteria_theme.dart';
import '../doctor/doctor_profile_page.dart';
import '../models/medical_model_page.dart';
import '../shared/placeholder_page.dart';
import 'settings_page.dart';

/// Panel B — Doctor & System Workspace
///
/// Contains: Doctor Profile, Settings, Models, Sync.
class SystemWorkspacePanel extends StatelessWidget {
  final WisteriaDatabase database;

  const SystemWorkspacePanel({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasFiniteHeight = constraints.hasBoundedHeight;
        final availableHeight = hasFiniteHeight
            ? constraints.maxHeight - 36 - 80 - 60 - 28 - 22
            : 480.0;
        final cardHeight = (availableHeight / 2).clamp(210.0, double.infinity);

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(48, 36, 48, 80),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  _buildHeader(context),

                  const SizedBox(height: 28),

                  // ── System cards grid ──
                  _buildGrid(context, constraints.maxWidth, cardHeight),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = WisteriaColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Doctor & System',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Profile, settings, models, sync, and offline AI',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w400,
            color: colors.textSecondary.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, double maxWidth, double cardHeight) {
    final colors = WisteriaColors.of(context);

    final cards = [
      _SystemCard(
        title: 'Doctor Profile',
        subtitle: 'Manage your professional profile and clinic information',
        accentColor: WisteriaColors.mutedRose,
        tintColor: WisteriaColors.mutedRose,
        imagePath: 'assets/images/doctor.png',
        onTap: () => _navigate(context, DoctorProfilePage(database: database)),
      ),
      _SystemCard(
        title: 'Settings',
        subtitle: 'Application preferences and configuration',
        accentColor: WisteriaColors.pink,
        tintColor: WisteriaColors.pink,
        imagePath: 'assets/images/settings.jpg',
        onTap: () => _navigate(context, SettingsPage(database: database)),
      ),
      _SystemCard(
        title: 'Models',
        subtitle: 'View preinstalled local AI models',
        accentColor: colors.primary,
        tintColor: colors.primary,
        imagePath: 'assets/images/model.jpg',
        onTap: () => _navigate(context, MedicalModelPage(database: database)),
      ),
      _SystemCard(
        title: 'Sync',
        subtitle: 'Data synchronization across workstations',
        accentColor: colors.secondary,
        tintColor: colors.primary,
        imagePath: 'assets/images/data sync.jpg',
        onTap: () => _navigate(
          context,
          const PlaceholderPage(
            title: 'Data Synchronization',
            subtitle: 'Synchronize clinical data across your workstations.',
          ),
        ),
      ),
    ];

    if (maxWidth < 700) {
      return Column(
        children: [
          SizedBox(height: 180, child: cards[0]),
          const SizedBox(height: 16),
          SizedBox(height: 180, child: cards[1]),
          const SizedBox(height: 16),
          SizedBox(height: 180, child: cards[2]),
          const SizedBox(height: 16),
          SizedBox(height: 180, child: cards[3]),
        ],
      );
    }

    return Column(
      children: [
        // Row 1: Doctor Profile (left), Settings (right)
        Row(
          children: [
            Expanded(
              child: SizedBox(height: cardHeight, child: cards[0]),
            ),
            const SizedBox(width: 22),
            Expanded(
              child: SizedBox(height: cardHeight, child: cards[1]),
            ),
          ],
        ),
        const SizedBox(height: 22),
        // Row 2: Models (left), Sync (right)
        Row(
          children: [
            Expanded(
              child: SizedBox(height: cardHeight, child: cards[2]),
            ),
            const SizedBox(width: 22),
            Expanded(
              child: SizedBox(height: cardHeight, child: cards[3]),
            ),
          ],
        ),
      ],
    );
  }

  void _navigate(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}

/// System card for Panel B items.
class _SystemCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color accentColor;
  final Color? tintColor;
  final String? imagePath;
  final VoidCallback onTap;

  const _SystemCard({
    required this.title,
    required this.subtitle,
    required this.accentColor,
    this.tintColor,
    this.imagePath,
    required this.onTap,
  });

  @override
  State<_SystemCard> createState() => _SystemCardState();
}

class _SystemCardState extends State<_SystemCard>
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
            final isRose = widget.tintColor == WisteriaColors.mutedRose;
            final isPink = widget.tintColor == WisteriaColors.pink;
            final hoverBorderColor = isDark && !(isRose || isPink)
                ? const Color(0xFF4D4D4D)
                : widget.accentColor.withValues(alpha: 0.65);
            final borderColor = Color.lerp(colors.border, hoverBorderColor, t)!;

            return Transform.translate(
              offset: Offset(0, -2 * t),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  border: Border.all(color: borderColor, width: 1),
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
                  borderRadius: BorderRadius.zero,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Base surface fallback
                      Container(
                        color: isDark
                            ? (isRose
                                  ? const Color(0xFF1C151A)
                                  : (isPink
                                        ? const Color(0xFF1B161B)
                                        : colors.surface))
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
                      // Subtle rose, neutral-pink, or blue/teal tinted gradient overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.0, 0.40, 0.70, 1.0],
                              colors: isDark
                                  ? (isRose
                                        ? [
                                            const Color(
                                              0xFFAF6A6A,
                                            ).withValues(alpha: 0.09),
                                            const Color(
                                              0xFF241A1E,
                                            ).withValues(alpha: 0.30),
                                            const Color(
                                              0xFF1E151A,
                                            ).withValues(alpha: 0.58),
                                            const Color(
                                              0xFF16141A,
                                            ).withValues(alpha: 0.82),
                                          ]
                                        : (isPink
                                              ? [
                                                  const Color(
                                                    0xFFC998A2,
                                                  ).withValues(alpha: 0.07),
                                                  const Color(
                                                    0xFF201A20,
                                                  ).withValues(alpha: 0.28),
                                                  const Color(
                                                    0xFF1B161B,
                                                  ).withValues(alpha: 0.55),
                                                  const Color(
                                                    0xFF151419,
                                                  ).withValues(alpha: 0.82),
                                                ]
                                              : [
                                                  const Color(
                                                    0xFF2D2D2D,
                                                  ).withValues(alpha: 0.10),
                                                  const Color(
                                                    0xFF1D1D1D,
                                                  ).withValues(alpha: 0.30),
                                                  const Color(
                                                    0xFF141414,
                                                  ).withValues(alpha: 0.60),
                                                  const Color(
                                                    0xFF0D0D0D,
                                                  ).withValues(alpha: 0.85),
                                                ]))
                                  : (isRose
                                        ? [
                                            const Color(
                                              0xFFAF6A6A,
                                            ).withValues(alpha: 0.06),
                                            const Color(
                                              0xFFF6ECEC,
                                            ).withValues(alpha: 0.18),
                                            const Color(
                                              0xFFFAF1F1,
                                            ).withValues(alpha: 0.52),
                                            const Color(
                                              0xFFFFFFFF,
                                            ).withValues(alpha: 0.85),
                                          ]
                                        : (isPink
                                              ? [
                                                  const Color(
                                                    0xFFC998A2,
                                                  ).withValues(alpha: 0.04),
                                                  const Color(
                                                    0xFFF7F0F1,
                                                  ).withValues(alpha: 0.16),
                                                  const Color(
                                                    0xFFFAF4F5,
                                                  ).withValues(alpha: 0.50),
                                                  const Color(
                                                    0xFFFFFFFF,
                                                  ).withValues(alpha: 0.85),
                                                ]
                                              : [
                                                  const Color(
                                                    0xFF098FA6,
                                                  ).withValues(alpha: 0.04),
                                                  const Color(
                                                    0xFFE4F0F3,
                                                  ).withValues(alpha: 0.18),
                                                  const Color(
                                                    0xFFEAF4F6,
                                                  ).withValues(alpha: 0.52),
                                                  const Color(
                                                    0xFFFFFFFF,
                                                  ).withValues(alpha: 0.85),
                                                ])),
                            ),
                          ),
                        ),
                      ),
                      // Foreground card content
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 22,
                        ),
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
              const Spacer(),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: _isHovered
                        ? widget.accentColor
                        : colors.textMuted.withValues(alpha: 0.35),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                widget.subtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary,
                  height: 1.35,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
