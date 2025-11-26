import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/core/themes/color/theme_colors_dark.dart';
import 'package:flutter_mvvm_samples/core/themes/color/theme_colors_universal.dart';
import 'package:flutter_mvvm_samples/core/themes/color/theme_colors_orange.dart';
import 'color/theme_colors_light.dart';
import 'base_theme.dart';
import '../../shared/providers/theme_provider.dart';

/// Application theme configurations using the color interface system
class AppTheme {
  // Theme color instances
  static final LightThemeColors _lightColors = LightThemeColors();
  static final DarkThemeColors _darkColors = DarkThemeColors();
  static final UniversalThemeColors _universalColors = UniversalThemeColors();
  static final OrangeThemeColors _orangeColors = OrangeThemeColors();

  /// Light theme configuration
  static ThemeData get lightTheme => _lightColors.themeData;

  /// Dark theme configuration
  static ThemeData get darkTheme => _darkColors.themeData;

  /// Universal theme configuration
  static ThemeData get universalTheme => _universalColors.themeData;

  /// Orange theme configuration
  static ThemeData get orangeTheme => _orangeColors.themeData;

  /// Get theme colors by theme mode
  static BaseTheme getThemeColors(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return _lightColors;
      case AppThemeMode.dark:
        return _darkColors;
      case AppThemeMode.universal:
        return _universalColors;
      case AppThemeMode.orange:
        return _orangeColors;
    }
  }

  /// Get all available theme colors
  static List<BaseTheme> get allThemeColors => [
        _lightColors,
        _darkColors,
        _universalColors,
        _orangeColors,
      ];
}
