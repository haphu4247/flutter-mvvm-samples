import 'package:flutter/material.dart';
import '../base_theme.dart';

/// Orange theme color implementation
class OrangeThemeColors extends BaseTheme {
  @override
  String get themeName => 'Orange';

  @override
  String get themeDescription =>
      'Vibrant orange theme with warm, energetic colors';

  @override
  IconData get themeIcon => Icons.wb_sunny;

  @override
  Brightness get brightness => Brightness.light;

  // Primary colors - Orange theme
  @override
  Color get primary => const Color(0xFFFF6B35); // Vibrant orange

  @override
  Color get primaryContainer => const Color(0xFFFF8A65); // Lighter orange

  @override
  Color get onPrimary => const Color(0xFFFFFFFF); // White text on orange

  // Secondary colors - Complementary blue
  @override
  Color get secondary => const Color(0xFF2196F3); // Blue to complement orange

  @override
  Color get secondaryContainer => const Color(0xFF64B5F6); // Lighter blue

  @override
  Color get onSecondary => const Color(0xFFFFFFFF); // White text on blue

  // Surface colors
  @override
  Color get surface => const Color(0xFFFFFFFF); // White surface

  @override
  Color get background => const Color(0xFFFFF8F5); // Very light orange tint

  @override
  Color get onSurface => const Color(0xFF2E2E2E); // Dark gray text

  @override
  Color get onBackground => const Color(0xFF2E2E2E); // Dark gray text

  // Error colors
  @override
  Color get error => const Color(0xFFD32F2F); // Red for errors

  @override
  Color get onError => const Color(0xFFFFFFFF); // White text on red

  // Utility colors
  @override
  Color get shadow => primary.withValues(alpha: 0.3); // Orange shadow

  @override
  Color get divider => const Color(0xFFFFE0B2); // Light orange divider

  @override
  Color get chipBackground => const Color(0xFFFFF3E0); // Very light orange

  @override
  Color get chipSelected => primary; // Orange for selected chips

  @override
  Color get switchThumb => primary; // Orange switch thumb

  @override
  Color get switchTrack =>
      primary.withValues(alpha: 0.5); // Semi-transparent orange

  @override
  Color get inputBorder => const Color(0xFFFFCC80); // Light orange border

  @override
  Color get inputFocusedBorder => primary; // Orange focused border

  @override
  Color get inputBackground =>
      const Color(0xFFFFF8F5); // Very light orange background

  // Text colors
  @override
  Color get textPrimary =>
      const Color(0xFF2E2E2E); // Dark gray for primary text

  @override
  Color get textSecondary =>
      const Color(0xFF666666); // Medium gray for secondary text

  @override
  Color get textCaption => const Color(0xFF999999); // Light gray for captions

  // Navigation colors
  @override
  Color get navigationSelected => primary; // Orange for selected nav items

  @override
  Color get navigationUnselected =>
      const Color(0xFF999999); // Gray for unselected nav items

  @override
  Color get navigationBackground => surface; // White navigation background
}
