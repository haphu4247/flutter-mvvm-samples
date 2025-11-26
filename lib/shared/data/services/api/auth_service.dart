import 'package:flutter_mvvm_samples/core/network/base_api.dart';
import '../../models/login_response.dart';

class AuthService extends BaseApiClient {
  AuthService({required super.env});

  Future<ApiResult<LoginResponse>> login(
      {required String username, required String password}) async {
    return request<LoginResponse>(
        path: '/auth/login',
        method: BaseHttpMethod.post,
        fromJson: (json) => LoginResponse.fromJson(json),
        data: {
          'username': username,
          'password': password,
          'expiresInMins': 1,
        });
  }

  Future<ApiResult<LoginResponse>> refreshToken(
      {required String refreshToken}) async {
    return request<LoginResponse>(
        path: '/auth/refresh',
        method: BaseHttpMethod.post,
        fromJson: (json) => LoginResponse.fromJson(json),
        data: {
          'refreshToken': refreshToken,
          'expiresInMins': 1,
        });
  }
}
