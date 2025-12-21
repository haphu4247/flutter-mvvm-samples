import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/shared/data/repositories/auth_repository.dart';
import 'package:flutter_mvvm_samples/shared/data/models/login_response.dart';
import 'package:flutter_mvvm_samples/mvvm/viewmodel/base_viewmodel.dart';

/// ViewModel for authentication UI
/// Responsibilities: Maintain UI state, expose commands, transform data for presentation
class LoginViewModel extends BaseViewModel {
  LoginViewModel(this._authRepository);

  final AuthRepository _authRepository;

  final TextEditingController usernameController =
      TextEditingController(text: 'emilys');
  final TextEditingController passwordController =
      TextEditingController(text: 'emilyspass');

  // UI State
  bool _isLoading = false;
  String? _errorMessage;
  AuthStatus? _authStatus;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _authStatus?.isLoggedIn ?? false;
  LoginResponse? get user => _authStatus?.user;

  @override
  void onInit({required BuildContext context}) {
    initialize();
  }

  /// Initialize and load current auth status
  Future<void> initialize() async {
    _isLoading = true;
    refreshUI();

    try {
      _authStatus = await _authRepository.currentAuthStatus;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      refreshUI();
    }
  }

  /// Command: Login user
  Future<void> login(
      {required String username, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    refreshUI();

    try {
      _authStatus =
          await _authRepository.login(username: username, password: password);
      // Status will update via stream listener
    } catch (e) {
      _errorMessage = e.toString();
      refreshUI();
    } finally {
      if (_errorMessage != null) {
        _isLoading = false;
        refreshUI();
      }
    }
  }

  /// Command: Logout user
  Future<void> logout() async {
    _isLoading = true;
    refreshUI();

    try {
      await _authRepository.logout();
    } catch (e) {
      _errorMessage = e.toString();
      refreshUI();
    } finally {
      _isLoading = false;
      refreshUI();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    refreshUI();
  }

  @override
  void onDispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onDispose();
  }
}
