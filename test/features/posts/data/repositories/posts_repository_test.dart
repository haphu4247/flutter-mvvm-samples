import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_mvvm_samples/features/posts/data/repositories/posts_repository.dart';
import 'package:flutter_mvvm_samples/shared/data/services/api/posts_service.dart';
import 'package:flutter_mvvm_samples/shared/data/models/product_model.dart';
import 'package:flutter_mvvm_samples/core/network/api_error.dart';
import 'package:flutter_mvvm_samples/core/network/base_api.dart';
import '../../../../helpers/test_helpers.dart' as helpers;

// Generate mocks: flutter pub run build_runner build
@GenerateMocks([PostsService])
import 'posts_repository_test.mocks.dart';

void main() {
  late PostsRepository repository;
  late MockPostsService mockPostsService;

  setUp(() {
    helpers.setupTestEnvironment();
    mockPostsService = MockPostsService();
    repository = PostsRepository(mockPostsService);
  });

  group('fetchPosts', () {
    test('should fetch posts successfully', () async {
      // Arrange
      const page = 1;
      const limit = 10;
      final posts = [
        const PostModel(id: '1', title: 'Post 1', body: 'Body 1'),
        const PostModel(id: '2', title: 'Post 2', body: 'Body 2'),
      ];

      when(mockPostsService.fetchPosts(page: page, limit: limit))
          .thenAnswer((_) async => ApiResult.success(posts));

      // Act
      final result = await repository.fetchPosts(page: page, limit: limit);

      // Assert
      expect(result, isA<List<PostModel>>());
      expect(result.length, equals(2));
      expect(result[0].id, equals('1'));
      expect(result[0].title, equals('Post 1'));
      verify(mockPostsService.fetchPosts(page: page, limit: limit)).called(1);
    });

    test('should return empty list when data is null', () async {
      // Arrange
      const page = 1;
      const limit = 10;

      when(mockPostsService.fetchPosts(page: page, limit: limit))
          .thenAnswer((_) async => ApiResult.success([]));

      // Act
      final result = await repository.fetchPosts(page: page, limit: limit);

      // Assert
      expect(result, isA<List<PostModel>>());
      expect(result, isEmpty);
    });

    test('should throw ApiError when fetch fails', () async {
      // Arrange
      const page = 1;
      const limit = 10;
      const errorMessage = 'Network error';

      when(mockPostsService.fetchPosts(page: page, limit: limit)).thenAnswer(
          (answer) async => ApiResult.failure(ApiError(message: errorMessage)));

      // Act & Assert
      expect(
          () => repository.fetchPosts(page: page, limit: limit),
          throwsA(isA<ApiError>()
              .having((e) => e.message, 'message', equals(errorMessage))));
    });

    test(
        'should throw ApiError with default message when error message is null',
        () async {
      // Arrange
      const page = 1;
      const limit = 10;

      when(mockPostsService.fetchPosts(page: page, limit: limit)).thenAnswer(
          (_) async => ApiResult.failure(ApiError(message: 'Unknown error')));

      // Act & Assert
      expect(
          () => repository.fetchPosts(page: page, limit: limit),
          throwsA(isA<ApiError>()
              .having((e) => e.message, 'message', equals('Unknown error'))));
    });
  });
}
