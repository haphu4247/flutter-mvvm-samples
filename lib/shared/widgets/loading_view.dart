import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/shared/widgets/lottie_view.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    super.key,
    this.name = 'anim_loading',
  });

  factory LoadingView.search() => const LoadingView(name: 'anim_search');

  final String name;

  @override
  Widget build(BuildContext context) {
    return Center(child: LottieView(name: name));
  }
}
