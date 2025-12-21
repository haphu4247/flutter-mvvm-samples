import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter_mvvm_samples/shared/data/models/login_response.dart';
import 'package:flutter_mvvm_samples/mvvm/viewmodel/base_viewmodel.dart';

/// ViewModel for profile screen
class ProfileViewModel extends BaseViewModel {
  ProfileViewModel(this._profileRepository);

  final ProfileRepository _profileRepository;

  // UI State
  bool _isLoading = false;
  LoginResponse? _profile;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  LoginResponse? get profile => _profile;
  bool get hasProfile => _profile != null;
  String? get errorMessage => _errorMessage;

  @override
  void onInit({required BuildContext context}) {
    loadProfile();
  }

  /// Command: Load profile
  Future<void> loadProfile() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    refreshUI();

    try {
      _profile = await _profileRepository.getProfile();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      refreshUI();
    }
  }

  /// Command: Refresh profile
  Future<void> refreshProfile() async {
    _isLoading = true;
    _errorMessage = null;
    refreshUI();

    try {
      await _profileRepository.clearCache();
      _profile = await _profileRepository.fetchProfile();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      refreshUI();
    }
  }

  /// Clear profile
  void clearProfile() {
    _profile = null;
    _errorMessage = null;
    refreshUI();
  }
}
