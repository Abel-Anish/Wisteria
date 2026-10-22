import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Wisteria Design System
///
/// Centralized clinical AI workstation theme system supporting
/// both Dark and Light modes.
///
/// Color palettes are defined centrally in [WisteriaColorPalette] and accessible
/// via [WisteriaColors.of(context)].
/// Theme switching is managed through [WisteriaThemeController].

/// Structured color palette for Wisteria themes.
class WisteriaColorPalette {
  final Brightness brightness;

  // ── Background layers ──
  final Color background;
  final Color surfaceLowest;
  final Color surfaceLow;
  final Color surface;
  final Color surfaceContainer;
  final Color surfaceHigh;
  final Color surfaceHighest;

  // ── Accent colors ──
  final Color primary;
  final Color primaryMuted;
  final Color secondary;
  final Color tertiary;
  final Color primaryContainer;

  // ── Text colors ──
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textOnPrimary;

  // ── Border colors ──
  final Color border;
  final Color borderSubtle;
  final Color borderFocus;

  // ── Semantic colors ──
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  // ── Tint colors ──
  final Color pink;
  final Color burgundy;
  final Color mutedRose;

  // ── Gradient presets ──
  final LinearGradient cardGradient;
  final LinearGradient accentGradient;
  final LinearGradient heroGradient;

  const WisteriaColorPalette({
    required this.brightness,
    required this.background,
    required this.surfaceLowest,
    required this.surfaceLow,
    required this.surface,
    required this.surfaceContainer,
    required this.surfaceHigh,
    required this.surfaceHighest,
    required this.primary,
    required this.primaryMuted,
    required this.secondary,
    required this.tertiary,
    required this.primaryContainer,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textOnPrimary,
    required this.border,
    required this.borderSubtle,
    required this.borderFocus,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.pink,
    required this.burgundy,
    required this.mutedRose,
    required this.cardGradient,
    required this.accentGradient,
    required this.heroGradient,
  });
}

/// Centralized color repository for Wisteria.
///
/// Preserves the exact dark theme colors while establishing the light theme structure.
/// Provides [WisteriaColors.of(context)] for theme-aware dynamic color access,
/// while maintaining static constants for backward compatibility.
class WisteriaColors {
  WisteriaColors._();

  // ── Tint colors ──
  static const Color pink = Color(0xFFC998A2);
  static const Color burgundy = Color(0xFF96162C);
  static const Color mutedRose = Color(0xFFAF6A6A);

