import 'package:flutter/material.dart';
import '../base_theme.dart';

/// Universal theme color implementation
class UniversalThemeColors extends BaseTheme {
  @override
  String get themeName => 'Universal';

  @override
  String get themeDescription =>
      'Modern theme with indigo colors and balanced design';

  @override
  IconData get themeIcon => Icons.settings_system_daydream;

  @override
  Brightness get brightness => Brightness.light;

  // Primary colors
  @override
  Color get primary => const Color(0xFF6366F1); // Indigo

  @override
  Color get primaryContainer => const Color(0xFF4F46E5);

  @override
  Color get onPrimary => const Color(0xFFFFFFFF);

  // Secondary colors
  @override
  Color get secondary => const Color(0xFF10B981); // Emerald

  @override
  Color get secondaryContainer => const Color(0xFF059669);

  @override
  Color get onSecondary => const Color(0xFFFFFFFF);

  // Surface colors
  @override
  Color get surface => const Color(0xFFF8FAFC); // Slate 50

  @override
  Color get background => const Color(0xFFF1F5F9); // Slate 100

  @override
  Color get onSurface => const Color(0xFF1E293B); // Slate 800

  @override
  Color get onBackground => const Color(0xFF1E293B);

  // Error colors
  @override
  Color get error => const Color(0xFFEF4444); // Red 500

  @override
  Color get onError => const Color(0xFFFFFFFF);

  // Utility colors
  @override
  Color get shadow => const Color(0xFF4F46E5).withValues(alpha: 0.1);

  @override
  Color get divider => const Color(0xFFE2E8F0);

  @override
  Color get chipBackground => const Color(0xFFF1F5F9);

  @override
  Color get chipSelected => primary;

  @override
  Color get switchThumb => primary;

  @override
  Color get switchTrack => primary.withValues(alpha: 0.5);

  @override
  Color get inputBorder => const Color(0xFFE2E8F0);

  @override
  Color get inputFocusedBorder => primary;

  @override
  Color get inputBackground => const Color(0xFFF8FAFC);

  // Text colors
  @override
  Color get textPrimary => const Color(0xFF1E293B);

  @override
  Color get textSecondary => const Color(0xFF64748B);

  @override
  Color get textCaption => const Color(0xFF94A3B8);

  // Navigation colors
  @override
  Color get navigationSelected => primary;

  @override
  Color get navigationUnselected => const Color(0xFF64748B);

  @override
  Color get navigationBackground => const Color(0xFFFFFFFF);
}
