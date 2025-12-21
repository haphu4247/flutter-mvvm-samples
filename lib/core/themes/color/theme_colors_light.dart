import 'package:flutter/material.dart';
import '../base_theme.dart';

/// Light theme color implementation
class LightThemeColors extends BaseTheme {
  @override
  String get themeName => 'Light';

  @override
  String get themeDescription => 'Clean, bright theme with blue primary colors';

  @override
  IconData get themeIcon => Icons.light_mode;

  @override
  Brightness get brightness => Brightness.light;

  // Primary colors
  @override
  Color get primary => const Color(0xFF2196F3);

  @override
  Color get primaryContainer => const Color(0xFF1976D2);

  @override
  Color get onPrimary => const Color(0xFFFFFFFF);

  // Secondary colors
  @override
  Color get secondary => const Color(0xFF03DAC6);

  @override
  Color get secondaryContainer => const Color(0xFF018786);

  @override
  Color get onSecondary => const Color(0xFF000000);

  // Surface colors
  @override
  Color get surface => const Color(0xFFFFFFFF);

  @override
  Color get background => const Color(0xFFF5F5F5);

  @override
  Color get onSurface => const Color(0xFF000000);

  @override
  Color get onBackground => const Color(0xFF000000);

  // Error colors
  @override
  Color get error => const Color(0xFFB00020);

  @override
  Color get onError => const Color(0xFFFFFFFF);

  // Utility colors
  @override
  Color get shadow => primary.withValues(alpha: 0.3);

  @override
  Color get divider => const Color(0xFFE0E0E0);

  @override
  Color get chipBackground => const Color(0xFFF5F5F5);

  @override
  Color get chipSelected => primary;

  @override
  Color get switchThumb => primary;

  @override
  Color get switchTrack => primary.withValues(alpha: 0.5);

  @override
  Color get inputBorder => const Color(0xFFE0E0E0);

  @override
  Color get inputFocusedBorder => primary;

  @override
  Color get inputBackground => const Color(0xFFFAFAFA);

  // Text colors
  @override
  Color get textPrimary => const Color(0xFF000000);

  @override
  Color get textSecondary => const Color(0xFF666666);

  @override
  Color get textCaption => const Color(0xFF999999);

  // Navigation colors
  @override
  Color get navigationSelected => primary;

  @override
  Color get navigationUnselected => const Color(0xFF666666);

  @override
  Color get navigationBackground => surface;
}