  // ── Preserved Dark Theme Palette ──
  static const WisteriaColorPalette darkPalette = WisteriaColorPalette(
    brightness: Brightness.dark,
    background: Color(0xFF0D0D0D),
    surfaceLowest: Color(0xFF141414),
    surfaceLow: Color(0xFF1D1D1D),
    surface: Color(0xFF3D3D3D),
    surfaceContainer: Color(0xFF2D2D2D),
    surfaceHigh: Color(0xFF3D3D3D),
    surfaceHighest: Color(0xFF4D4D4D),
    primary: Color(0xFF098FA6),
    primaryMuted: Color(0xFF07788C),
    secondary: Color(0xFF0D9488),
    tertiary: Color(0xFF2DD4BF),
    primaryContainer: Color(0xFF1D2628),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFCCCCCC),
    textMuted: Color(0xFF8E8E8E),
    textOnPrimary: Color(0xFFFFFFFF),
    border: Color(0xFF333333),
    borderSubtle: Color(0xFF222222),
    borderFocus: Color(0xFF6E6E6E),
    success: Color(0xFF34D399),
    warning: Color(0xFFFBBF24),
    error: Color(0xFFEF4444),
    info: Color(0xFF098FA6),
    pink: Color(0xFFC998A2),
    burgundy: Color(0xFF96162C),
    mutedRose: Color(0xFFAF6A6A),
    cardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF3D3D3D), Color(0xFF353535)],
    ),
    accentGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF07788C), Color(0xFF098FA6)],
    ),
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2D2D2D), Color(0xFF1D1D1D), Color(0xFF0D0D0D)],
    ),
  );

  // ── Light Theme Palette ──
  static const WisteriaColorPalette lightPalette = WisteriaColorPalette(
    brightness: Brightness.light,
    background: Color(0xFFF0F5F6),
    surfaceLowest: Color(0xFFE7EEF2),
    surfaceLow: Color(0xFFF4F7F9),
    surface: Color(0xFFFFFFFF),
    surfaceContainer: Color(0xFFE7EEF2),
    surfaceHigh: Color(0xFFDFE7EC),
    surfaceHighest: Color(0xFFD7E1E7),
    primary: Color(0xFF098FA6),
    primaryMuted: Color(0xFF07788C),
    secondary: Color(0xFF0D9488),
    tertiary: Color(0xFF0891B2),
    primaryContainer: Color(0xFFE0F4F7),
    textPrimary: Color(0xFF1E293B),
    textSecondary: Color(0xFF5A6E7C),
    textMuted: Color(0xFF8697A1),
    textOnPrimary: Color(0xFFFFFFFF),
    border: Color(0xFFD7E1E7),
    borderSubtle: Color(0xFFE2EBEF),
    borderFocus: Color(0xFF098FA6),
    success: Color(0xFF10B981),
    warning: Color(0xFFF59E0B),
    error: Color(0xFFEF4444),
    info: Color(0xFF098FA6),
    pink: Color(0xFFC998A2),
    burgundy: Color(0xFF96162C),
    mutedRose: Color(0xFFAF6A6A),
    cardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
    ),
    accentGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF07788C), Color(0xFF098FA6)],
    ),
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFE7EEF2), Color(0xFFF0F4F6)],
    ),
  );

  /// Access the active color palette dynamically for the given [BuildContext].
  static WisteriaColorPalette of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.brightness == Brightness.dark ? darkPalette : lightPalette;
  }

  /// Access the current palette according to [WisteriaThemeController].
  static WisteriaColorPalette get current =>
      WisteriaThemeController.currentPalette;

  // ── Backward-compatible compile-time constants (Dark theme baseline) ──
  static const Color background = Color(0xFF0D0D0D);
  static const Color surfaceLowest = Color(0xFF141414);
  static const Color surfaceLow = Color(0xFF1D1D1D);
  static const Color surface = Color(0xFF3D3D3D);
  static const Color surfaceContainer = Color(0xFF2D2D2D);
  static const Color surfaceHigh = Color(0xFF3D3D3D);
  static const Color surfaceHighest = Color(0xFF4D4D4D);

  static const Color primary = Color(0xFF098FA6);
  static const Color primaryMuted = Color(0xFF07788C);
  static const Color secondary = Color(0xFF0D9488);
  static const Color tertiary = Color(0xFF2DD4BF);
  static const Color primaryContainer = Color(0xFF1D2628);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCCCCCC);
  static const Color textMuted = Color(0xFF8E8E8E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color border = Color(0xFF333333);
  static const Color borderSubtle = Color(0xFF222222);
  static const Color borderFocus = Color(0xFF6E6E6E);

  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF098FA6);

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3D3D3D), Color(0xFF353535)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF07788C), Color(0xFF098FA6)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D2D2D), Color(0xFF1D1D1D), Color(0xFF0D0D0D)],
  );
}

/// Centralized theme controller managing active theme mode and notifications.
class WisteriaThemeController {
  WisteriaThemeController._();

  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  static ThemeMode get currentThemeMode => themeModeNotifier.value;

  static bool get isDark => themeModeNotifier.value == ThemeMode.dark;

  static WisteriaColorPalette get currentPalette =>
      isDark ? WisteriaColors.darkPalette : WisteriaColors.lightPalette;

  /// Loads saved theme preference from local app storage.
  static Future<void> init() async {
    try {
      final dir = await getApplicationSupportDirectory();
      final file = File(p.join(dir.path, 'theme_mode.txt'));
      if (await file.exists()) {
        final content = (await file.readAsString()).trim();
        if (content == 'light') {
          themeModeNotifier.value = ThemeMode.light;
        } else if (content == 'dark') {
          themeModeNotifier.value = ThemeMode.dark;
        } else if (content == 'system') {
          themeModeNotifier.value = ThemeMode.system;
        }
      }
    } catch (_) {
      // Safely fall back to default theme mode on error
    }
  }

  static void setThemeMode(ThemeMode mode) {
    if (themeModeNotifier.value != mode) {
      themeModeNotifier.value = mode;
      _saveThemeMode(mode);
    }
  }

  static Future<void> _saveThemeMode(ThemeMode mode) async {
    try {
      final dir = await getApplicationSupportDirectory();
      final file = File(p.join(dir.path, 'theme_mode.txt'));
      await file.writeAsString(mode.name);
    } catch (_) {
      // Ignore save failures gracefully
    }
  }

  static void toggleTheme() {
    setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}

class WisteriaSpacing {
  WisteriaSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double section = 40;
  static const double page = 48;
}

class WisteriaRadius {
  WisteriaRadius._();

  static const double sm = 2;
  static const double md = 2;
  static const double lg = 3;
  static const double xl = 4;
  static const double full = 4;
}

class WisteriaElevation {
  WisteriaElevation._();

  static List<BoxShadow> get none => [];

  static List<BoxShadow> get low => [
    BoxShadow(
      blurRadius: 8,
      offset: const Offset(0, 2),
      color: Colors.black.withValues(alpha: 0.20),
    ),
  ];

