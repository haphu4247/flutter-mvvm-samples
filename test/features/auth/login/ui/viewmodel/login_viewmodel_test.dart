import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_mvvm_samples/features/auth/login/ui/viewmodel/login_viewmodel.dart';
import 'package:flutter_mvvm_samples/shared/data/repositories/auth_repository.dart';
import 'package:flutter_mvvm_samples/shared/data/models/login_response.dart';
import 'package:flutter_mvvm_samples/core/network/api_error.dart';
import '../../../../../helpers/test_helpers.dart' as helpers;

// Generate mocks: flutter pub run build_runner build
@GenerateMocks([AuthRepository])
import 'login_viewmodel_test.mocks.dart';

void main() {
  late LoginViewModel viewModel;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    helpers.setupTestEnvironment();
    mockAuthRepository = MockAuthRepository();
    viewModel = LoginViewModel(mockAuthRepository);
  });

  tearDown(() {});

  group('Initialization', () {
    test('should initialize with default values', () {
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.isLoggedIn, isFalse);
      expect(viewModel.user, isNull);
    });

    test('should initialize controllers with default values', () {
      expect(viewModel.usernameController.text, equals('emilys'));
      expect(viewModel.passwordController.text, equals('emilyspass'));
    });
  });

  group('initialize', () {
    test('should load current auth status successfully', () async {
      // Arrange
      final authStatus = AuthStatus(
        isLoggedIn: true,
        accessToken: 'token',
        refreshToken: 'refresh',
        user: LoginResponse(
          id: 1,
          username: 'emilys',
          email: 'emily@example.com',
          firstName: 'Emily',
          lastName: 'User',
          gender: 'female',
          image: 'image.jpg',
          accessToken: 'token',
          refreshToken: 'refresh',
        ),
      );

      when(mockAuthRepository.currentAuthStatus)
          .thenAnswer((_) async => authStatus);

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      await viewModel.initialize();

      // Assert
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.isLoggedIn, isTrue);
      expect(viewModel.user, isNotNull);
      expect(refreshCalled, isTrue);
      verify(mockAuthRepository.currentAuthStatus).called(1);
    });

    test('should handle error when loading auth status fails', () async {
      // Arrange
      when(mockAuthRepository.currentAuthStatus)
          .thenThrow(Exception('Failed to load'));

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      await viewModel.initialize();

      // Assert
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.errorMessage, contains('Failed to load'));
      expect(refreshCalled, isTrue);
    });
  });

  group('login', () {
    test('should login successfully', () async {
      // Arrange
      const username = 'testuser';
      const password = 'testpass';
      final authStatus = AuthStatus(
        isLoggedIn: true,
        accessToken: 'token',
        refreshToken: 'refresh',
        user: LoginResponse(
          id: 1,
          username: username,
          email: 'test@example.com',
          firstName: 'Test',
          lastName: 'User',
          gender: 'male',
          image: 'image.jpg',
          accessToken: 'token',
          refreshToken: 'refresh',
        ),
      );

      when(mockAuthRepository.login(username: username, password: password))
          .thenAnswer((_) async => authStatus);

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      await viewModel.login(username: username, password: password);

      // Assert
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.isLoggedIn, isTrue);
      expect(refreshCalled, isTrue);
      verify(mockAuthRepository.login(username: username, password: password))
          .called(1);
    });

    test('should handle login error', () async {
      // Arrange
      const username = 'wronguser';
      const password = 'wrongpass';
      const errorMessage = 'Invalid credentials';

      when(mockAuthRepository.login(username: username, password: password))
          .thenThrow(ApiError(message: errorMessage));

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      await viewModel.login(username: username, password: password);

      // Assert
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.errorMessage, contains(errorMessage));
      expect(refreshCalled, isTrue);
    });
  });

  group('logout', () {
    test('should logout successfully', () async {
      // Arrange
      final authStatus = const AuthStatus(
        isLoggedIn: false,
        accessToken: null,
        refreshToken: null,
        user: null,
      );

      when(mockAuthRepository.logout()).thenAnswer((_) async => authStatus);

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      await viewModel.logout();

      // Assert
      expect(viewModel.isLoading, isFalse);
      expect(refreshCalled, isTrue);
      verify(mockAuthRepository.logout()).called(1);
    });

    test('should handle logout error', () async {
      // Arrange
      when(mockAuthRepository.logout()).thenThrow(Exception('Logout failed'));

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      await viewModel.logout();

      // Assert
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNotNull);
      expect(refreshCalled, isTrue);
    });
  });

  group('clearError', () {
    test('should clear error message', () async {
      // Arrange
      await viewModel.initialize();

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      viewModel.clearError();

      // Assert
      expect(viewModel.errorMessage, isNull);
      expect(refreshCalled, isTrue);
    });
  });
}
