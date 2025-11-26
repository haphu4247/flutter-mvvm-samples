import 'package:flutter_mvvm_samples/core/network/base_api.dart';
import '../../models/login_response.dart';

class UserService extends BaseApiClient {
  UserService({required super.env});

  Future<ApiResult<LoginResponse>> getProfile() async {
    return request<LoginResponse>(
      path: '/auth/me',
      method: BaseHttpMethod.get,
      fromJson: (json) => LoginResponse.fromJson(json),
    );
  }
}
