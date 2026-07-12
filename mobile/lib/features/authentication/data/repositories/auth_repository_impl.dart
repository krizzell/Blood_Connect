import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_connect/features/authentication/data/datasources/auth_api_service.dart';
import '../models/models_export.dart';

/// Contract for authentication repository
abstract class AuthRepository {
  Future<LoginResponse> login(LoginRequest request);
  Future<RegisterResponse> register(RegisterRequest request);
  Future<ProfileModel> getProfile();
}

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    return await _apiService.login(request);
  }

  @override
  Future<RegisterResponse> register(RegisterRequest request) async {
    return await _apiService.register(request);
  }

  @override
  Future<ProfileModel> getProfile() async {
    return await _apiService.getProfile();
  }
}

/// Riverpod provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(authApiServiceProvider);
  return AuthRepositoryImpl(apiService);
});
