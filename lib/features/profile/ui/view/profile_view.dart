import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/features/profile/ui/viewmodel/profile_viewmodel.dart';
import 'package:flutter_mvvm_samples/core/translations/generated/app_localizations.dart';
import 'package:flutter_mvvm_samples/core/router/app_route_path.dart';
import 'package:flutter_mvvm_samples/mvvm/view/base_view.dart';
import 'package:flutter_mvvm_samples/features/profile/ui/widgets/theme_selector_widget.dart';
import 'package:flutter_mvvm_samples/features/profile/ui/widgets/language_selector_widget.dart';

/// Profile View - UI Layer
/// Responsibilities: Render profile data, handle user interactions
class ProfileView extends BaseView<ProfileViewModel> {
  const ProfileView({super.key, required super.vm});

  @override
  Widget buildView(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.profileTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppRoutePath.home.go(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.profileEditComingSoon)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.profileRefreshing)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            _buildProfileHeader(context),
            const SizedBox(height: 24),

            // Profile Details
            _buildProfileDetails(context, loc),
            const SizedBox(height: 24),

            // Settings Section
            _buildSettingsSection(context, loc),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(vm.profile?.image ?? ''),
              radius: 50,
              onBackgroundImageError: (exception, stackTrace) {
                // Handle image loading error
              },
              child: vm.profile?.image?.isEmpty ?? true
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              '${vm.profile?.firstName} ${vm.profile?.lastName}',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '@${vm.profile?.username}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetails(BuildContext context, AppLocalizations loc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.profileInformation,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              context: context,
              icon: Icons.email,
              label: loc.profileEmail,
              value: vm.profile?.email ?? '',
            ),
            _buildDetailRow(
              context: context,
              icon: Icons.person,
              label: loc.profileFullName,
              value: '${vm.profile?.firstName} ${vm.profile?.lastName}',
            ),
            _buildDetailRow(
              context: context,
              icon: Icons.badge,
              label: loc.profileUsername,
              value: vm.profile?.username ?? '',
            ),
            _buildDetailRow(
              context: context,
              icon: Icons.wc,
              label: loc.profileGender,
              value: vm.profile?.gender ?? '',
            ),
            _buildDetailRow(
              context: context,
              icon: Icons.fingerprint,
              label: loc.profileUserId,
              value: vm.profile?.id.toString() ?? '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, AppLocalizations loc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.tabSettings,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const ThemeSelectorWidget(),
            const SizedBox(height: 12),
            const LanguageSelectorWidget(),
          ],
        ),
      ),
    );
  }
}
