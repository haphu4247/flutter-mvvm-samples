import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/mvvm/view/base_view.dart';
import 'package:flutter_mvvm_samples/core/translations/generated/app_localizations.dart';
import 'package:flutter_mvvm_samples/features/posts/ui/viewmodel/posts_view_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// Posts View - UI Layer
/// Responsibilities: Render posts list, handle pull-to-refresh, pagination
class PostsView extends BaseView<PostsViewModel> {
  const PostsView({super.key, required super.vm});

  void _stateRefresh(bool isLoadingMore, bool hasMore) {
    if (isLoadingMore) {
      return;
    }
    if (hasMore) {
      vm.refreshController.loadComplete();
    } else {
      vm.refreshController.loadNoData();
    }
  }

  void _onRefresh(PostsViewModel viewModel) async {
    await viewModel.loadInitialItems();
    vm.refreshController.refreshCompleted();
  }

  void _onLoading(PostsViewModel viewModel) async {
    await viewModel.loadNextPage();
    _stateRefresh(viewModel.isLoadingMore, viewModel.hasMore);
  }

  @override
  Widget buildView(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text(loc.postsPullUpLoad);
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text(loc.postsLoadFailed);
            } else if (mode == LoadStatus.canLoading) {
              body = Text(loc.postsReleaseToLoad);
            } else {
              body = Text(loc.postsNoMoreData);
            }
            return SizedBox(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: vm.refreshController,
        onRefresh: () => _onRefresh(vm),
        onLoading: () => _onLoading(vm),
        child: ListView.builder(
          itemCount: vm.items.length,
          itemBuilder: (context, index) {
            final post = vm.items[index];
            return ListTile(
              title: Text(loc.postsId(
                  int.tryParse(post.id ?? '0') ?? 0, post.title ?? '')),
              subtitle: Text('${post.body}'),
            );
          },
        ),
      ),
    );
  }
}
