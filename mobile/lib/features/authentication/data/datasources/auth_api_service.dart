import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_connect/core/network/dio_client.dart';
import 'package:blood_connect/core/constants/app_constants.dart';
import '../models/models_export.dart';

/// Auth API Service untuk handle authentication-related API calls
class AuthApiService {
  final Dio _dio;

  AuthApiService(this._dio);

  /// Login endpoint: POST /api/v1/auth/login
  /// Returns [LoginResponse] containing access token and user data
  /// Throws [DioException] if login fails
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '${AppConstants.apiBaseUrl}/auth/login',
        data: request.toJson(),
      );

      // Handle success response (200)
      if (response.statusCode == 200 && response.data['success'] == true) {
        return LoginResponse.fromJson(response.data['data']);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: response.data['message'] ?? 'Login failed',
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        error: e.toString(),
      );
    }
  }

  /// Register endpoint: POST /api/v1/auth/register
  /// Returns [RegisterResponse] containing user id, name, and email
  /// Throws [DioException] if registration fails
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '${AppConstants.apiBaseUrl}/auth/register',
        data: request.toJson(),
      );

      print('[AuthApiService] Register response: status=${response.statusCode}, data=${response.data}');

      // Handle success response (201)
      if ((response.statusCode == 201 || response.statusCode == 200) &&
          response.data['success'] == true) {
        print('[AuthApiService] Parsing RegisterResponse from: ${response.data['data']}');
        final registerResponse = RegisterResponse.fromJson(response.data['data']);
        print('[AuthApiService] RegisterResponse parsed: $registerResponse');
        return registerResponse;
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: response.data['message'] ?? 'Registration failed',
      );
    } on DioException catch (e) {
      print('[AuthApiService] DioException: ${e.message}');
      rethrow;
    } catch (e) {
      print('[AuthApiService] Register error: $e');
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        error: e.toString(),
      );
    }
  }
  /// Profile endpoint: GET /api/v1/auth/profile
  /// Returns [ProfileModel] containing user profile data
  /// Throws [DioException] if fetch fails
  Future<ProfileModel> getProfile() async {
    try {
      final response = await _dio.get('${AppConstants.apiBaseUrl}/auth/profile');

      if (response.statusCode == 200 && response.data['data'] != null) {
        return ProfileModel.fromJson(response.data['data']);
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: response.data['message'] ?? 'Failed to fetch profile',
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        error: e.toString(),
      );
    }
  }
}

/// Riverpod provider for AuthApiService
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthApiService(dio);
});
