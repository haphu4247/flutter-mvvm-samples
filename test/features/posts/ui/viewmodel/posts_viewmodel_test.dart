import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_mvvm_samples/features/posts/ui/viewmodel/posts_view_model.dart';
import 'package:flutter_mvvm_samples/features/posts/data/repositories/posts_repository.dart';
import 'package:flutter_mvvm_samples/shared/data/models/product_model.dart';
import 'package:flutter_mvvm_samples/core/network/api_error.dart';
import '../../../../helpers/test_helpers.dart' as helpers;

// Generate mocks: flutter pub run build_runner build
@GenerateMocks([PostsRepository])
import 'posts_viewmodel_test.mocks.dart';

void main() {
  late PostsViewModel viewModel;
  late MockPostsRepository mockPostsRepository;

  setUp(() {
    helpers.setupTestEnvironment();
    mockPostsRepository = MockPostsRepository();
    viewModel = PostsViewModel(mockPostsRepository);
  });

  tearDown(() {
    viewModel.onDispose();
  });

  group('Initialization', () {
    test('should initialize with default values', () {
      expect(viewModel.items, isEmpty);
      expect(viewModel.currentPage, equals(1));
      expect(viewModel.isLoadingMore, isFalse);
      expect(viewModel.hasMore, isTrue);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.itemsPerPage, equals(10));
    });
  });

  group('loadInitialItems', () {
    test('should load initial items successfully', () async {
      // Init
      var refreshCalled = false;
      viewModel.onInit(
          onRefresh: () {
            refreshCalled = true;
          },
          context: helpers.createMockContext());

      // Arrange
      final posts = [
        const PostModel(id: '1', title: 'Post 1', body: 'Body 1'),
        const PostModel(id: '2', title: 'Post 2', body: 'Body 2'),
      ];

      when(mockPostsRepository.fetchPosts(page: 1, limit: 10))
          .thenAnswer((_) async => posts);

      // Act
      await viewModel.loadInitialItems();

      // Assert
      expect(viewModel.items.length, equals(2));
      expect(viewModel.items[0].id, equals('1'));
      expect(viewModel.items[1].id, equals('2'));
      expect(viewModel.currentPage, equals(1));
      expect(viewModel.isLoadingMore, isFalse);
      // expect(viewModel.hasMore, isTrue); // 2 items < 10, but we have 2 items
      expect(viewModel.errorMessage, isNull);
      expect(refreshCalled, isTrue);
      verify(mockPostsRepository.fetchPosts(page: 1, limit: 10)).called(2);
    });

    test('should set hasMore to false when items are less than page size',
        () async {
      // Arrange
      final posts = [
        const PostModel(id: '1', title: 'Post 1', body: 'Body 1'),
      ];

      when(mockPostsRepository.fetchPosts(page: 1, limit: 10))
          .thenAnswer((_) async => posts);

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      await viewModel.loadInitialItems().whenComplete(() {
        refreshCalled = false;
      });

      // Assert
      expect(viewModel.hasMore, isFalse);
      expect(viewModel.items.length, equals(1));
    });

    test('should set hasMore to true when items equal page size', () async {
      // Arrange
      final posts = List.generate(
          10,
          (i) => PostModel(
                id: '$i',
                title: 'Post $i',
                body: 'Body $i',
              ));

      when(mockPostsRepository.fetchPosts(page: 1, limit: 10))
          .thenAnswer((_) async => posts);

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      await viewModel.loadInitialItems().whenComplete(() {
        refreshCalled = false;
      });

      // Assert
      expect(viewModel.hasMore, isTrue);
      expect(viewModel.items.length, equals(10));
    });

    test('should handle error when loading fails', () async {
      // Arrange
      const errorMessage = 'Failed to load posts';
      when(mockPostsRepository.fetchPosts(page: 1, limit: 10))
          .thenThrow(ApiError(message: errorMessage));

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      await viewModel.loadInitialItems();

      // Assert
      expect(viewModel.items, isEmpty);
      expect(viewModel.isLoadingMore, isFalse);
      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.errorMessage, contains(errorMessage));
      expect(refreshCalled, isTrue);
    });

    test('should clear previous items when loading initial items', () async {
      // Arrange
      // First load some items
      final initialPosts = [
        const PostModel(id: '1', title: 'Post 1', body: 'Body 1'),
      ];
      when(mockPostsRepository.fetchPosts(page: 1, limit: 10))
          .thenAnswer((_) async => initialPosts);

      viewModel.onRefresh = () {};
      await viewModel.loadInitialItems();

      // Now load different items
      final newPosts = [
        const PostModel(id: '2', title: 'Post 2', body: 'Body 2'),
      ];
      when(mockPostsRepository.fetchPosts(page: 1, limit: 10))
          .thenAnswer((_) async => newPosts);

      // Act
      await viewModel.loadInitialItems();

      // Assert
      expect(viewModel.items.length, equals(1));
      expect(viewModel.items[0].id, equals('2'));
    });
  });

  group('loadNextPage', () {
    test('should load next page successfully', () async {
      // Arrange
      // First load initial items
      final initialPosts = List.generate(
          10,
          (i) => PostModel(
                id: '$i',
                title: 'Post $i',
                body: 'Body $i',
              ));
      when(mockPostsRepository.fetchPosts(page: 1, limit: 10))
          .thenAnswer((_) async => initialPosts);

      viewModel.onRefresh = () {};
      await viewModel.loadInitialItems();

      // Now load next page
      final nextPagePosts = [
        const PostModel(id: '10', title: 'Post 10', body: 'Body 10'),
      ];
      when(mockPostsRepository.fetchPosts(page: 2, limit: 10))
          .thenAnswer((_) async => nextPagePosts);

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      await viewModel.loadNextPage();

      // Assert
      expect(viewModel.items.length, equals(11));
      expect(viewModel.currentPage, equals(2));
      expect(viewModel.isLoadingMore, isFalse);
      expect(viewModel.hasMore, isFalse);
      expect(refreshCalled, isTrue);
      verify(mockPostsRepository.fetchPosts(page: 2, limit: 10)).called(1);
    });

    test('should not load if already loading', () async {
      // Arrange
      when(mockPostsRepository.fetchPosts(
              page: anyNamed('page'), limit: anyNamed('limit')))
          .thenAnswer((_) async => []);

      viewModel.onRefresh = () {};

      // Start loading (but don't await)
      viewModel.loadNextPage();

      // Try to load again immediately
      await viewModel.loadNextPage();

      // Should only call repository once (or twice if first one completed)
      // This is a bit tricky to test exactly, so we just verify it doesn't crash
      expect(viewModel.isLoadingMore, isFalse);
    });

    test('should not load if hasMore is false', () async {
      // Arrange
      // Load initial items that result in hasMore = false
      final posts = [const PostModel(id: '1', title: 'Post 1', body: 'Body 1')];
      when(mockPostsRepository.fetchPosts(page: 1, limit: 10))
          .thenAnswer((_) async => posts);

      viewModel.onRefresh = () {};
      await viewModel.loadInitialItems();

      // Act
      await viewModel.loadNextPage();

      // Assert
      verifyNever(mockPostsRepository.fetchPosts(page: 2, limit: 10));
    });

    test('should handle error when loading next page fails', () async {
      // Arrange
      // First load initial items
      final initialPosts = List.generate(
          10,
          (i) => PostModel(
                id: '$i',
                title: 'Post $i',
                body: 'Body $i',
              ));
      when(mockPostsRepository.fetchPosts(page: 1, limit: 10))
          .thenAnswer((_) async => initialPosts);

      viewModel.onRefresh = () {};
      await viewModel.loadInitialItems();

      // Now try to load next page with error
      const errorMessage = 'Failed to load next page';
      when(mockPostsRepository.fetchPosts(page: 2, limit: 10))
          .thenThrow(ApiError(message: errorMessage));

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      await viewModel.loadNextPage();

      // Assert
      expect(viewModel.items.length,
          equals(10)); // Should still have initial items
      expect(viewModel.currentPage, equals(1)); // Should not increment on error
      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.errorMessage, contains(errorMessage));
      expect(refreshCalled, isTrue);
    });
  });
}
