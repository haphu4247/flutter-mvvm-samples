import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/features/home/ui/viewmodel/home_viewmodel.dart';
import 'package:flutter_mvvm_samples/features/posts/data/repositories/posts_repository.dart';
import 'package:flutter_mvvm_samples/features/posts/ui/viewmodel/posts_view_model.dart';
import 'package:flutter_mvvm_samples/core/translations/generated/app_localizations.dart';
import 'package:flutter_mvvm_samples/features/posts/ui/view/posts_view.dart';
import 'package:flutter_mvvm_samples/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter_mvvm_samples/features/profile/ui/viewmodel/profile_viewmodel.dart';
import 'package:flutter_mvvm_samples/features/profile/ui/view/profile_icon_view.dart';
import 'package:flutter_mvvm_samples/mvvm/view/base_view.dart';
import 'package:provider/provider.dart';

/// Home View - UI Layer
/// Responsibilities: Render tabs and bottom navigation
class HomeView extends BaseView<HomeViewModel> {
  const HomeView({super.key, required super.vm});

  @override
  Widget buildView(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final tabs = <Widget>[
      PostsView(vm: PostsViewModel(context.read<PostsRepository>())),
      Center(child: Text(loc.tab2)),
      Center(child: Text(loc.tab3)),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.homeTitle),
        actions: [
          ProfileIconView(
              vm: ProfileViewModel(context.read<ProfileRepository>())),
        ],
      ),
      body: tabs[vm.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: vm.currentIndex,
        onTap: (i) => vm.setCurrentIndex(i),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: loc.tabHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: loc.tabSearch,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: loc.tabSettings,
          ),
        ],
      ),
    );
  }
}
