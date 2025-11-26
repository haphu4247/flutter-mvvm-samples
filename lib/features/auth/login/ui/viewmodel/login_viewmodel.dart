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

  void Function()? onRefresh;

  @override
  void onInit(
      {required void Function() onRefresh, required BuildContext context}) {
    this.onRefresh = onRefresh;
    initialize();
  }

  /// Initialize and load current auth status
  Future<void> initialize() async {
    _isLoading = true;
    onRefresh?.call();

    try {
      _authStatus = await _authRepository.currentAuthStatus;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      onRefresh?.call();
    }
  }

  /// Command: Login user
  Future<void> login(
      {required String username, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    onRefresh?.call();

    try {
      _authStatus =
          await _authRepository.login(username: username, password: password);
      // Status will update via stream listener
    } catch (e) {
      _errorMessage = e.toString();
      onRefresh?.call();
    } finally {
      if (_errorMessage != null) {
        _isLoading = false;
        onRefresh?.call();
      }
    }
  }

  /// Command: Logout user
  Future<void> logout() async {
    _isLoading = true;
    onRefresh?.call();

    try {
      await _authRepository.logout();
    } catch (e) {
      _errorMessage = e.toString();
      onRefresh?.call();
    } finally {
      _isLoading = false;
      onRefresh?.call();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    onRefresh?.call();
  }

  @override
  void onDispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onDispose();
  }
}
