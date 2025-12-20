import 'dart:convert';
import 'package:flutter_mvvm_samples/core/network/api_error.dart';
import 'package:flutter_mvvm_samples/shared/data/models/login_response.dart';
import 'package:flutter_mvvm_samples/shared/data/services/api/user_service.dart';
import 'package:flutter_mvvm_samples/shared/data/services/local/shared_preferences_service.dart';

/// Repository for user profile data
/// Handles: caching, error handling, retry logic
class ProfileRepository {
  ProfileRepository(this._userService, this._sharedPreferencesService);

  final UserService _userService;
  final SharedPreferencesService _sharedPreferencesService;

  /// Get cached profile if available
  Future<LoginResponse?> getCachedProfile() async {
    try {
      final cachedJson =
          await _sharedPreferencesService.getString(PrefKey.profileJson);

      if (cachedJson == null || cachedJson.isEmpty) {
        return null;
      }

      final profileData = json.decode(cachedJson) as Map<String, dynamic>;
      return LoginResponse.fromJson(profileData);
    } catch (e) {
      // Cache corrupted, return null
      return null;
    }
  }

  /// Fetch profile from API
  Future<LoginResponse> fetchProfile() async {
    final result = await _userService.getProfile();

    if (result.isFailure) {
      return Future.error(ApiError(message: result.error?.message));
    }

    final profile = result.data;
    if (profile == null) {
      throw ApiError(message: 'Profile data is null');
    }

    // Cache the profile
    await cacheProfile(profile);
    return profile;
  }

  /// Cache profile data
  Future<void> cacheProfile(LoginResponse profile) async {
    try {
      final profileJson = json.encode(profile.toJson());
      await _sharedPreferencesService.setString(
          PrefKey.profileJson, profileJson);
    } catch (e) {
      // Cache failure is not critical
    }
  }

  /// Clear cached profile
  Future<void> clearCache() async {
    await _sharedPreferencesService.remove(PrefKey.profileJson);
  }

  /// Get profile with automatic caching
  Future<LoginResponse> getProfile() async {
    // Try cache first
    final cached = await getCachedProfile();
    if (cached != null) {
      return cached;
    }

    // Fetch from API if no cache
    return await fetchProfile();
  }
}
