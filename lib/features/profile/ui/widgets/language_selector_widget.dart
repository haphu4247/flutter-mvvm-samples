import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mvvm_samples/core/translations/generated/app_localizations.dart';
import 'package:flutter_mvvm_samples/shared/providers/locale_provider.dart';

/// Widget for selecting language
class LanguageSelectorWidget extends StatelessWidget {
  const LanguageSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final localeNotifier = context.watch<LocaleNotifier>();

    return InkWell(
      onTap: () => _showLanguageDialog(context, loc, localeNotifier),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(
              Icons.language,
              size: 24,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                loc.language,
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

  void _showLanguageDialog(
    BuildContext context,
    AppLocalizations loc,
    LocaleNotifier localeNotifier,
  ) {
    final currentLocale = localeNotifier.state;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(loc.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LanguageOption(
                locale: const Locale('en'),
                label: loc.languageEnglish,
                currentLocale: currentLocale,
                onTap: () {
                  localeNotifier.setLocale(const Locale('en'));
                  Navigator.of(dialogContext).pop();
                },
              ),
              _LanguageOption(
                locale: const Locale('vi'),
                label: loc.languageVietnamese,
                currentLocale: currentLocale,
                onTap: () {
                  localeNotifier.setLocale(const Locale('vi'));
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

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.locale,
    required this.label,
    required this.currentLocale,
    required this.onTap,
  });

  final Locale locale;
  final String label;
  final Locale? currentLocale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = currentLocale?.languageCode == locale.languageCode;
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
