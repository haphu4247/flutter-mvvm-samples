import 'package:dio/dio.dart';
import 'package:flutter_mvvm_samples/core/env/base_env_model.dart';
import 'package:flutter_mvvm_samples/core/network/api_error.dart';
import 'package:flutter_mvvm_samples/core/utils/log/app_logger.dart';

import 'dio_client.dart';

class ApiResult<T> {
  const ApiResult._({this.data, this.error});

  final T? data;
  final ApiError? error;

  bool get isSuccess => data != null && error == null;
  bool get isFailure => error != null;

  static ApiResult<T> success<T>(T data) => ApiResult._(data: data);
  static ApiResult<T> failure<T>(ApiError error) => ApiResult._(error: error);
}

enum BaseHttpMethod {
  get('GET'),
  post('POST'),
  delete('DELETE');

  const BaseHttpMethod(this.method);
  final String method;
}

typedef FromJson<T> = T Function(Map<String, dynamic> json);

abstract class BaseApiClient {
  BaseApiClient({required this.env}) : _dio = DioClient(env: env).dio;
  final BaseEnvModel env;
  final Dio _dio;

  Future<ApiResult<T>> request<T>({
    required String path,
    required BaseHttpMethod method,
    Map<String, dynamic>? query,
    dynamic data,
    required FromJson<T> fromJson,
    Options? options,
  }) async {
    try {
      AppLogger.api(
        '${method.method} $path',
        data: {'query': query, 'data': data},
      );

      final Response res = await _dio.request(
        path,
        data: data,
        queryParameters: query,
        options: (options ?? Options()).copyWith(method: method.method),
      );

      AppLogger.api(
        'Response: ${res.statusCode} $path',
        data: res.data is Map<String, dynamic> ? res.data : null,
      );

      if (res.data != null) {
        if (res.data is Map<String, dynamic>) {
          return ApiResult.success(fromJson(res.data));
        }
      }

      final error = ApiError(
          message: 'Unexpected response format', statusCode: res.statusCode);
      AppLogger.warning(
        'Unexpected response format: $path',
      );
      return ApiResult.failure(error);
    } on DioException catch (e) {
      final error = ApiError(
        message: _messageForDio(e),
        statusCode: e.response?.statusCode,
        type: e.type,
      );
      AppLogger.error(
        'API Error: ${method.method} $path',
        exception: e,
      );
      return ApiResult.failure(error);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in API request: $path',
        exception: e,
        stackTrace: stackTrace,
      );
      return ApiResult.failure(ApiError(message: e.toString()));
    }
  }

  Future<ApiResult<List<T>>> requestList<T>({
    required String path,
    required BaseHttpMethod method,
    Map<String, dynamic>? query,
    dynamic data,
    required FromJson<T> fromJson,
    Options? options,
  }) async {
    try {
      final Response res = await _dio.request(
        path,
        data: data,
        queryParameters: query,
        options: (options ?? Options()).copyWith(method: method.method),
      );
      if (res.data != null) {
        if (res.data is List) {
          final List list = res.data as List;
          final items = list
              .map((e) => e is Map<String, dynamic> ? fromJson(e) : null)
              .whereType<T>();
          return ApiResult.success(items.toList());
        }
      }
      return ApiResult.failure(
        ApiError(
            message: 'Unexpected response format', statusCode: res.statusCode),
      );
    } on DioException catch (e) {
      final error = ApiError(
        message: _messageForDio(e),
        statusCode: e.response?.statusCode,
        type: e.type,
      );
      AppLogger.error(
        'API List Error: ${method.method} $path',
        exception: e,
      );
      return ApiResult.failure(error);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error in API list request: $path',
        exception: e,
        stackTrace: stackTrace,
      );
      return ApiResult.failure(ApiError(message: e.toString()));
    }
  }

  String _messageForDio(DioException e) {
    if (e.type == DioExceptionType.connectionError) {
      return 'No internet connection';
    }
    if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout';
    }
    if (e.type == DioExceptionType.receiveTimeout) return 'Receive timeout';
    if (e.type == DioExceptionType.sendTimeout) return 'Send timeout';
    if (e.response?.statusCode == 401) return 'Unauthorized';
    return e.message ?? 'Network error';
  }
}
