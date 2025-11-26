import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/core/translations/generated/app_localizations.dart';
import 'package:flutter_mvvm_samples/core/router/app_route_path.dart';
import 'package:flutter_mvvm_samples/features/profile/ui/viewmodel/profile_viewmodel.dart';
import 'package:flutter_mvvm_samples/mvvm/view/base_view.dart';

/// Profile Icon View - UI Layer
/// Responsibilities: Display profile icon, handle navigation to profile
class ProfileIconView extends BaseView<ProfileViewModel> {
  const ProfileIconView({super.key, required super.vm});

  @override
  Widget buildView(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return IconButton(
      icon: vm.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.person),
      onPressed: vm.isLoading
          ? null
          : () => _handleProfileNavigation(context, vm, loc),
    );
  }

  /// Handle profile navigation logic
  Future<void> _handleProfileNavigation(
    BuildContext context,
    ProfileViewModel viewModel,
    AppLocalizations loc,
  ) async {
    // Ensure profile is loaded
    if (!viewModel.hasProfile) {
      await viewModel.loadProfile();
    }

    if (!context.mounted) return;

    // Navigate to profile screen
    if (viewModel.hasProfile) {
      AppRoutePath.userProfile.go(context, data: viewModel.profile);
    } else if (viewModel.errorMessage != null) {
      // Show error dialog if there's an error
      await _showErrorDialog(
        context: context,
        error: viewModel.errorMessage ?? loc.profileErrorUnknown,
        onRetry: () async {
          await viewModel.refreshProfile();
        },
      );
    } else {
      // Show error for no profile data
      await _showErrorDialog(
        context: context,
        error: loc.profileNoDataAvailable,
        onRetry: () async {
          await viewModel.loadProfile();
        },
      );
    }
  }

  /// Show error dialog for profile errors
  Future<void> _showErrorDialog({
    required BuildContext context,
    required String error,
    required VoidCallback onRetry,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[300],
            ),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.profileError),
          ],
        ),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => AppRoutePath.back(context),
            child: Text(AppLocalizations.of(context)!.profileCancel),
          ),
          ElevatedButton.icon(
            onPressed: () {
              AppRoutePath.back(context);
              onRetry();
            },
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context)!.profileRetry),
          ),
        ],
      ),
    );
  }
}
