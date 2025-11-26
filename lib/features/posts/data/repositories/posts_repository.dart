import 'package:flutter_mvvm_samples/core/network/api_error.dart';
import 'package:flutter_mvvm_samples/shared/data/models/product_model.dart';
import 'package:flutter_mvvm_samples/shared/data/services/api/posts_service.dart';

/// Repository for posts data
class PostsRepository {
  PostsRepository(this._postsService);

  final PostsService _postsService;

  /// Fetch posts with pagination
  /// Returns List<PostModel> on success
  /// Throws ApiException on failure
  Future<List<PostModel>> fetchPosts({
    required int page,
    required int limit,
  }) async {
    final result = await _postsService.fetchPosts(page: page, limit: limit);

    if (result.isFailure) {
      throw ApiError(message: result.error?.message ?? 'Failed to fetch posts');
    }

    return result.data ?? [];
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  ApiException(this.message);
  final String message;
}
