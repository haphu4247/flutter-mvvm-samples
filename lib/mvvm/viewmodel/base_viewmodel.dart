import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

abstract class BaseViewModel {
  const BaseViewModel();

  void onInit(
      {required void Function() onRefresh, required BuildContext context}) {}

  /// Dispose automatically when the view is disposed
  void onDispose() {}

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