  static List<BoxShadow> get medium => [
    BoxShadow(
      blurRadius: 16,
      offset: const Offset(0, 4),
      color: Colors.black.withValues(alpha: 0.25),
    ),
  ];

  static List<BoxShadow> get high => [
    BoxShadow(
      blurRadius: 24,
      spreadRadius: -4,
      offset: const Offset(0, 8),
      color: Colors.black.withValues(alpha: 0.35),
    ),
  ];

  static List<BoxShadow> accentGlow(Color color) => [
    BoxShadow(
      blurRadius: 24,
      spreadRadius: -4,
      offset: const Offset(0, 8),
      color: color.withValues(alpha: 0.18),
    ),
  ];
}

/// Builds the centralized ThemeData for Dark or Light mode.
ThemeData buildWisteriaTheme({Brightness brightness = Brightness.dark}) {
  final palette = brightness == Brightness.dark
      ? WisteriaColors.darkPalette
      : WisteriaColors.lightPalette;
  final isDark = brightness == Brightness.dark;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: 'Inter',

    // ── Color Scheme ──
    colorScheme: isDark
        ? ColorScheme.dark(
            surface: palette.surface,
            primary: palette.primary,
            primaryContainer: palette.primaryContainer,
            secondary: palette.secondary,
            tertiary: palette.tertiary,
            error: palette.error,
            onPrimary: palette.textOnPrimary,
            onSurface: palette.textPrimary,
            onSurfaceVariant: palette.textSecondary,
            outline: palette.border,
            outlineVariant: palette.borderSubtle,
            surfaceContainerLowest: palette.surfaceLowest,
            surfaceContainerLow: palette.surfaceLow,
            surfaceContainer: palette.surfaceContainer,
            surfaceContainerHigh: palette.surfaceHigh,
            surfaceContainerHighest: palette.surfaceHighest,
          )
        : ColorScheme.light(
            surface: palette.surface,
            primary: palette.primary,
            primaryContainer: palette.primaryContainer,
            secondary: palette.secondary,
            tertiary: palette.tertiary,
            error: palette.error,
            onPrimary: palette.textOnPrimary,
            onSurface: palette.textPrimary,
            onSurfaceVariant: palette.textSecondary,
            outline: palette.border,
            outlineVariant: palette.borderSubtle,
            surfaceContainerLowest: palette.surfaceLowest,
            surfaceContainerLow: palette.surfaceLow,
            surfaceContainer: palette.surfaceContainer,
            surfaceContainerHigh: palette.surfaceHigh,
            surfaceContainerHighest: palette.surfaceHighest,
          ),

    scaffoldBackgroundColor: palette.background,

    // ── AppBar ──
    appBarTheme: AppBarTheme(
      backgroundColor: palette.background,
      foregroundColor: palette.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
        letterSpacing: -0.3,
      ),
    ),

    // ── Card (BorderRadius = 0 for square corners) ──
    cardTheme: CardThemeData(
      color: palette.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: palette.border, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),

    // ── Dialog ──
    dialogTheme: DialogThemeData(
      backgroundColor: palette.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        side: BorderSide(color: palette.border, width: 1),
      ),
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
      ),
    ),

    // ── Input ──
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.surfaceLowest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        borderSide: BorderSide(color: palette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        borderSide: BorderSide(color: palette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        borderSide: BorderSide(color: palette.borderFocus, width: 1.5),
      ),
      labelStyle: TextStyle(
        color: palette.textSecondary,
        fontSize: 14,
      ),
      hintStyle: TextStyle(color: palette.textMuted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    // ── Buttons ──
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: palette.primaryMuted,
        foregroundColor: palette.textOnPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: palette.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WisteriaRadius.sm),
        ),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // ── FAB ──
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: palette.primaryMuted,
      foregroundColor: palette.textOnPrimary,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
      ),
    ),

    // ── SnackBar ──
    snackBarTheme: SnackBarThemeData(
      backgroundColor: palette.surfaceHigh,
      contentTextStyle: TextStyle(
        fontFamily: 'Inter',
        color: palette.textPrimary,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // ── Divider ──
    dividerTheme: DividerThemeData(
      color: palette.border,
      thickness: 1,
      space: 1,
    ),

    // ── ListTile ──
    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(WisteriaRadius.sm),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),

    // ── Text ──
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: palette.textPrimary,
        letterSpacing: -0.5,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: palette.textPrimary,
        letterSpacing: -0.3,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
        letterSpacing: -0.2,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: palette.textPrimary,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: palette.textSecondary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: palette.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: palette.textSecondary,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: palette.textMuted,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: palette.textPrimary,
        letterSpacing: 0.3,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: palette.textSecondary,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: palette.textMuted,
        letterSpacing: 0.5,
      ),
    ),
  );
}
