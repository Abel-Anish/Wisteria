import 'package:flutter/material.dart';

import '../../core/database/database.dart';
import '../../core/theme/wisteria_theme.dart';
import '../doctor/doctor_profile_page.dart';
import '../models/medical_model_page.dart';
import '../offline_model/offline_model_page.dart';
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
                  // ── Header ──
                  _buildHeader(context),

                  const SizedBox(height: 48),

                  // ── System cards grid ──
                  Expanded(child: _buildGrid(context, constraints.maxWidth)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = WisteriaColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Doctor & System',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Profile, settings, models, sync, and offline AI',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: colors.textSecondary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, double maxWidth) {
    final isNarrow = maxWidth < 700;
    final colors = WisteriaColors.of(context);

    final cards = [
      _SystemCard(
        title: 'Doctor Profile',
        subtitle: 'Manage your professional profile and clinic information',
        icon: Icons.person_rounded,
        accentColor: WisteriaColors.mutedRose,
        tintColor: WisteriaColors.mutedRose,
        imagePath: 'assets/images/doctor.png',
        onTap: () => _navigate(context, DoctorProfilePage(database: database)),
      ),
      _SystemCard(
        title: 'Settings',
        subtitle: 'Application preferences and configuration',
        icon: Icons.settings_rounded,
        accentColor: WisteriaColors.pink,
        tintColor: WisteriaColors.pink,
        imagePath: 'assets/images/settings.jpg',
        onTap: () => _navigate(context, SettingsPage(database: database)),
      ),
      _SystemCard(
        title: 'Models',
        subtitle: 'View preinstalled local AI models',
        icon: Icons.memory_rounded,
        accentColor: colors.primary,
        tintColor: colors.primary,
        imagePath: 'assets/images/model.jpg',
        onTap: () => _navigate(context, MedicalModelPage(database: database)),
      ),
      _SystemCard(
        title: 'Sync',
        subtitle: 'Data synchronization across workstations',
        icon: Icons.sync_rounded,
        accentColor: colors.secondary,
        tintColor: colors.primary,
        imagePath: 'assets/images/data sync.jpg',
        onTap: () => _navigate(
          context,
          const PlaceholderPage(
            title: 'Data Synchronization',
            subtitle: 'Synchronize clinical data across your workstations.',
            icon: Icons.sync_rounded,
          ),
        ),
      ),
      _SystemCard(
        title: 'Offline Model',
        subtitle: 'Chat with locally running AI models',
        icon: Icons.psychology_rounded,
        accentColor: colors.tertiary,
        tintColor: colors.primary,
        imagePath: 'assets/images/model.jpg',
        onTap: () => _navigate(context, const OfflineModelPage()),
      ),
    ];

    if (isNarrow) {
      return ListView(
        children: cards
            .map(
              (card) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(height: 180, child: card),
              ),
            )
            .toList(),
      );
    }

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 20),
              Expanded(child: cards[1]),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Row(
            children: [
              Expanded(child: cards[2]),
              const SizedBox(width: 20),
              Expanded(child: cards[3]),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 160,
          child: Row(
            children: [
              Expanded(child: cards[4]),
            ],
          ),
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
  final IconData icon;
  final Color accentColor;
  final Color? tintColor;
  final String? imagePath;
  final VoidCallback onTap;

  const _SystemCard({
    required this.title,
    required this.subtitle,
    required this.icon,
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
    final isRose = widget.tintColor == WisteriaColors.mutedRose;
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
            final hoverBorderColor = widget.accentColor.withValues(alpha: 0.65);
            final borderColor = Color.lerp(
              colors.border,
              hoverBorderColor,
              t,
            )!;

            return Transform.translate(
              offset: Offset(0, -1 * t),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
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
                child: ClipRect(
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
                                          const Color(0xFFAF6A6A).withValues(
                                            alpha: 0.09,
                                          ),
                                          const Color(0xFF241A1E).withValues(
                                            alpha: 0.30,
                                          ),
                                          const Color(0xFF1E151A).withValues(
                                            alpha: 0.58,
                                          ),
                                          const Color(0xFF16141A).withValues(
                                            alpha: 0.82,
                                          ),
                                        ]
                                      : (isPink
                                          ? [
                                              const Color(0xFFC998A2).withValues(
                                                alpha: 0.07,
                                              ),
                                              const Color(0xFF201A20).withValues(
                                                alpha: 0.28,
                                              ),
                                              const Color(0xFF1B161B).withValues(
                                                alpha: 0.55,
                                              ),
                                              const Color(0xFF151419).withValues(
                                                alpha: 0.82,
                                              ),
                                            ]
                                          : [
                                              const Color(0xFF098FA6).withValues(
                                                alpha: 0.08,
                                              ),
                                              const Color(0xFF11222D).withValues(
                                                alpha: 0.28,
                                              ),
                                              const Color(0xFF13222E).withValues(
                                                alpha: 0.55,
                                              ),
                                              const Color(0xFF111923).withValues(
                                                alpha: 0.80,
                                              ),
                                            ]))
                                  : (isRose
                                      ? [
                                          const Color(0xFFAF6A6A).withValues(
                                            alpha: 0.06,
                                          ),
                                          const Color(0xFFF6ECEC).withValues(
                                            alpha: 0.18,
                                          ),
                                          const Color(0xFFFAF1F1).withValues(
                                            alpha: 0.52,
                                          ),
                                          const Color(0xFFFFFFFF).withValues(
                                            alpha: 0.85,
                                          ),
                                        ]
                                      : (isPink
                                          ? [
                                              const Color(0xFFC998A2).withValues(
                                                alpha: 0.04,
                                              ),
                                              const Color(0xFFF7F0F1).withValues(
                                                alpha: 0.16,
                                              ),
                                              const Color(0xFFFAF4F5).withValues(
                                                alpha: 0.50,
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
                                            ])),
                            ),
                          ),
                        ),
                      ),
                      // Foreground card content with exact existing layout
                      Padding(
                        padding: const EdgeInsets.all(28),
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
              _buildIcon(isDark),

              const Spacer(),

              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                  letterSpacing: 0.1,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                widget.subtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary,
                  height: 1.4,
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

  Widget _buildIcon(bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF192831).withValues(alpha: _isHovered ? 0.90 : 0.80)
            : Colors.white.withValues(alpha: _isHovered ? 0.95 : 0.88),
        borderRadius: BorderRadius.circular(WisteriaRadius.md),
        border: Border.all(
          color: _isHovered
              ? widget.accentColor.withValues(alpha: 0.50)
              : widget.accentColor.withValues(alpha: 0.25),
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
        size: 24,
        color: widget.accentColor,
      ),
    );
  }
}
