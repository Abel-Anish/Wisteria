import 'package:flutter/material.dart';

import '../../../core/theme/wisteria_theme.dart';

/// Data model for a dashboard card.
class DashboardCardData {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final String? metric;
  final String? metricLabel;
  final bool isHero;
  final Color? accentColor;

  const DashboardCardData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    this.metric,
    this.metricLabel,
    this.isHero = false,
    this.accentColor,
  });
}

/// Premium dashboard card with hover effects, animated elevation,
/// and optional accent/hero treatments.
class WisteriaDashboardCard extends StatefulWidget {
  final DashboardCardData data;
  final VoidCallback onTap;
  final int colSpan;

  const WisteriaDashboardCard({
    super.key,
    required this.data,
    required this.onTap,
    this.colSpan = 1,
  });

  @override
  State<WisteriaDashboardCard> createState() => _WisteriaDashboardCardState();
}

class _WisteriaDashboardCardState extends State<WisteriaDashboardCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _controller;
  late final Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _elevationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter() {
    setState(() => _isHovered = true);
    _controller.forward();
  }

  void _onExit() {
    setState(() => _isHovered = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = widget.data.accentColor ?? colors.primary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _elevationAnimation,
          builder: (context, child) {
            final t = _elevationAnimation.value;

            return Transform.translate(
              offset: Offset(0, -2 * t),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: widget.data.isHero
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  colors.surfaceHighest.withValues(alpha: 0.25),
                                  colors.surfaceLow,
                                  colors.surfaceLow,
                                ]
                              : [
                                  accent.withValues(alpha: 0.12),
                                  colors.surfaceLow,
                                  colors.surfaceLow,
                                ],
                        )
                      : colors.cardGradient,
                  borderRadius: BorderRadius.circular(WisteriaRadius.lg),
                  border: Border.all(
                    color: isDark
                        ? (_isHovered
                            ? const Color(0xFF4D4D4D)
                            : widget.data.isHero
                            ? const Color(0xFF333333)
                            : colors.border)
                        : (_isHovered
                            ? accent.withValues(alpha: 0.5)
                            : widget.data.isHero
                            ? accent.withValues(alpha: 0.2)
                            : colors.border),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8 + (16 * t),
                      spreadRadius: -2,
                      offset: Offset(0, 2 + (6 * t)),
                      color: Colors.black.withValues(alpha: 0.2 + (0.1 * t)),
                    ),
                    if (_isHovered || widget.data.isHero)
                      BoxShadow(
                        blurRadius: 24 + (8 * t),
                        spreadRadius: -4,
                        offset: Offset(0, 4 + (4 * t)),
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.20 * t)
                            : accent.withValues(
                                alpha: widget.data.isHero
                                    ? 0.08 + (0.1 * t)
                                    : 0.05 * t,
                              ),
                      ),
                  ],
                ),
                child: child,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon container
              _buildIconContainer(accent, isDark),

              const Spacer(),

              // Metric (if available)
              if (widget.data.metric != null) ...[
                Text(
                  widget.data.metric!,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : accent,
                    letterSpacing: -0.5,
                    height: 1,
                  ),
                ),
                if (widget.data.metricLabel != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.data.metricLabel!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: colors.textMuted,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
              ],

              // Title
              Text(
                widget.data.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                  letterSpacing: 0.2,
                ),
              ),

              const SizedBox(height: 6),

              // Subtitle
              Text(
                widget.data.subtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: colors.textMuted,
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

  Widget _buildIconContainer(Color accent, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: widget.data.isHero ? 56 : 48,
      height: widget.data.isHero ? 56 : 48,
      decoration: BoxDecoration(
        color: isDark
            ? (_isHovered ? const Color(0xFF4D4D4D) : const Color(0xFF2D2D2D))
            : (_isHovered
                ? accent.withValues(alpha: 0.18)
                : accent.withValues(alpha: 0.10)),
        borderRadius: BorderRadius.circular(WisteriaRadius.md),
        border: Border.all(
          color: isDark
              ? (_isHovered ? const Color(0xFF666666) : const Color(0xFF333333))
              : (_isHovered
                  ? accent.withValues(alpha: 0.3)
                  : Colors.transparent),
          width: 1,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          widget.data.icon,
          color: isDark
              ? Colors.white
              : (_isHovered ? accent : accent.withValues(alpha: 0.8)),
          size: widget.data.isHero ? 28 : 24,
        ),
      ),
    );
  }
}
