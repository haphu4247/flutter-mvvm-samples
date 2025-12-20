import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dart:convert';
import 'package:flutter_mvvm_samples/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter_mvvm_samples/shared/data/services/api/user_service.dart';
import 'package:flutter_mvvm_samples/shared/data/services/local/shared_preferences_service.dart';
import 'package:flutter_mvvm_samples/shared/data/models/login_response.dart';
import 'package:flutter_mvvm_samples/core/network/api_error.dart';
import 'package:flutter_mvvm_samples/core/network/base_api.dart';
import '../../../../helpers/test_helpers.dart' as helpers;

// Generate mocks: flutter pub run build_runner build
@GenerateMocks([UserService, SharedPreferencesService])
import 'profile_repository_test.mocks.dart';

void main() {
  late ProfileRepository repository;
  late MockUserService mockUserService;
  late MockSharedPreferencesService mockSharedPreferencesService;

  setUp(() {
    helpers.setupTestEnvironment();
    mockUserService = MockUserService();
    mockSharedPreferencesService = MockSharedPreferencesService();
    repository =
        ProfileRepository(mockUserService, mockSharedPreferencesService);
  });

  group('getCachedProfile', () {
    test('should return cached profile when available', () async {
      // Arrange
      final profile = LoginResponse(
        id: 1,
        username: 'testuser',
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        gender: 'male',
        image: 'image.jpg',
        accessToken: 'token',
        refreshToken: 'refresh',
      );

      final cachedJson = json.encode(profile.toJson());
      when(mockSharedPreferencesService.getString(PrefKey.profileJson))
          .thenAnswer((_) async => cachedJson);

      // Act
      final result = await repository.getCachedProfile();

      // Assert
      expect(result, isNotNull);
      expect(result?.id, equals(1));
      expect(result?.username, equals('testuser'));
      verify(mockSharedPreferencesService.getString(PrefKey.profileJson))
          .called(1);
    });

    test('should return null when cache is empty', () async {
      // Arrange
      when(mockSharedPreferencesService.getString(PrefKey.profileJson))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getCachedProfile();

      // Assert
      expect(result, isNull);
    });

    test('should return null when cache is corrupted', () async {
      // Arrange
      when(mockSharedPreferencesService.getString(PrefKey.profileJson))
          .thenAnswer((_) async => 'invalid json');

      // Act
      final result = await repository.getCachedProfile();

      // Assert
      expect(result, isNull);
    });
  });

  group('fetchProfile', () {
    test('should fetch profile from API and cache it', () async {
      // Arrange
      final profile = LoginResponse(
        id: 1,
        username: 'testuser',
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        gender: 'male',
        image: 'image.jpg',
        accessToken: 'token',
        refreshToken: 'refresh',
      );

      when(mockUserService.getProfile())
          .thenAnswer((_) async => ApiResult.success(profile));
      when(mockSharedPreferencesService.setString(any, any))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.fetchProfile();

      // Assert
      expect(result, equals(profile));
      verify(mockUserService.getProfile()).called(1);
      verify(mockSharedPreferencesService.setString(PrefKey.profileJson, any))
          .called(1);
    });

    test('should throw ApiError when fetch fails', () async {
      // Arrange
      const errorMessage = 'Network error';
      when(mockUserService.getProfile()).thenAnswer(
          (_) async => ApiResult.failure(ApiError(message: errorMessage)));

      // Act & Assert
      expect(
          () => repository.fetchProfile(),
          throwsA(isA<ApiError>()
              .having((e) => e.message, 'message', equals(errorMessage))));
    });

    test('should throw ApiError when profile data is null', () {
      // Arrange
      when(mockUserService.getProfile())
          .thenAnswer((_) async => ApiResult.failure(ApiError()));

      // Act & Assert
      expect(() => repository.fetchProfile(),
          throwsA(isA<ApiError>().having((e) => e.message, 'message', isNull)));
    });
  });

  group('cacheProfile', () {
    test('should cache profile successfully', () async {
      // Arrange
      final profile = LoginResponse(
        id: 1,
        username: 'testuser',
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        gender: 'male',
        image: 'image.jpg',
        accessToken: 'token',
        refreshToken: 'refresh',
      );

      when(mockSharedPreferencesService.setString(any, any))
          .thenAnswer((_) async => true);

      // Act
      await repository.cacheProfile(profile);

      // Assert
      final expectedJson = json.encode(profile.toJson());
      verify(mockSharedPreferencesService.setString(
              PrefKey.profileJson, expectedJson))
          .called(1);
    });

    test('should not throw when caching fails', () async {
      // Arrange
      final profile = LoginResponse(
        id: 1,
        username: 'testuser',
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        gender: 'male',
        image: 'image.jpg',
        accessToken: 'token',
        refreshToken: 'refresh',
      );

      when(mockSharedPreferencesService.setString(any, any))
          .thenThrow(Exception('Storage error'));

      // Act & Assert - should not throw
      expect(() => repository.cacheProfile(profile), returnsNormally);
    });
  });

  group('clearCache', () {
    test('should clear cached profile', () async {
      // Arrange
      when(mockSharedPreferencesService.remove(any))
          .thenAnswer((_) async => true);

      // Act
      await repository.clearCache();

      // Assert
      verify(mockSharedPreferencesService.remove(PrefKey.profileJson))
          .called(1);
    });
  });

  group('getProfile', () {
    test('should return cached profile if available', () async {
      // Arrange
      final cachedProfile = LoginResponse(
        id: 1,
        username: 'testuser',
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        gender: 'male',
        image: 'image.jpg',
        accessToken: 'token',
        refreshToken: 'refresh',
      );

      when(mockSharedPreferencesService.getString(PrefKey.profileJson))
          .thenAnswer((_) async => json.encode(cachedProfile.toJson()));

      // Act
      final result = await repository.getProfile();

      // Assert
      expect(result.accessToken, equals(cachedProfile.accessToken));
      verify(mockSharedPreferencesService.getString(PrefKey.profileJson))
          .called(1);
      verifyNever(mockUserService.getProfile());
    });

    test('should fetch from API when cache is not available', () async {
      // Arrange
      final profile = LoginResponse(
        id: 1,
        username: 'testuser',
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User',
        gender: 'male',
        image: 'image.jpg',
        accessToken: 'token',
        refreshToken: 'refresh',
      );

      when(mockSharedPreferencesService.getString(PrefKey.profileJson))
          .thenAnswer((_) async => null);
      when(mockUserService.getProfile())
          .thenAnswer((_) async => ApiResult.success(profile));
      when(mockSharedPreferencesService.setString(any, any))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.getProfile();

      // Assert
      expect(result, equals(profile));
      verify(mockSharedPreferencesService.getString(PrefKey.profileJson))
          .called(1);
      verify(mockUserService.getProfile()).called(1);
    });
  });
}
