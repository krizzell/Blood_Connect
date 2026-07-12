import 'package:dio/dio.dart';
import 'package:blood_connect/core/constants/app_constants.dart';
import 'package:blood_connect/features/blood_request/data/models/models_export.dart';

/// Service untuk API calls blood request
/// Handle semua komunikasi dengan backend untuk blood request endpoints
class BloodRequestApiService {
  final Dio _dio;

  BloodRequestApiService(this._dio);

  /// POST /api/v1/blood-requests
  /// Membuat blood request baru
  Future<BloodRequestResponse> createBloodRequest(
    BloodRequestRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '${AppConstants.apiBaseUrl}/blood-requests',
        data: request.toJson(),
      );

      // Response dari backend: { success: true, message: "...", data: {...} }
      if (response.statusCode == 201 && response.data['data'] != null) {
        return BloodRequestResponse.fromJson(response.data['data']);
      }

      throw Exception('Failed to create blood request');
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// GET /api/v1/blood-requests/my
  /// Mengambil semua blood request milik user yang login
  Future<List<BloodRequestListResponse>> getMyBloodRequests() async {
    try {
      final response = await _dio.get(
        '${AppConstants.apiBaseUrl}/blood-requests/my',
      );

      // Response dari backend: { success: true, message: "...", data: [...] }
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        return data
            .map((item) => BloodRequestListResponse.fromJson(item))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// GET /api/v1/blood-requests/:id
  /// Mengambil detail blood request berdasarkan ID
  Future<BloodRequestDetailResponse> getBloodRequestDetail(
    String requestId,
  ) async {
    try {
      final response = await _dio.get(
        '${AppConstants.apiBaseUrl}/blood-requests/$requestId',
      );

      // Response dari backend: { success: true, message: "...", data: {...} }
      if (response.statusCode == 200 && response.data['data'] != null) {
        return BloodRequestDetailResponse.fromJson(response.data['data']);
      }

      throw Exception('Blood request not found');
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// PUT /api/v1/blood-requests/:id
  /// Mengupdate blood request (hanya bisa update yang status Pending)
  Future<BloodRequestDetailResponse> updateBloodRequest(
    String requestId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.put(
        '${AppConstants.apiBaseUrl}/blood-requests/$requestId',
        data: data,
      );

      // Response dari backend: { success: true, message: "...", data: {...} }
      if (response.statusCode == 200 && response.data['data'] != null) {
        return BloodRequestDetailResponse.fromJson(response.data['data']);
      }

      throw Exception('Failed to update blood request');
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// PUT /api/v1/blood-requests/:id/close
  /// Menutup blood request (set status ke Completed)
  Future<void> closeBloodRequest(String requestId) async {
    try {
      final response = await _dio.put(
        '${AppConstants.apiBaseUrl}/blood-requests/$requestId/close',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to close blood request');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// GET /api/v1/blood-requests
  /// Mengambil semua blood request yang tersedia (untuk explore/matching)
  Future<List<BloodRequestListResponse>> getAvailableBloodRequests() async {
    try {
      final response = await _dio.get(
        '${AppConstants.apiBaseUrl}/blood-requests',
      );

      // Response dari backend: { success: true, message: "...", data: [...] }
      if (response.statusCode == 200 && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        return data
            .map((item) => BloodRequestListResponse.fromJson(item))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  /// Handle DioException dan convert ke user-friendly error message
  String _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'An error occurred';
        if (statusCode == 400) {
          return 'Invalid request data';
        } else if (statusCode == 401) {
          return 'Unauthorized. Please login again.';
        } else if (statusCode == 422) {
          return message;
        } else if (statusCode == 404) {
          return 'Blood request not found';
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
