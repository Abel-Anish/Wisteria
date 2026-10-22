import 'package:flutter/material.dart';

import '../../core/theme/wisteria_theme.dart';

/// Visually consistent placeholder page for modules not yet implemented.
class PlaceholderPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? accentColor;

  const PlaceholderPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    final accent = accentColor ?? colors.primary;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Back bar ──
            _buildBackBar(context),

            // ── Content ──
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon container
                      Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(
                            WisteriaRadius.xl,
                          ),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Icon(
                          icon,
                          size: 40,
                          color: accent.withValues(alpha: 0.7),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Title
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Subtitle
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Status pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceLow,
                          borderRadius: BorderRadius.circular(
                            WisteriaRadius.full,
                          ),
                          border: Border.all(color: colors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.construction_rounded,
                              size: 16,
                              color: colors.warning.withValues(
                                alpha: 0.7,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Coming in the next stage',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: colors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          _BackButton(onTap: () => Navigator.of(context).pop()),
          const Spacer(),
        ],
      ),
    );
  }
}

/// Reusable back button with hover effects.
class _BackButton extends StatefulWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isDark
                ? (_isHovered ? const Color(0xFF3D3D3D) : Colors.transparent)
                : (_isHovered
                    ? colors.primary.withValues(alpha: 0.10)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(WisteriaRadius.md),
            border: Border.all(
              color: isDark
                  ? (_isHovered
                      ? const Color(0xFF4D4D4D)
                      : colors.border.withValues(alpha: 0.5))
                  : (_isHovered
                      ? colors.primary.withValues(alpha: 0.3)
                      : colors.border.withValues(alpha: 0.5)),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_rounded,
                size: 18,
                color: isDark
                    ? (_isHovered ? Colors.white : colors.textSecondary)
                    : (_isHovered
                        ? colors.primary
                        : colors.textSecondary),
              ),
              const SizedBox(width: 8),
              Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? (_isHovered ? Colors.white : colors.textSecondary)
                      : (_isHovered
                          ? colors.primary
                          : colors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
