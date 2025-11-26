import 'package:flutter_mvvm_samples/core/env/base_env_model.dart';
import 'package:flutter_mvvm_samples/features/posts/data/repositories/posts_repository.dart';
import 'package:flutter_mvvm_samples/shared/providers/locale_provider.dart';
import 'package:flutter_mvvm_samples/shared/providers/network_provider.dart';
import 'package:flutter_mvvm_samples/shared/providers/theme_provider.dart';
import 'package:flutter_mvvm_samples/shared/data/repositories/auth_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_mvvm_samples/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter_mvvm_samples/shared/data/services/local/shared_preferences_service.dart';
import 'package:flutter_mvvm_samples/shared/data/services/api/auth_service.dart';
import 'package:flutter_mvvm_samples/shared/data/services/api/posts_service.dart';
import 'package:flutter_mvvm_samples/shared/data/services/api/user_service.dart';

List<SingleChildWidget> multipleProviders(BaseEnvModel env) {
  // Create services
  final authService = AuthService(env: env);
  final postsService = PostsService(env: env);
  final userService = UserService(env: env);
  final sharedPreferencesService = const SharedPreferencesService();
  return [
    Provider(create: (context) => env),
    // Services
    Provider(create: (context) => authService),
    Provider(create: (context) => postsService),
    Provider(create: (context) => userService),
    Provider(create: (context) => sharedPreferencesService),
    // Repositories
    Provider(
        create: (context) =>
            AuthRepository(authService, sharedPreferencesService)),
    Provider(create: (context) => PostsRepository(postsService)),
    Provider(
        create: (context) =>
            ProfileRepository(userService, sharedPreferencesService)),
    // UI State Providers
    ChangeNotifierProvider(
        create: (_) => LocaleNotifier(sharedPreferencesService)),
    ChangeNotifierProvider(
        create: (_) => ThemeNotifier(sharedPreferencesService)),
    ChangeNotifierProvider(create: (_) => NetworkNotifier()),
  ];
}
