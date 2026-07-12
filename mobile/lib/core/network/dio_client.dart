import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:blood_connect/core/constants/app_constants.dart';
import 'jwt_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: AppConstants.apiTimeoutDuration,
      receiveTimeout: AppConstants.apiTimeoutDuration,
      contentType: 'application/json',
    ),
  );

  // Add JWT Interceptor
  dio.interceptors.add(JwtInterceptor(ref));

  // Add Logger Interceptor (for debug)
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: false,
    ),
  );

  return dio;
});
