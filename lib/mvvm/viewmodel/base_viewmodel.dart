import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

abstract class BaseViewModel {
  BaseViewModel() : _refreshUIController = StreamController<String>.broadcast();

  // Event stream for listeners
  final StreamController<String> _refreshUIController;

  void onInit({required BuildContext context}) {}

  /// Dispose automatically when the view is disposed
  void onDispose() {}

  /// Stream of events that Views can listen to
  Stream<String> get refreshEvents => _refreshUIController.stream;

  /// Emit an event to listeners
  ///
  /// Example:

  /// ```
  void emitEvent(String event) {
    if (!_refreshUIController.isClosed) {
      _refreshUIController.add(event);
    }
  }

  void refreshUI() {
    emitEvent("refreshUI");
  }

  void showLoading() {
    if (SmartDialog.checkExist(dialogTypes: {SmartAllDialogType.loading})) {
      return;
    }
    SmartDialog.showLoading();
  }

  void hideLoading() {
    if (SmartDialog.checkExist(dialogTypes: {SmartAllDialogType.loading})) {
      SmartDialog.dismiss(status: SmartStatus.loading);
    }
  }

  void showError(String message) {
    SmartDialog.showToast(message);
  }

  void showDefaultDialog(String message, {required String icon}) {
    showCustomDialog(
      (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/$icon'),
              // const Icon(Icons.error, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(
                message,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => SmartDialog.dismiss(),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showCustomDialog(WidgetBuilder builder) {
    SmartDialog.show(
      builder: builder,
    );
  }

  Future<void> dismissDialog() {
    return SmartDialog.dismiss();
  }
}
