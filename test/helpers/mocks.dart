import 'package:mockito/annotations.dart';
import 'package:flutter_mvvm_samples/shared/data/services/api/auth_service.dart';
import 'package:flutter_mvvm_samples/shared/data/services/local/shared_preferences_service.dart';
import 'package:flutter_mvvm_samples/core/env/base_env_model.dart';

// Generate mocks with: flutter pub run build_runner build
@GenerateMocks([
  AuthService,
  SharedPreferencesService,
  BaseEnvModel,
])
import 'mocks.mocks.dart';
