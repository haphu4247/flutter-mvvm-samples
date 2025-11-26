import 'package:dio/dio.dart';
import 'package:flutter_mvvm_samples/core/env/base_env_model.dart';

import 'interceptor/refresh_token_interceptor.dart';

class DioClient {
  DioClient._internal({required BaseEnvModel env})
      : dio = Dio(
          BaseOptions(
              baseUrl: env.apiHost,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
              headers: {'Content-Type': 'application/json'}),
        ) {
    dio.interceptors.add(RefreshTokenInterceptor(this, env));
  }

  static DioClient? _instance;
  factory DioClient({required BaseEnvModel env}) {
    _instance ??= DioClient._internal(env: env);
    return _instance!;
  }

  final Dio dio;
}
