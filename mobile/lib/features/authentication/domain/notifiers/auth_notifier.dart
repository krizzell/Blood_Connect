import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:blood_connect/features/authentication/data/data_export.dart';
import 'package:blood_connect/core/storage/secure_storage_provider.dart';
import '../entities/auth_state.dart';

/// Auth Notifier untuk manage authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorage;

  AuthNotifier(this._authRepository, this._secureStorage)
      : super(const AuthState.initial());

  /// Login user dengan email dan password
  Future<void> login(String email, String password) async {
    state = const AuthState.loading();

    try {
      final loginRequest = LoginRequest(
        email: email,
        password: password,
      );

      final loginResponse = await _authRepository.login(loginRequest);

      // Save token to secure storage
      await _secureStorage.saveToken(loginResponse.accessToken);

      // Update state to authenticated
      state = AuthState.authenticated(
        user: loginResponse.userData,
        accessToken: loginResponse.accessToken,
      );
    } on DioException catch (e) {
      state = AuthState.error(
        message: _handleDioError(e),
      );
    } catch (e) {
      state = AuthState.error(
        message: e.toString(),
      );
    }
  }

  /// Register user dengan data baru
  /// Set state ke registrationSuccess setelah register berhasil (redirect ke login screen)
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String gender,
    required String birthDate,
    required String bloodType,
    required String rhesus,
    required int weight,
    required String? lastDonorDate,
    required double latitude,
    required double longitude,
  }) async {
    state = const AuthState.loading();
    print('[AuthNotifier] Register: loading state set');

    try {
      final registerRequest = RegisterRequest(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
        gender: gender,
        birthDate: birthDate,
        bloodType: bloodType,
        rhesus: rhesus,
        weight: weight,
        lastDonorDate: lastDonorDate,
        latitude: latitude,
        longitude: longitude,
        profilePhoto: null,
      );

      await _authRepository.register(registerRequest);
      print('[AuthNotifier] Register: API success, setting registrationSuccess');

      // After successful registration, set state to registrationSuccess
      // This will trigger redirect to login screen
      state = const AuthState.registrationSuccess();
      print('[AuthNotifier] Register: registrationSuccess state set: $state');
    } on DioException catch (e) {
      print('[AuthNotifier] Register: DioException - ${_handleDioError(e)}');
      state = AuthState.error(
        message: _handleDioError(e),
      );
    } catch (e) {
      print('[AuthNotifier] Register: Exception - $e');
      state = AuthState.error(
        message: e.toString(),
      );
    }
  }

  /// Logout user dan hapus token dari storage
  Future<void> logout() async {
    try {
      await _secureStorage.removeToken();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(message: 'Logout failed: ${e.toString()}');
    }
  }

  /// Check if user is already authenticated (dari token di storage)
  Future<void> checkAuthStatus() async {
    try {
      final token = await _secureStorage.getToken();
      if (token != null && token.isNotEmpty) {
        // Token exists, user is authenticated
        // In a real app, you might want to validate the token or fetch user data
        state = AuthState.authenticated(
          user: UserModel(
            id: '',
            fullName: '',
            email: '',
          ),
          accessToken: token,
        );
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  /// Reset state ke unauthenticated
  void resetState() {
    state = const AuthState.unauthenticated();
  }

  /// Handle DioException dan return user-friendly error message
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? 'An error occurred';
        if (statusCode == 401) {
          return 'Invalid email or password';
        } else if (statusCode == 409) {
          return 'Email or phone already registered';
        } else if (statusCode == 422) {
          return message;
        }
        return message;
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.unknown:
        return 'An unexpected error occurred. Please try again.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}

/// Riverpod state notifier provider for AuthNotifier
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return AuthNotifier(authRepository, secureStorage);
});

/// Riverpod provider untuk access token
final accessTokenProvider = FutureProvider<String?>((ref) async {
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return secureStorage.getToken();
});

/// Riverpod provider untuk check apakah user authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.when(
    authenticated: (_, __) => true,
    initial: () => false,
    loading: () => false,
    unauthenticated: () => false,
    registrationSuccess: () => false,
    error: (_) => false,
  );
});
