import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mvvm_samples/features/home/ui/viewmodel/home_viewmodel.dart';
import '../../../../helpers/test_helpers.dart' as helpers;

void main() {
  late HomeViewModel viewModel;

  setUp(() {
    helpers.setupTestEnvironment();
    viewModel = HomeViewModel();
  });

  group('Initialization', () {
    test('should initialize with default values', () {
      expect(viewModel.currentIndex, equals(0));
    });
  });

  group('setCurrentIndex', () {
    test('should update current index', () {
      // Arrange
      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      viewModel.setCurrentIndex(2);

      // Assert
      expect(viewModel.currentIndex, equals(2));
      expect(refreshCalled, isTrue);
    });

    test('should update current index multiple times', () {
      // Arrange
      viewModel.onRefresh = () {};

      // Act
      viewModel.setCurrentIndex(1);
      expect(viewModel.currentIndex, equals(1));

      viewModel.setCurrentIndex(3);
      expect(viewModel.currentIndex, equals(3));

      viewModel.setCurrentIndex(0);
      expect(viewModel.currentIndex, equals(0));
    });

    test('should call onRefresh when index changes', () {
      // Arrange
      var refreshCallCount = 0;
      viewModel.onRefresh = () {
        refreshCallCount++;
      };

      // Act
      viewModel.setCurrentIndex(1);
      viewModel.setCurrentIndex(2);
      viewModel.setCurrentIndex(3);

      // Assert
      expect(refreshCallCount, equals(3));
    });
  });

  group('onInit', () {
    test('should set onRefresh callback', () {
      // Arrange
      var refreshCalled = false;
      void refreshCallback() {
        refreshCalled = true;
      }

      // Act
      viewModel.onInit(
        onRefresh: refreshCallback,
        context: helpers.createMockContext(),
      );

      // Assert
      expect(viewModel.onRefresh, isNotNull);
      viewModel.onRefresh?.call();
      expect(refreshCalled, isTrue);
    });
  });
}
