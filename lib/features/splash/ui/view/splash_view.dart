import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/features/splash/ui/viewmodel/splash_viewmodel.dart';
import 'package:flutter_mvvm_samples/mvvm/view/base_view.dart';
import 'package:flutter_mvvm_samples/core/translations/generated/app_localizations.dart';

/// Splash View - UI Layer
/// Responsibilities: Render splash UI, navigate based on auth state
class SplashView extends BaseView<SplashViewModel> {
  const SplashView({super.key, required super.vm});

  @override
  Widget buildView(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(seconds: 3)).whenComplete(() {
        if (!context.mounted) return;
        vm.checkAuthStatus(context: context);
      });
    });

    return Scaffold(
      body: Center(
        child: Text(loc.splashScreen),
      ),
    );
  }
}
