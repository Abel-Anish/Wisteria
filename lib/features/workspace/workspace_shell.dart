import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/database/database.dart';
import '../../core/theme/wisteria_theme.dart';
import '../offline_model/offline_model_page.dart';
import 'main_workspace_panel.dart';
import 'system_workspace_panel.dart';

/// Root three-panel horizontally sliding workspace.
///
/// Panel 0: Main Workspace (Patients + AI Workplace)
/// Panel 1: Doctor & System Workspace (Profile, Settings, Models, Sync)
/// Panel 2: Offline Model (Chat with local AI)
class WorkspaceShell extends StatefulWidget {
  final WisteriaDatabase database;

  const WorkspaceShell({super.key, required this.database});

  @override
  State<WorkspaceShell> createState() => _WorkspaceShellState();
}

class _WorkspaceShellState extends State<WorkspaceShell> {
  late final PageController _pageController;
  int _currentPage = 0;

  static const int _pageCount = 3;

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

  void _goToPreviousPage() {
    final prev = (_currentPage - 1 + _pageCount) % _pageCount;
    _goToPage(prev);
  }

  void _goToNextPage() {
    final next = (_currentPage + 1) % _pageCount;
    _goToPage(next);
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
            if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              _goToNextPage();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              _goToPreviousPage();
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
                const WisChatPage(),
              ],
            ),

            // ── Floating left-edge interface-switching button ──
            Positioned(
              left: 18,
              top: 0,
              bottom: 0,
              child: _FloatingEdgeButton(
                icon: Icons.chevron_left_rounded,
                tooltip: 'Previous interface',
                onTap: _goToPreviousPage,
              ),
            ),

            // ── Floating right-edge interface-switching button ──
            Positioned(
              right: 18,
              top: 0,
              bottom: 0,
              child: _FloatingEdgeButton(
                icon: Icons.chevron_right_rounded,
                tooltip: 'Next interface',
                onTap: _goToNextPage,
              ),
            ),

            // ── Unified navigation bar (tabs only) ──
            Positioned(
              bottom: 18,
              left: 0,
              right: 0,
              child: _WorkspaceNavigationBar(
                currentPage: _currentPage,
                onPageSelected: _goToPage,
              ),
            ),

          ],
        ),
      ),
    );
  }
}

/// Bottom segmented navigation bar — tabs only, no arrows.
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
            const SizedBox(width: 4),
            _NavSegment(
              icon: Icons.psychology_rounded,
              label: 'WisChat',
              isActive: currentPage == 2,
              onTap: () => onPageSelected(2),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating square interface-switching button that advances forward or backward.
class _FloatingEdgeButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _FloatingEdgeButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_FloatingEdgeButton> createState() => _FloatingEdgeButtonState();
}

class _FloatingEdgeButtonState extends State<_FloatingEdgeButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              duration: const Duration(milliseconds: 180),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isDark
                    ? (_isHovered ? const Color(0xFF4D4D4D) : colors.surfaceContainer)
                    : (_isHovered
                        ? colors.primary.withValues(alpha: 0.14)
                        : colors.surfaceContainer),
                borderRadius: BorderRadius.circular(WisteriaRadius.sm),
                border: Border.all(
                  color: isDark
                      ? (_isHovered ? const Color(0xFF666666) : colors.border)
                      : (_isHovered
                          ? colors.primary.withValues(alpha: 0.5)
                          : colors.border),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                size: 22,
                color: isDark
                    ? (_isHovered ? Colors.white : colors.textSecondary)
                    : (_isHovered ? colors.primary : colors.textSecondary),
              ),
            ),
          ),
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
