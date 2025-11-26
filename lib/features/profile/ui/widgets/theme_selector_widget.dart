import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mvvm_samples/core/translations/generated/app_localizations.dart';
import 'package:flutter_mvvm_samples/shared/providers/theme_provider.dart';

/// Widget for selecting theme
class ThemeSelectorWidget extends StatelessWidget {
  const ThemeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final themeNotifier = context.watch<ThemeNotifier>();

    return InkWell(
      onTap: () => _showThemeDialog(context, loc, themeNotifier),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(
              Icons.palette,
              size: 24,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                loc.theme,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(
    BuildContext context,
    AppLocalizations loc,
    ThemeNotifier themeNotifier,
  ) {
    final currentTheme = themeNotifier.state;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(loc.theme),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ThemeOption(
                themeMode: AppThemeMode.light,
                label: loc.themeLight,
                currentTheme: currentTheme,
                onTap: () {
                  themeNotifier.setTheme(AppThemeMode.light);
                  Navigator.of(dialogContext).pop();
                },
              ),
              _ThemeOption(
                themeMode: AppThemeMode.dark,
                label: loc.themeDark,
                currentTheme: currentTheme,
                onTap: () {
                  themeNotifier.setTheme(AppThemeMode.dark);
                  Navigator.of(dialogContext).pop();
                },
              ),
              _ThemeOption(
                themeMode: AppThemeMode.universal,
                label: loc.themeUniversal,
                currentTheme: currentTheme,
                onTap: () {
                  themeNotifier.setTheme(AppThemeMode.universal);
                  Navigator.of(dialogContext).pop();
                },
              ),
              _ThemeOption(
                themeMode: AppThemeMode.orange,
                label: loc.themeOrange,
                currentTheme: currentTheme,
                onTap: () {
                  themeNotifier.setTheme(AppThemeMode.orange);
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.themeMode,
    required this.label,
    required this.currentTheme,
    required this.onTap,
  });

  final AppThemeMode themeMode;
  final String label;
  final AppThemeMode currentTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = currentTheme == themeMode;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
