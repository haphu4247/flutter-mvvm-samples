import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_mvvm_samples/shared/data/repositories/auth_repository.dart';
import 'package:flutter_mvvm_samples/shared/data/services/api/auth_service.dart';
import 'package:flutter_mvvm_samples/shared/data/services/local/shared_preferences_service.dart';
import 'package:flutter_mvvm_samples/shared/data/models/login_response.dart';
import 'package:flutter_mvvm_samples/core/network/api_error.dart';
import 'package:flutter_mvvm_samples/core/network/base_api.dart';
import '../../../helpers/test_helpers.dart' as helpers;

// Generate mocks: flutter pub run build_runner build
@GenerateMocks([
  AuthService,
  SharedPreferencesService,
])
import 'auth_repository_test.mocks.dart';

void main() {
  late AuthRepository repository;
  late MockAuthService mockAuthService;
  late MockSharedPreferencesService mockSharedPreferencesService;

  setUp(() {
    helpers.setupTestEnvironment();
    mockAuthService = MockAuthService();
    mockSharedPreferencesService = MockSharedPreferencesService();
    repository = AuthRepository(mockAuthService, mockSharedPreferencesService);
  });

  group('currentAuthStatus', () {
    test('should return logged in status when tokens exist', () async {
      // Arrange
      when(mockSharedPreferencesService.getString(PrefKey.accessToken))
          .thenAnswer((_) async => 'access_token_123');
      when(mockSharedPreferencesService.getString(PrefKey.refreshToken))
          .thenAnswer((_) async => 'refresh_token_123');

      // Act
      final status = await repository.currentAuthStatus;

      // Assert
      expect(status.isLoggedIn, isTrue);
      expect(status.accessToken, equals('access_token_123'));
      expect(status.refreshToken, equals('refresh_token_123'));
    });

    test('should return not logged in status when tokens do not exist',
        () async {
      // Arrange
      when(mockSharedPreferencesService.getString(PrefKey.accessToken))
          .thenAnswer((_) async => null);
      when(mockSharedPreferencesService.getString(PrefKey.refreshToken))
          .thenAnswer((_) async => null);

      // Act
      final status = await repository.currentAuthStatus;

      // Assert
      expect(status.isLoggedIn, isFalse);
      expect(status.accessToken, isNull);
      expect(status.refreshToken, isNull);
    });

    test('should return not logged in when access token is empty', () async {
      // Arrange
      when(mockSharedPreferencesService.getString(PrefKey.accessToken))
          .thenAnswer((_) async => '');
      when(mockSharedPreferencesService.getString(PrefKey.refreshToken))
          .thenAnswer((_) async => 'refresh_token_123');

      // Act
      final status = await repository.currentAuthStatus;

      // Assert
      expect(status.isLoggedIn, isFalse);
    });
  });

  group('login', () {
    test('should login successfully and cache tokens', () async {
      // Arrange
      const username = 'testuser';
      const password = 'testpass';
      final loginResponse = LoginResponse(
        id: 1,
        username: username,
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        gender: 'male',
        image: 'image.jpg',
        accessToken: 'new_access_token',
        refreshToken: 'new_refresh_token',
      );

      when(mockAuthService.login(username: username, password: password))
          .thenAnswer((_) async => ApiResult.success(loginResponse));

      when(mockSharedPreferencesService.setString(any, any))
          .thenAnswer((_) async => true);
      when(mockSharedPreferencesService.setBool(any, any))
          .thenAnswer((_) async => true);

      // Act
      final status =
          await repository.login(username: username, password: password);

      // Assert
      expect(status, isNotNull);
      expect(status?.isLoggedIn, isTrue);
      expect(status?.accessToken, equals('new_access_token'));
      expect(status?.refreshToken, equals('new_refresh_token'));
      expect(status?.user, equals(loginResponse));

      // Verify tokens were cached
      verify(mockSharedPreferencesService.setString(
              PrefKey.accessToken, 'new_access_token'))
          .called(1);
      verify(mockSharedPreferencesService.setString(
              PrefKey.refreshToken, 'new_refresh_token'))
          .called(1);
      verify(mockSharedPreferencesService.setBool(PrefKey.loggedIn, true))
          .called(1);
    });

    test('should throw ApiError when login fails', () async {
      // Arrange
      const username = 'testuser';
      const password = 'wrongpass';
      const errorMessage = 'Invalid credentials';

      when(mockAuthService.login(username: username, password: password))
          .thenAnswer(
              (_) async => ApiResult.failure(ApiError(message: errorMessage)));

      // Act & Assert
      expect(
          () => repository.login(username: username, password: password),
          throwsA(isA<ApiError>()
              .having((e) => e.message, 'message', equals(errorMessage))));
    });
  });

  group('logout', () {
    test('should logout and clear all auth data', () async {
      // Arrange
      when(mockSharedPreferencesService.remove(any))
          .thenAnswer((_) async => true);
      when(mockSharedPreferencesService.setBool(any, any))
          .thenAnswer((_) async => true);

      // Act
      final status = await repository.logout();

      // Assert
      expect(status.isLoggedIn, isFalse);
      expect(status.accessToken, isNull);
      expect(status.refreshToken, isNull);
      expect(status.user, isNull);

      // Verify all auth data was cleared
      verify(mockSharedPreferencesService.remove(PrefKey.accessToken))
          .called(1);
      verify(mockSharedPreferencesService.remove(PrefKey.refreshToken))
          .called(1);
      verify(mockSharedPreferencesService.remove(PrefKey.accessExp)).called(1);
      verify(mockSharedPreferencesService.remove(PrefKey.profileJson))
          .called(1);
      verify(mockSharedPreferencesService.setBool(PrefKey.loggedIn, false))
          .called(1);
    });
  });

  group('isLoggedIn', () {
    test('should return true when user is logged in', () async {
      // Arrange
      when(mockSharedPreferencesService.getString(PrefKey.accessToken))
          .thenAnswer((_) async => 'access_token');
      when(mockSharedPreferencesService.getString(PrefKey.refreshToken))
          .thenAnswer((_) async => 'refresh_token');

      // Act
      final isLoggedIn = await repository.isLoggedIn();

      // Assert
      expect(isLoggedIn, isTrue);
    });

    test('should return false when user is not logged in', () async {
      // Arrange
      when(mockSharedPreferencesService.getString(PrefKey.accessToken))
          .thenAnswer((_) async => null);
      when(mockSharedPreferencesService.getString(PrefKey.refreshToken))
          .thenAnswer((_) async => null);

      // Act
      final isLoggedIn = await repository.isLoggedIn();

      // Assert
      expect(isLoggedIn, isFalse);
    });
  });
}
