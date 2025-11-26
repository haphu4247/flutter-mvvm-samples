import 'package:flutter_mvvm_samples/core/network/api_error.dart';
import 'package:flutter_mvvm_samples/shared/data/models/login_response.dart';
import 'package:flutter_mvvm_samples/shared/data/services/api/auth_service.dart';
import 'package:flutter_mvvm_samples/shared/data/services/local/shared_preferences_service.dart';
import 'dart:async';

/// Repository for authentication data
/// Handles: caching, error handling, retry logic, data transformation
class AuthRepository {
  AuthRepository(this._authService, this._sharedPreferencesService);

  final AuthService _authService;
  final SharedPreferencesService _sharedPreferencesService;

  /// Current authentication status
  Future<AuthStatus> get currentAuthStatus async {
    final accessToken =
        await _sharedPreferencesService.getString(PrefKey.accessToken);
    final refreshToken =
        await _sharedPreferencesService.getString(PrefKey.refreshToken);

    final isLoggedIn = accessToken != null &&
        accessToken.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty;

    return AuthStatus(
      isLoggedIn: isLoggedIn,
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: null, // Load user separately if needed
    );
  }

  /// Login with username and password
  Future<AuthStatus?> login(
      {required String username, required String password}) async {
    final result = await _authService.login(
      username: username,
      password: password,
    );

    if (result.isFailure) {
      throw ApiError(message: result.error?.message ?? 'Login failed');
    }

    final response = result.data;
    if (response != null) {
      // Cache tokens
      await _sharedPreferencesService.setString(
          PrefKey.accessToken, response.accessToken ?? '');
      await _sharedPreferencesService.setString(
          PrefKey.refreshToken, response.refreshToken ?? '');
      await _sharedPreferencesService.setBool(PrefKey.loggedIn, true);

      // Notify status change
      return AuthStatus(
        isLoggedIn: true,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        user: response,
      );
    }
    return null;
  }

  /// Logout and clear all auth data
  Future<AuthStatus> logout() async {
    await _sharedPreferencesService.remove(PrefKey.accessToken);
    await _sharedPreferencesService.remove(PrefKey.refreshToken);
    await _sharedPreferencesService.remove(PrefKey.accessExp);
    await _sharedPreferencesService.remove(PrefKey.profileJson);
    await _sharedPreferencesService.setBool(PrefKey.loggedIn, false);

    // Notify status change
    return const AuthStatus(
      isLoggedIn: false,
      accessToken: null,
      refreshToken: null,
      user: null,
    );
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final status = await currentAuthStatus;
    return status.isLoggedIn;
  }
}

/// Authentication status domain model
class AuthStatus {
  const AuthStatus({
    required this.isLoggedIn,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  final bool isLoggedIn;
  final String? accessToken;
  final String? refreshToken;
  final LoginResponse? user;
}
