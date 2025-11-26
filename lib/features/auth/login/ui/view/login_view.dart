import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/features/auth/login/ui/viewmodel/login_viewmodel.dart';
import 'package:flutter_mvvm_samples/mvvm/view/base_view.dart';
import 'package:flutter_mvvm_samples/core/translations/generated/app_localizations.dart';
import 'package:flutter_mvvm_samples/core/router/app_route_path.dart';

/// Login View - UI Layer
/// Responsibilities: Render UI only, handle user gestures, call ViewModel commands
class LoginView extends BaseView<LoginViewModel> {
  const LoginView({super.key, required super.vm});

  Future<void> _onSubmit(BuildContext context) async {
    await vm.login(
      username: vm.usernameController.text.trim(),
      password: vm.passwordController.text.trim(),
    );
    if (context.mounted) {
      if (vm.isLoggedIn) {
        AppRoutePath.home.go(context);
      } else if (vm.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vm.errorMessage!),
          ),
        );
      }
    }
  }

  @override
  Widget buildView(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.loginTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: vm.usernameController,
              decoration: InputDecoration(labelText: loc.emailLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: vm.passwordController,
              decoration: InputDecoration(labelText: loc.passwordLabel),
              obscureText: true,
              onSubmitted: (_) => vm.isLoading ? null : _onSubmit(context),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: vm.isLoading ? null : () => _onSubmit(context),
              child: vm.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(loc.signIn),
            ),
          ],
        ),
      ),
    );
  }
}
