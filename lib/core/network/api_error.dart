import 'package:dio/dio.dart';

class ApiError {
  // Custom error class for API errors
  const ApiError({
    this.message,
    this.statusCode,
    this.type,
  });

  final String? message; // Error message
  final int? statusCode; // HTTP status code
  final DioExceptionType? type;

  @override
  String toString() {
    return 'ApiError(message: $message, statusCode: $statusCode, type: $type)';
  }
}
