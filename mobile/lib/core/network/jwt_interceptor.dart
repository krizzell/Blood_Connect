import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_connect/core/storage/secure_storage_provider.dart';
import 'package:blood_connect/features/authentication/domain/domain_export.dart';

class JwtInterceptor extends Interceptor {
  final Ref _ref;

  JwtInterceptor(this._ref);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final secureStorage = _ref.read(secureStorageServiceProvider);
    final token = await secureStorage.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token expired or invalid, logout user
      await _ref.read(authNotifierProvider.notifier).logout();
    }

    return handler.next(err);
  }
}
