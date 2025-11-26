import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/core/router/app_route_path.dart';
import 'package:flutter_mvvm_samples/shared/data/repositories/auth_repository.dart';
import 'package:flutter_mvvm_samples/mvvm/viewmodel/base_viewmodel.dart';

class SplashViewModel extends BaseViewModel {
  SplashViewModel(this._authRepository);

  final AuthRepository _authRepository;

  void checkAuthStatus({required BuildContext context}) {
    _authRepository.currentAuthStatus.then((value) {
      if (value.isLoggedIn && context.mounted) {
        AppRoutePath.home.go(context);
      } else if (context.mounted) {
        AppRoutePath.login.go(context);
      }
    });
  }
}
