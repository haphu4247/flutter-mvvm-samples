import 'package:flutter_mvvm_samples/mvvm/viewmodel/base_viewmodel.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel();

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    refreshUI();
  }
}
