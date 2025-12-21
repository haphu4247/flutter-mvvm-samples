import 'package:flutter/material.dart';
import 'color_interface.dart';

/// Base theme class that provides common theme functionality
/// All specific theme implementations should extend this class
abstract class BaseTheme implements ColorInterface {
  @override
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

  /// Get the theme name
  String get themeName;

  /// Get the theme description
  String get themeDescription;

  /// Get the theme icon
  IconData get themeIcon;

  /// Create the complete ThemeData for this theme
  ThemeData get themeData => ThemeData(
        useMaterial3: true,
        brightness: brightness,
        colorScheme: colorScheme,
        appBarTheme: _buildAppBarTheme(),
        elevatedButtonTheme: _buildElevatedButtonTheme(),
        outlinedButtonTheme: _buildOutlinedButtonTheme(),
        textButtonTheme: _buildTextButtonTheme(),
        inputDecorationTheme: _buildInputDecorationTheme(),
        bottomNavigationBarTheme: _buildBottomNavigationBarTheme(),
        iconTheme: _buildIconTheme(),
        dividerTheme: _buildDividerTheme(),
        chipTheme: _buildChipTheme(),
        switchTheme: _buildSwitchTheme(),
      );

  // AppBar theme builder
  AppBarTheme _buildAppBarTheme() => AppBarTheme(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: _getAppBarElevation(),
        centerTitle: true,
        shadowColor: shadow,
      );

  // Elevated button theme builder
  ElevatedButtonThemeData _buildElevatedButtonTheme() =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: _getButtonElevation(),
          shadowColor: shadow,
          padding: _getButtonPadding(),
          shape: _getButtonShape(),
        ),
      );

  // Outlined button theme builder
  OutlinedButtonThemeData _buildOutlinedButtonTheme() =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary, width: _getBorderWidth()),
          padding: _getButtonPadding(),
          shape: _getButtonShape(),
        ),
      );

  // Text button theme builder
  TextButtonThemeData _buildTextButtonTheme() => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: _getTextButtonPadding(),
        ),
      );

  // Input decoration theme builder
  InputDecorationTheme _buildInputDecorationTheme() => InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: _getInputBorderRadius(),
          borderSide: BorderSide(color: inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _getInputBorderRadius(),
          borderSide: BorderSide(color: inputFocusedBorder, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _getInputBorderRadius(),
          borderSide: BorderSide(color: inputBorder),
        ),
        contentPadding: _getInputPadding(),
        filled: _isInputFilled(),
        fillColor: _isInputFilled() ? inputBackground : null,
      );

  // Bottom navigation bar theme builder
  BottomNavigationBarThemeData _buildBottomNavigationBarTheme() =>
      BottomNavigationBarThemeData(
        backgroundColor: navigationBackground,
        selectedItemColor: navigationSelected,
        unselectedItemColor: navigationUnselected,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      );

  // Icon theme builder
  IconThemeData _buildIconTheme() => IconThemeData(
        color: textPrimary,
        size: 24,
      );

  // Divider theme builder
  DividerThemeData _buildDividerTheme() => DividerThemeData(
        color: divider,
        thickness: 1,
      );

  // Chip theme builder
  ChipThemeData _buildChipTheme() => ChipThemeData(
        backgroundColor: chipBackground,
        selectedColor: chipSelected,
        labelStyle: TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );

  // Switch theme builder
  SwitchThemeData _buildSwitchTheme() => SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return switchThumb;
          }
          return divider;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return switchTrack;
          }
          return divider;
        }),
      );

  // Override these methods in child themes for customization
  double _getAppBarElevation() => 2;
  double _getButtonElevation() => 2;
  double _getBorderWidth() => 1;
  EdgeInsets _getButtonPadding() =>
      const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
  EdgeInsets _getTextButtonPadding() =>
      const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  EdgeInsets _getInputPadding() =>
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  OutlinedBorder _getButtonShape() =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
  BorderRadius _getInputBorderRadius() => BorderRadius.circular(8);
  bool _isInputFilled() => false;

  @override
  String toString() => '$themeName: $themeDescription';
}
