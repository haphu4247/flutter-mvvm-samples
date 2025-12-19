import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mvvm_samples/core/utils/log/app_logger.dart';

class NetworkNotifier extends ChangeNotifier {
  NetworkNotifier() : super() {
    _init();
  }

  bool _state = true;
  bool get state => _state;

  late final Connectivity _connectivity;
  late final StreamSubscription _subscription;

  Future<void> _init() async {
    _connectivity = Connectivity();

    // Check initial connectivity
    try {
      final result = await _connectivity.checkConnectivity();
      _updateState(result.first);
    } catch (e) {
      AppLogger.instance.warning('Error checking initial connectivity',
          tag: 'NetworkProvider', error: e);
    }

    // Listen to connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _updateState(result.first);
    });
  }

  void _updateState(ConnectivityResult result) {
    final bool isConnected = result != ConnectivityResult.none;
    if (_state != isConnected) {
      _state = isConnected;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
