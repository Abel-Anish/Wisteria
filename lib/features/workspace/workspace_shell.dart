import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/database/database.dart';
import '../../core/theme/wisteria_theme.dart';
import 'main_workspace_panel.dart';
import 'system_workspace_panel.dart';

/// Root two-panel horizontally sliding workspace.
///
/// Panel A: Main Workspace (Patients + AI Workplace)
/// Panel B: Doctor & System Workspace (Profile, Settings, Models, Sync)
class WorkspaceShell extends StatefulWidget {
  final WisteriaDatabase database;

  const WorkspaceShell({super.key, required this.database});

  @override
  State<WorkspaceShell> createState() => _WorkspaceShellState();
}

class _WorkspaceShellState extends State<WorkspaceShell> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      body: KeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        autofocus: true,
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
                _currentPage == 0) {
              _goToPage(1);
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
                _currentPage == 1) {
              _goToPage(0);
            }
          }
        },
        child: Stack(
          children: [
            // ── Page View ──
            PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const ClampingScrollPhysics(),
              children: [
                MainWorkspacePanel(database: widget.database),
                SystemWorkspacePanel(database: widget.database),
              ],
            ),

            // ── Navigation indicator ──
            Positioned(
              bottom: 18,
              left: 0,
              right: 0,
              child: _WorkspaceNavigationBar(
                currentPage: _currentPage,
                onPageSelected: _goToPage,
              ),
            ),

            // ── Edge navigation arrows ──
            if (_currentPage == 0)
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: _EdgeArrow(
                  icon: Icons.chevron_right_rounded,
                  tooltip: 'Doctor & System Workspace',
                  onTap: () => _goToPage(1),
                ),
              ),

            if (_currentPage == 1)
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: _EdgeArrow(
                  icon: Icons.chevron_left_rounded,
                  tooltip: 'Main Workspace',
                  onTap: () => _goToPage(0),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Segmented navigation indicator at the bottom center.
class _WorkspaceNavigationBar extends StatelessWidget {
  final int currentPage;
  final void Function(int) onPageSelected;

  const _WorkspaceNavigationBar({
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(WisteriaRadius.sm),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, 2),
              color: Colors.black.withValues(alpha: isDark ? 0.30 : 0.06),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NavSegment(
              icon: Icons.dashboard_rounded,
              label: 'Workspace',
              isActive: currentPage == 0,
              onTap: () => onPageSelected(0),
            ),
            const SizedBox(width: 4),
            _NavSegment(
              icon: Icons.settings_rounded,
              label: 'Doctor & System',
              isActive: currentPage == 1,
              onTap: () => onPageSelected(1),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual segment in the navigation bar.
class _NavSegment extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavSegment({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavSegment> createState() => _NavSegmentState();
}

class _NavSegmentState extends State<_NavSegment> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isActive
                ? colors.primary
                : _isHovered
                ? colors.surfaceHigh
                : Colors.transparent,
            borderRadius: BorderRadius.circular(WisteriaRadius.sm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 15,
                color: widget.isActive
                    ? colors.textOnPrimary
                    : _isHovered
                    ? colors.textPrimary
                    : colors.textSecondary,
              ),
              const SizedBox(width: 7),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: widget.isActive
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: widget.isActive
                      ? colors.textOnPrimary
                      : _isHovered
                      ? colors.textPrimary
                      : colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Subtle edge arrow button for panel navigation.
class _EdgeArrow extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _EdgeArrow({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_EdgeArrow> createState() => _EdgeArrowState();
}

class _EdgeArrowState extends State<_EdgeArrow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    return Center(
      child: Tooltip(
        message: widget.tooltip,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 72,
              decoration: BoxDecoration(
                color: _isHovered
                    ? colors.primary.withValues(alpha: 0.12)
                    : colors.surfaceLow.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(WisteriaRadius.md),
                border: Border.all(
                  color: _isHovered
                      ? colors.primary.withValues(alpha: 0.3)
                      : colors.border.withValues(alpha: 0.4),
                ),
              ),
              child: Icon(
                widget.icon,
                size: 24,
                color: _isHovered
                    ? colors.primary
                    : colors.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
