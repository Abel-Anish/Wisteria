import 'package:flutter/material.dart';
import '../../../core/theme/wisteria_theme.dart';

/// Interactive, image-based card for the Patient Dashboard.
///
/// Features a background JPG image with contrast gradient,
/// title, description, and smooth hover animations for desktop.
class PatientDashboardCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String description;
  final Color badgeColor;
  final VoidCallback onTap;
  final double? height;

  const PatientDashboardCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.badgeColor,
    required this.onTap,
    this.height,
  });

  @override
  State<PatientDashboardCard> createState() => _PatientDashboardCardState();
}

class _PatientDashboardCardState extends State<PatientDashboardCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.018).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleHover(bool hovering) {
    if (_isHovered == hovering) return;
    setState(() => _isHovered = hovering);
    if (hovering) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.zero,
            border: Border.all(
              color: _isHovered
                  ? widget.badgeColor.withValues(alpha: 0.8)
                  : (isDark
                        ? const Color(0xFF2E3846)
                        : colors.border.withValues(alpha: 0.9)),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? widget.badgeColor.withValues(alpha: 0.22)
                    : Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.zero,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // 1. Background JPG image
                Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: isDark
                          ? const Color(0xFF161F2E)
                          : const Color(0xFFE2E8F0),
                    );
                  },
                ),

                // 2. Gradient overlay for high text legibility
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        const Color(0xFF090E17).withValues(alpha: 0.90),
                        const Color(0xFF0F172A).withValues(alpha: 0.72),
                        const Color(0xFF0F172A).withValues(alpha: 0.25),
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),

                // 3. Subtle bottom tint
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF020617).withValues(alpha: 0.55),
                      ],
                      stops: const [0.5, 1.0],
                    ),
                  ),
                ),

                // 4. Foreground content: Title and Description
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Text info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: -0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              AnimatedOpacity(
                                opacity: _isHovered ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 180),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.description,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.white.withValues(alpha: 0.85),
                              height: 1.35,
                              letterSpacing: 0.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 5. Material touch/click ink surface
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.zero,
                    splashColor: widget.badgeColor.withValues(alpha: 0.15),
                    highlightColor: widget.badgeColor.withValues(alpha: 0.08),
                    onTap: widget.onTap,
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
