import 'package:flutter/material.dart';

import '../../core/database/database.dart';
import '../../core/theme/wisteria_theme.dart';
import '../shared/wisteria_back_button.dart';

/// Settings page with genuine application preferences.
class SettingsPage extends StatefulWidget {
  final WisteriaDatabase database;

  const SettingsPage({super.key, required this.database});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  WisteriaBackButton(),
                  const Spacer(),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.textMuted,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 8,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Header ──
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Settings',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: colors.textPrimary,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Application preferences',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: colors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // ── Appearance ──
                        _buildSection(
                          colors: colors,
                          title: 'Appearance',
                          icon: Icons.palette_outlined,
                          children: [
                            _buildSettingRow(
                              colors: colors,
                              label: 'Theme',
                              description: 'Application visual theme',
                              trailing: const _ThemeSwitcher(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ── Application ──
                        _buildSection(
                          colors: colors,
                          title: 'Application',
                          icon: Icons.computer_rounded,
                          children: [
                            _buildSettingRow(
                              colors: colors,
                              label: 'Version',
                              description: 'Wisteria Clinical AI Workstation',
                              trailing: Text(
                                '1.0.0',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: colors.textSecondary,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            Divider(color: colors.border, height: 32),
                            _buildSettingRow(
                              colors: colors,
                              label: 'Runtime',
                              description: 'AI inference engine',
                              trailing: Text(
                                'ONNX Runtime',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ),
                            Divider(color: colors.border, height: 32),
                            _buildSettingRow(
                              colors: colors,
                              label: 'Storage',
                              description: 'Local database engine',
                              trailing: Text(
                                'SQLite (Drift)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required WisteriaColorPalette colors,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceLow,
        borderRadius: BorderRadius.zero,
        border: Border.all(color: colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: colors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow({
    required WisteriaColorPalette colors,
    required String label,
    required String description,
    required Widget trailing,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: colors.textMuted),
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}

/// Interactive Dark / Light mode switcher with square corners.
class _ThemeSwitcher extends StatelessWidget {
  const _ThemeSwitcher();

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: WisteriaThemeController.themeModeNotifier,
      builder: (context, currentMode, _) {
        final isDark = currentMode == ThemeMode.dark;

        return Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.zero,
            border: Border.all(color: colors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ThemeOption(
                label: 'Dark',
                icon: Icons.dark_mode_rounded,
                isSelected: isDark,
                onTap: () =>
                    WisteriaThemeController.setThemeMode(ThemeMode.dark),
              ),
              const SizedBox(width: 4),
              _ThemeOption(
                label: 'Light',
                icon: Icons.light_mode_rounded,
                isSelected: !isDark,
                onTap: () =>
                    WisteriaThemeController.setThemeMode(ThemeMode.light),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = WisteriaColors.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primaryMuted.withValues(alpha: 0.9)
                : Colors.transparent,
            borderRadius: BorderRadius.zero,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? colors.textOnPrimary : colors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? colors.textOnPrimary
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
