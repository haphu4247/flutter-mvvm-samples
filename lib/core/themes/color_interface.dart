import 'package:flutter/material.dart';

/// Abstract interface for theme colors
/// All theme color implementations must extend this interface
abstract class ColorInterface {
  // Primary colors
  Color get primary;
  Color get primaryContainer;
  Color get onPrimary;

  // Secondary colors
  Color get secondary;
  Color get secondaryContainer;
  Color get onSecondary;

  // Surface colors
  Color get surface;
  Color get background; // Deprecated: Use surface instead
  Color get onSurface;
  Color get onBackground; // Deprecated: Use onSurface instead

  // Error colors
  Color get error;
  Color get onError;

  // Additional utility colors
  Color get shadow;
  Color get divider;
  Color get chipBackground;
  Color get chipSelected;
  Color get switchThumb;
  Color get switchTrack;
  Color get inputBorder;
  Color get inputFocusedBorder;
  Color get inputBackground;

  // Text colors
  Color get textPrimary;
  Color get textSecondary;
  Color get textCaption;

  // Navigation colors
  Color get navigationSelected;
  Color get navigationUnselected;
  Color get navigationBackground;

  /// Get brightness for the color scheme
  Brightness get brightness;

  /// Create a ColorScheme from the interface colors
  ColorScheme get colorScheme => ColorScheme(
        brightness: brightness,
        primary: primary,
        primaryContainer: primaryContainer,
        secondary: secondary,
        secondaryContainer: secondaryContainer,
        surface: surface,
        error: error,
        onPrimary: onPrimary,
        onSecondary: onSecondary,
        onSurface: onSurface,
        onError: onError,
      );
}
