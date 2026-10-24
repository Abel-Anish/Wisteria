import 'package:flutter/material.dart';

import '../../core/theme/wisteria_theme.dart';
import 'widgets/dashboard_card.dart';

class DashboardPage extends StatelessWidget {
  final void Function(String page) onNavigate;

  const DashboardPage({super.key, required this.onNavigate});

  List<DashboardCardData> get _cards => const [
    DashboardCardData(
      title: 'Patients',
      subtitle: 'Manage patient records',
      icon: Icons.people_rounded,
      route: 'patients',
      isHero: true,
      accentColor: WisteriaColors.primary,
    ),
    DashboardCardData(
      title: 'History',
      subtitle: 'View examination history',
      icon: Icons.history_rounded,
      route: 'history',
    ),
    DashboardCardData(
      title: 'Profile',
      subtitle: 'Doctor profile',
      icon: Icons.person_rounded,
      route: 'profile',
      accentColor: WisteriaColors.tertiary,
    ),
    DashboardCardData(
      title: 'Models',
      subtitle: 'Installed AI models',
      icon: Icons.memory_rounded,
      route: 'models',
    ),
    DashboardCardData(
      title: 'Sync',
      subtitle: 'Synchronize clinical data',
      icon: Icons.sync_rounded,
      route: 'sync',
    ),
    DashboardCardData(
      title: 'AI Workspace',
      subtitle: 'AI analysis workspace',
      icon: Icons.auto_awesome_rounded,
      route: 'ai',
      isHero: true,
      accentColor: WisteriaColors.tertiary,
    ),
    DashboardCardData(
      title: 'Analytics',
      subtitle: 'Clinical analytics & insights',
      icon: Icons.analytics_rounded,
      route: 'analytics',
    ),
    DashboardCardData(
      title: 'Model Registry',
      subtitle: 'Browse available models',
      icon: Icons.download_rounded,
      route: 'more_models',
    ),
    DashboardCardData(
      title: 'Settings',
      subtitle: 'Configure Wisteria',
      icon: Icons.settings_rounded,
      route: 'settings',
    ),
    DashboardCardData(
      title: 'Test Model',
      subtitle: 'Run an image through the local model',
      icon: Icons.science_rounded,
      route: 'test_model',
      accentColor: WisteriaColors.secondary,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: _getHorizontalPadding(constraints.maxWidth),
              vertical: 32,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Top bar ──
                    _buildTopBar(context),

                    const SizedBox(height: 40),

                    // ── Welcome section ──
                    _buildWelcomeSection(context),

                    const SizedBox(height: 36),

                    // ── Dashboard grid ──
                    _buildDashboardGrid(context, constraints.maxWidth),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth >= 1600) return 64;
    if (screenWidth >= 1200) return 48;
    if (screenWidth >= 900) return 32;
    return 24;
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        // Logo / App name
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: WisteriaColors.accentGradient,
                    borderRadius: BorderRadius.zero,
                  ),
                  child: const Icon(
                    Icons.local_hospital_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                const Text(
                  'WISTERIA',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: WisteriaColors.textPrimary,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.only(left: 50),
              child: Text(
                'Clinical AI Workstation',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: WisteriaColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),

        const Spacer(),

        // Status indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: WisteriaColors.surfaceLow,
            borderRadius: BorderRadius.zero,
            border: Border.all(color: WisteriaColors.border),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 8, color: WisteriaColors.success),
              SizedBox(width: 8),
              Text(
                'System Active',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: WisteriaColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Profile button
        _HoverIconButton(
          icon: Icons.person_rounded,
          tooltip: 'Doctor Profile',
          onTap: () => onNavigate('profile'),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome back, Doctor',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: WisteriaColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Your clinical workspace',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: WisteriaColors.textSecondary.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardGrid(BuildContext context, double screenWidth) {
    final cards = _cards;

    // Responsive column count
    int crossAxisCount;
    if (screenWidth >= 1100) {
      crossAxisCount = 3;
    } else if (screenWidth >= 750) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    return _StaggeredCardGrid(
      crossAxisCount: crossAxisCount,
      cards: cards,
      onNavigate: onNavigate,
    );
  }
}

/// Custom staggered grid that gives hero cards more visual weight.
class _StaggeredCardGrid extends StatelessWidget {
  final int crossAxisCount;
  final List<DashboardCardData> cards;
  final void Function(String) onNavigate;

  const _StaggeredCardGrid({
    required this.crossAxisCount,
    required this.cards,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    if (crossAxisCount <= 1) {
      return _buildSingleColumn();
    }

    if (crossAxisCount == 2) {
      return _buildTwoColumnLayout();
    }

    return _buildThreeColumnLayout();
  }

  Widget _buildSingleColumn() {
    return Column(
      children: cards.map((card) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SizedBox(
            height: card.isHero ? 200 : 170,
            child: WisteriaDashboardCard(
              data: card,
              onTap: () => onNavigate(card.route),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTwoColumnLayout() {
    return Column(
      children: [
        // Row 1: Patients (hero, wide) + History
        _buildRow([
          _CardSlot(cards[0], flex: 2), // Patients hero
          _CardSlot(cards[1], flex: 1), // History
        ], height: 200),

        const SizedBox(height: 16),

        // Row 2: Profile + Models
        _buildRow([
          _CardSlot(cards[2], flex: 1), // Profile
          _CardSlot(cards[3], flex: 1), // Models
        ], height: 180),

        const SizedBox(height: 16),

        // Row 3: Sync + AI (hero, wide)
        _buildRow([
          _CardSlot(cards[4], flex: 1), // Sync
          _CardSlot(cards[5], flex: 2), // AI hero
        ], height: 200),

        const SizedBox(height: 16),

        // Row 4: Analytics + More Models
        _buildRow([
          _CardSlot(cards[6], flex: 1), // Analytics
          _CardSlot(cards[7], flex: 1), // More Models
        ], height: 180),

        const SizedBox(height: 16),

        // Row 5: Settings + Test Model
        _buildRow([
          _CardSlot(cards[8], flex: 1), // Settings
          _CardSlot(cards[9], flex: 1), // Test Model
        ], height: 170),
      ],
    );
  }

  Widget _buildThreeColumnLayout() {
    return Column(
      children: [
        // Row 1: Patients (large, 2 col) + History (1 col)
        _buildRow([
          _CardSlot(cards[0], flex: 2), // Patients (hero)
          _CardSlot(cards[1], flex: 1), // History
        ], height: 210),

        const SizedBox(height: 16),

        // Row 2: Profile + Models + Sync
        _buildRow([
          _CardSlot(cards[2], flex: 1), // Profile
          _CardSlot(cards[3], flex: 1), // Models
          _CardSlot(cards[4], flex: 1), // Sync
        ], height: 185),

        const SizedBox(height: 16),

        // Row 3: AI (hero, 2 col) + Analytics
        _buildRow([
          _CardSlot(cards[5], flex: 2), // AI (hero)
          _CardSlot(cards[6], flex: 1), // Analytics
        ], height: 210),

        const SizedBox(height: 16),

        // Row 4: More Models + Settings + Test Model
        _buildRow([
          _CardSlot(cards[7], flex: 1), // More Models
          _CardSlot(cards[8], flex: 1), // Settings
          _CardSlot(cards[9], flex: 1), // Test Model
        ], height: 185),
      ],
    );
  }

  Widget _buildRow(List<_CardSlot> slots, {required double height}) {
    return SizedBox(
      height: height,
      child: Row(
        children: slots.asMap().entries.map((entry) {
          final index = entry.key;
          final slot = entry.value;

          return Expanded(
            flex: slot.flex,
            child: Padding(
              padding: EdgeInsets.only(
                left: index > 0 ? 8 : 0,
                right: index < slots.length - 1 ? 8 : 0,
              ),
              child: WisteriaDashboardCard(
                data: slot.card,
                onTap: () => onNavigate(slot.card.route),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CardSlot {
  final DashboardCardData card;
  final int flex;

  const _CardSlot(this.card, {this.flex = 1});
}

/// Icon button with hover effect for the top bar.
class _HoverIconButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _HoverIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_HoverIconButton> createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<_HoverIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
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
                  ? (_isHovered ? const Color(0xFF4D4D4D) : colors.surfaceLow)
                  : (_isHovered
                      ? colors.primary.withValues(alpha: 0.12)
                      : colors.surfaceLow),
              borderRadius: BorderRadius.zero,
              border: Border.all(
                color: isDark
                    ? (_isHovered ? const Color(0xFF666666) : colors.border)
                    : (_isHovered
                        ? colors.primary.withValues(alpha: 0.3)
                        : colors.border),
              ),
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: isDark
                  ? (_isHovered ? Colors.white : colors.textSecondary)
                  : (_isHovered ? colors.primary : colors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
