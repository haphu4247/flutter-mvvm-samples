import 'package:flutter/foundation.dart' show DiagnosticsTreeStyle;
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_samples/core/env/env.dart';
import 'package:flutter_mvvm_samples/core/utils/log/app_logger.dart';

/// Initialize test environment
void setupTestEnvironment() {
  // Initialize logger for tests
  AppLogger.init(Env.dev);
}

/// Create a mock BuildContext for testing
BuildContext createMockContext() {
  return MockBuildContext();
}

/// Mock BuildContext implementation
class MockBuildContext implements BuildContext {
  @override
  InheritedWidget dependOnInheritedElement(
    InheritedElement ancestor, {
    Object? aspect,
  }) =>
      throw UnimplementedError();

  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>({
    Object? aspect,
  }) =>
      null;

  @override
  DiagnosticsNode describeElement(
    String name, {
    DiagnosticsTreeStyle style = DiagnosticsTreeStyle.errorProperty,
  }) =>
      DiagnosticsNode.message('MockBuildContext');

  @override
  List<DiagnosticsNode> describeMissingAncestor({
    required Type expectedAncestorType,
  }) =>
      [];

  @override
  DiagnosticsNode describeOwnershipChain(String name) =>
      DiagnosticsNode.message('MockBuildContext');

  @override
  DiagnosticsNode describeWidget(
    String name, {
    DiagnosticsTreeStyle style = DiagnosticsTreeStyle.errorProperty,
  }) =>
      DiagnosticsNode.message('MockBuildContext');

  @override
  void dispatchNotification(Notification notification) {}

  @override
  T? findAncestorRenderObjectOfType<T extends RenderObject>() => null;

  @override
  T? findAncestorStateOfType<T extends State<StatefulWidget>>() => null;

  @override
  T? findAncestorWidgetOfExactType<T extends Widget>() => null;

  @override
  RenderObject? findRenderObject() => null;

  @override
  T? findRootAncestorStateOfType<T extends State<StatefulWidget>>() => null;

  @override
  InheritedElement?
      getElementForInheritedWidgetOfExactType<T extends InheritedWidget>() =>
          null;

  @override
  BuildOwner? get owner => null;

  @override
  Size? get size => null;

  @override
  void visitAncestorElements(bool Function(Element element) visitor) {}

  @override
  void visitChildElements(ElementVisitor visitor) {}

  @override
  Widget get widget => const SizedBox();

  @override
  bool get debugDoingBuild => false;

  @override
  T? getInheritedWidgetOfExactType<T extends InheritedWidget>() {
    return null;
  }

  bool get mounted => false;
}

/// Helper function to create a test widget with MaterialApp
Widget createTestWidget(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: child,
    ),
  );
}
