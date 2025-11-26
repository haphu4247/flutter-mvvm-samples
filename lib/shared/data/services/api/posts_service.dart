import 'package:dio/dio.dart';
import 'package:flutter_mvvm_samples/core/network/base_api.dart';
import 'package:flutter_mvvm_samples/shared/data/models/product_model.dart';

class PostsService extends BaseApiClient {
  PostsService({required super.env});

  Future<ApiResult<List<PostModel>>> fetchPosts(
      {required int page, required int limit}) async {
    // For a list response
    //https://jsonplaceholder.typicode.com/posts?_page=1&_limit=10
    return requestList<PostModel>(
        path: 'https://jsonplaceholder.typicode.com/posts',
        method: BaseHttpMethod.get,
        query: {
          '_page': page,
          '_limit': limit,
        },
        fromJson: (json) => PostModel.fromJson(json),
        options: Options(headers: {'Accept': 'application/json'}));
  }
}
