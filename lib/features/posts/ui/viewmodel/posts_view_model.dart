import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/features/posts/data/repositories/posts_repository.dart';
import 'package:flutter_mvvm_samples/shared/data/models/product_model.dart';
import 'package:flutter_mvvm_samples/mvvm/viewmodel/base_viewmodel.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// ViewModel for posts screen
class PostsViewModel extends BaseViewModel {
  PostsViewModel(this._postsRepository);

  final PostsRepository _postsRepository;

  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  @override
  void onInit({required BuildContext context}) {
    loadInitialItems();
  }

  @override
  void onDispose() {
    refreshController.dispose();
    super.onDispose();
  }

  // UI State
  final List<PostModel> _items = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;

  List<PostModel> get items => _items;
  int get currentPage => _currentPage;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  final int itemsPerPage = 10;

  /// Command: Load initial items
  Future<void> loadInitialItems() async {
    if (_isLoadingMore) return;

    _isLoadingMore = true;
    _currentPage = 1;
    _errorMessage = null;
    refreshUI();

    try {
      final data = await _postsRepository.fetchPosts(
        page: _currentPage,
        limit: itemsPerPage,
      );

      _items.clear();
      _items.addAll(data);
      _hasMore = data.length == itemsPerPage;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingMore = false;
      refreshUI();
    }
  }

  /// Command: Load next page
  Future<void> loadNextPage() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    _errorMessage = null;
    refreshUI();

    try {
      final nextPage = _currentPage + 1;
      final data = await _postsRepository.fetchPosts(
        page: nextPage,
        limit: itemsPerPage,
      );

      _items.addAll(data);
      _currentPage = nextPage;
      _hasMore = data.length == itemsPerPage;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingMore = false;
      refreshUI();
    }
  }
}
