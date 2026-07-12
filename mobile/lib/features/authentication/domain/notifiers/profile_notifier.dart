import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:blood_connect/features/authentication/data/data_export.dart';
import 'package:blood_connect/features/authentication/domain/domain_export.dart';

/// Profile Notifier untuk mengambil dan menyimpan state profil user
class ProfileNotifier extends StateNotifier<AsyncValue<ProfileModel?>> {
  final AuthRepository _authRepository;

  ProfileNotifier(this._authRepository) : super(const AsyncValue.loading()) {
    fetchProfile();
  }

  /// Ambil data profil dari backend
  Future<void> fetchProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _authRepository.getProfile();
      state = AsyncValue.data(profile);
    } on DioException catch (e) {
      final errorMessage = _handleDioError(e);
      state = AsyncValue.error(errorMessage, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  /// Refresh profil (tanpa mengulang loading state sepenuhnya jika sudah ada data)
  Future<void> refreshProfile() async {
    try {
      final profile = await _authRepository.getProfile();
      state = AsyncValue.data(profile);
    } catch (e) {
      // Biarkan state lama jika error saat refresh
      print('Failed to refresh profile: $e');
    }
  }

  /// Handle DioException dan return user-friendly error message
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Timeout. Please try again.';
      case DioExceptionType.badResponse:
        final message = e.response?.data?['message'] ?? 'An error occurred';
        if (e.response?.statusCode == 401) {
          return 'Unauthorized. Please login again.';
        }
        return message;
      default:
        return 'An error occurred: ${e.message}';
    }
  }
}

/// Riverpod provider untuk ProfileNotifier
final profileNotifierProvider = StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileModel?>>((ref) {
  // Hanya fetch profile jika user authenticated
  final authState = ref.watch(authNotifierProvider);
  final repository = ref.watch(authRepositoryProvider);
  
  final notifier = ProfileNotifier(repository);
  
  // Jika user logout (unauthenticated), kosongkan profile
  authState.maybeWhen(
    unauthenticated: () {
      notifier.state = const AsyncValue.data(null);
    },
    orElse: () {},
  );
  
  return notifier;
});
