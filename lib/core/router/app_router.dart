import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/core/translations/generated/app_localizations.dart';
import 'package:flutter_mvvm_samples/shared/data/models/login_response.dart';
import 'package:flutter_mvvm_samples/features/auth/login/ui/view/login_view.dart';
import 'package:flutter_mvvm_samples/features/auth/login/ui/viewmodel/login_viewmodel.dart';
import 'package:flutter_mvvm_samples/features/home/ui/view/home_view.dart';
import 'package:flutter_mvvm_samples/features/home/ui/viewmodel/home_viewmodel.dart';
import 'package:flutter_mvvm_samples/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter_mvvm_samples/features/profile/ui/view/profile_view.dart';
import 'package:flutter_mvvm_samples/features/profile/ui/viewmodel/profile_viewmodel.dart';
import 'package:flutter_mvvm_samples/features/splash/ui/view/splash_view.dart';
import 'package:flutter_mvvm_samples/features/splash/ui/viewmodel/splash_viewmodel.dart';
import 'package:flutter_mvvm_samples/core/router/app_route_path.dart';
import 'package:flutter_mvvm_samples/shared/data/repositories/auth_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter createRouter({required GlobalKey<NavigatorState> navigatorKey}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutePath.splash.path,
    routes: [
      GoRoute(
        path: AppRoutePath.splash.path,
        builder: (context, state) => SplashView(
          vm: SplashViewModel(
            context.read<AuthRepository>(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutePath.login.path,
        builder: (context, state) => LoginView(
          vm: LoginViewModel(
            context.read<AuthRepository>(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutePath.home.path,
        builder: (context, state) => HomeView(
          vm: HomeViewModel(),
        ),
        routes: [],
      ),
      GoRoute(
        path: AppRoutePath.userProfile.path,
        builder: (context, state) {
          final profile = state.extra as LoginResponse?;
          if (profile == null) {
            // If no profile data is passed, redirect to home or show error
            final loc = AppLocalizations.of(context)!;
            return Scaffold(
              body: Center(
                child: Text(loc.profileDataNotAvailable),
              ),
            );
          }
          return ProfileView(
              vm: ProfileViewModel(context.read<ProfileRepository>()));
        },
      ),
    ],
  );
}
