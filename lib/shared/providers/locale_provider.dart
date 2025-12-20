import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/shared/data/services/local/shared_preferences_service.dart';
import 'package:flutter_mvvm_samples/core/utils/log/app_logger.dart';

class LocaleNotifier extends ChangeNotifier {
  LocaleNotifier(this._sharedPreferencesService) : super() {
    _loadSavedLocale();
  }

  final SharedPreferencesService _sharedPreferencesService;

  Locale? _state;
  Locale? get state => _state;

  /// Load the saved locale from storage
  Future<void> _loadSavedLocale() async {
    try {
      final savedLocaleCode =
          await _sharedPreferencesService.getString(PrefKey.locale);

      if (savedLocaleCode != null && savedLocaleCode.isNotEmpty) {
        // Parse the locale code (e.g., "en" or "vi")
        final locale = Locale(savedLocaleCode);
        _state = locale;
        notifyListeners();
      }
    } catch (e) {
      // Handle error silently, use default locale
      AppLogger.warning('Error loading saved locale', exception: e);
    }
  }

  /// Set locale and save it to storage
  Future<void> setLocale(Locale? locale) async {
    _state = locale;
    notifyListeners();

    try {
      if (locale != null) {
        await _sharedPreferencesService.setString(
            PrefKey.locale, locale.languageCode);
      } else {
        await _sharedPreferencesService.remove(PrefKey.locale);
      }
    } catch (e) {
      AppLogger.warning('Error saving locale', exception: e);
    }
  }

  /// Clear saved locale
  Future<void> clearLocale() async {
    _state = null;
    notifyListeners();
    try {
      await _sharedPreferencesService.remove(PrefKey.locale);
    } catch (e) {
      AppLogger.warning('Error clearing locale', exception: e);
    }
  }
}
