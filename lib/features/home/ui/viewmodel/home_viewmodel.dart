import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/mvvm/viewmodel/base_viewmodel.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel();
  void Function()? onRefresh;
  @override
  void onInit(
      {required void Function() onRefresh, required BuildContext context}) {
    this.onRefresh = onRefresh;
  }

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    onRefresh?.call();
  }
}
