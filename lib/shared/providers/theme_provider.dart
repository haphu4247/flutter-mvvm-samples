import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/shared/data/services/local/shared_preferences_service.dart';
import 'package:flutter_mvvm_samples/core/themes/app_theme.dart';
import 'package:flutter_mvvm_samples/core/utils/log/app_logger.dart';

/// Theme mode enumeration
enum AppThemeMode {
  light('Light'),
  dark('Dark'),
  universal('Universal'),
  orange('Orange');

  const AppThemeMode(this.displayName);
  final String displayName;
}

/// Theme provider that manages app theme state
class ThemeNotifier extends ChangeNotifier {
  ThemeNotifier(this._sharedPreferencesService) : super() {
    _loadSavedTheme();
  }

  final SharedPreferencesService _sharedPreferencesService;

  AppThemeMode _state = AppThemeMode.universal;

  /// Get current theme mode as AppThemeMode
  AppThemeMode get state => _state;

  /// Load the saved theme from storage
  Future<void> _loadSavedTheme() async {
    try {
      final savedTheme =
          await _sharedPreferencesService.getString(PrefKey.theme);

      if (savedTheme != null && savedTheme.isNotEmpty) {
        final themeMode = AppThemeMode.values.firstWhere(
            (mode) => mode.name == savedTheme,
            orElse: () => AppThemeMode.universal);
        _state = themeMode;
        notifyListeners();
      }
    } catch (e) {
      // Handle error silently, use universal theme
      AppLogger.warning('Error loading saved theme', exception: e);
    }
  }

  /// Set theme and save it to storage
  Future<void> setTheme(AppThemeMode themeMode) async {
    _state = themeMode;
    notifyListeners();

    try {
      await _sharedPreferencesService.setString(PrefKey.theme, themeMode.name);
    } catch (e) {
      AppLogger.warning('Error saving theme', exception: e);
    }
  }

  /// Clear saved theme (reset to universal)
  Future<void> clearTheme() async {
    _state = AppThemeMode.universal;
    notifyListeners();
    try {
      await _sharedPreferencesService.remove(PrefKey.theme);
    } catch (e) {
      AppLogger.warning('Error clearing theme', exception: e);
    }
  }
}

// Helper function to get ThemeData based on current theme mode
ThemeData getCurrentThemeData(AppThemeMode themeMode) {
  switch (themeMode) {
    case AppThemeMode.light:
      return AppTheme.lightTheme;
    case AppThemeMode.dark:
      return AppTheme.darkTheme;
    case AppThemeMode.universal:
      return AppTheme.universalTheme;
    case AppThemeMode.orange:
      return AppTheme.orangeTheme;
  }
}
