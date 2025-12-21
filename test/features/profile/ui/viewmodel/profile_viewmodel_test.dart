import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_mvvm_samples/features/profile/ui/viewmodel/profile_viewmodel.dart';
import 'package:flutter_mvvm_samples/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter_mvvm_samples/shared/data/models/login_response.dart';
import 'package:flutter_mvvm_samples/core/network/api_error.dart';
import '../../../../helpers/test_helpers.dart' as helpers;

// Generate mocks: flutter pub run build_runner build
@GenerateMocks([ProfileRepository])
import 'profile_viewmodel_test.mocks.dart';

void main() {
  late ProfileViewModel viewModel;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    helpers.setupTestEnvironment();
    mockProfileRepository = MockProfileRepository();
    viewModel = ProfileViewModel(mockProfileRepository);
  });

  tearDown(() {
    // ViewModel doesn't have dispose method, but we'll keep it for consistency
  });

  group('Initialization', () {
    test('should initialize with default values', () {
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.profile, isNull);
      expect(viewModel.hasProfile, isFalse);
      expect(viewModel.errorMessage, isNull);
    });
  });

  group('loadProfile', () {
    test('should load profile successfully from cache', () async {
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

      when(mockProfileRepository.getProfile()).thenAnswer((_) async => profile);

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      await viewModel.loadProfile();

      // Assert
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.profile, equals(profile));
      expect(viewModel.hasProfile, isTrue);
      expect(viewModel.errorMessage, isNull);
      expect(refreshCalled, isTrue);
      verify(mockProfileRepository.getProfile()).called(1);
    });

    test('should handle error when loading profile fails', () async {
      // Arrange
      const errorMessage = 'Failed to load profile';
      when(mockProfileRepository.getProfile())
          .thenThrow(ApiError(message: errorMessage));

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      await viewModel.loadProfile();

      // Assert
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.profile, isNull);
      expect(viewModel.hasProfile, isFalse);
      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.errorMessage, contains(errorMessage));
      expect(refreshCalled, isTrue);
    });

    test('should not load if already loading', () async {
      // Arrange
      when(mockProfileRepository.getProfile())
          .thenAnswer((_) async => LoginResponse(
                id: 1,
                username: 'test',
                email: 'test@example.com',
                firstName: 'Test',
                lastName: 'User',
                gender: 'male',
                image: 'image.jpg',
                accessToken: 'token',
                refreshToken: 'refresh',
              ));

      // Start first load (but don't await to keep it "loading")
      viewModel.loadProfile();

      // Try to load again immediately
      await viewModel.loadProfile();

      // Should only call repository once
      verify(mockProfileRepository.getProfile()).called(1);
    });
  });

  group('refreshProfile', () {
    test('should refresh profile successfully', () async {
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

      when(mockProfileRepository.clearCache()).thenAnswer((_) async => {});
      when(mockProfileRepository.fetchProfile())
          .thenAnswer((_) async => profile);

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      await viewModel.refreshProfile();

      // Assert
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.profile, equals(profile));
      expect(viewModel.hasProfile, isTrue);
      expect(viewModel.errorMessage, isNull);
      expect(refreshCalled, isTrue);
      verify(mockProfileRepository.clearCache()).called(1);
      verify(mockProfileRepository.fetchProfile()).called(1);
    });

    test('should handle error when refreshing profile fails', () async {
      // Arrange
      const errorMessage = 'Failed to refresh profile';
      when(mockProfileRepository.clearCache()).thenAnswer((_) async => {});
      when(mockProfileRepository.fetchProfile())
          .thenThrow(ApiError(message: errorMessage));

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      await viewModel.refreshProfile();

      // Assert
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.errorMessage, contains(errorMessage));
      expect(refreshCalled, isTrue);
    });
  });

  group('clearProfile', () {
    test('should clear profile and error message', () {
      // Arrange - set some state first
      viewModel
          .loadProfile(); // This will set some state (though we don't await)

      var refreshCalled = false;
      viewModel.onRefresh = () {
        refreshCalled = true;
      };

      // Act
      viewModel.clearProfile();

      // Assert
      expect(viewModel.profile, isNull);
      expect(viewModel.errorMessage, isNull);
      expect(viewModel.hasProfile, isFalse);
      expect(refreshCalled, isTrue);
    });
  });
}
