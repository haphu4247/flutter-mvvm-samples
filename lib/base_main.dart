import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_mvvm_samples/config/dependencies.dart';
import 'package:flutter_mvvm_samples/core/env/base_env_model.dart';
import 'package:flutter_mvvm_samples/core/router/app_router.dart';
import 'package:flutter_mvvm_samples/shared/widgets/loading_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mvvm_samples/core/translations/generated/app_localizations.dart';
import 'shared/providers/locale_provider.dart';
import 'shared/providers/theme_provider.dart';

void startApp(BaseEnvModel env) {
  return runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      runApp(
        MultiProvider(
          providers: multipleProviders(env),
          child: BaseMain(env: env),
        ),
      );
    },
    (error, stackTrace) {
      print(error);
      print(stackTrace);
    },
  );
}

class BaseMain extends StatefulWidget {
  const BaseMain({super.key, required this.env});
  final BaseEnvModel env;
  @override
  State<BaseMain> createState() => _BaseMainState();
}

class _BaseMainState extends State<BaseMain> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    final Locale? locale = Provider.of<LocaleNotifier>(context).state;
    final AppThemeMode currentThemeMode =
        Provider.of<ThemeNotifier>(context).state;

    return MaterialApp.router(
      locale: locale,
      routerConfig: createRouter(
        navigatorKey: _navigatorKey,
      ),
      theme: getCurrentThemeData(currentThemeMode),
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // routerConfig: ,
      title: 'Flutter Test Dev',
      builder: FlutterSmartDialog.init(
        loadingBuilder: (msg) => const LoadingView(),
        // toastBuilder: (msg) => ,
        builder: (context, child) {
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
