import 'package:flutter/material.dart';
import '../base_theme.dart';

/// Dark theme color implementation
class DarkThemeColors extends BaseTheme {
  @override
  String get themeName => 'Dark';

  @override
  String get themeDescription =>
      'Dark theme with proper contrast for comfortable viewing';

  @override
  IconData get themeIcon => Icons.dark_mode;

  @override
  Brightness get brightness => Brightness.dark;

  // Primary colors
  @override
  Color get primary => const Color(0xFF90CAF9);

  @override
  Color get primaryContainer => const Color(0xFF1976D2);

  @override
  Color get onPrimary => const Color(0xFF000000);

  // Secondary colors
  @override
  Color get secondary => const Color(0xFF03DAC6);

  @override
  Color get secondaryContainer => const Color(0xFF03DAC6);

  @override
  Color get onSecondary => const Color(0xFF000000);

  // Surface colors
  @override
  Color get surface => const Color(0xFF121212);

  @override
  Color get background => const Color(0xFF121212);

  @override
  Color get onSurface => const Color(0xFFFFFFFF);

  @override
  Color get onBackground => const Color(0xFFFFFFFF);

  // Error colors
  @override
  Color get error => const Color(0xFFCF6679);

  @override
  Color get onError => const Color(0xFF000000);

  // Utility colors
  @override
  Color get shadow => primary.withValues(alpha: 0.3);

  @override
  Color get divider => const Color(0xFF333333);

  @override
  Color get chipBackground => const Color(0xFF333333);

  @override
  Color get chipSelected => primary;

  @override
  Color get switchThumb => primary;

  @override
  Color get switchTrack => primary.withValues(alpha: 0.5);

  @override
  Color get inputBorder => const Color(0xFF333333);

  @override
  Color get inputFocusedBorder => primary;

  @override
  Color get inputBackground => const Color(0xFF1E1E1E);

  // Text colors
  @override
  Color get textPrimary => const Color(0xFFFFFFFF);

  @override
  Color get textSecondary => const Color(0xFFB0B0B0);

  @override
  Color get textCaption => const Color(0xFF808080);

  // Navigation colors
  @override
  Color get navigationSelected => primary;

  @override
  Color get navigationUnselected => const Color(0xFF808080);

  @override
  Color get navigationBackground => surface;
}
