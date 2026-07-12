import 'package:blood_connect/features/blood_request/data/datasources/blood_request_api_service.dart';
import 'package:blood_connect/features/blood_request/data/models/models_export.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:blood_connect/core/network/dio_client.dart';

/// Abstract repository untuk blood request data operations
abstract class BloodRequestRepository {
  /// Create new blood request
  Future<BloodRequestResponse> createBloodRequest(
    BloodRequestRequest request,
  );

  /// Get all blood requests for current user
  Future<List<BloodRequestListResponse>> getMyBloodRequests();

  /// Get detail of specific blood request
  Future<BloodRequestDetailResponse> getBloodRequestDetail(String requestId);

  /// Update blood request
  Future<BloodRequestDetailResponse> updateBloodRequest(
    String requestId,
    Map<String, dynamic> data,
  );

  /// Close blood request
  Future<void> closeBloodRequest(String requestId);

  /// Get available blood requests for exploring/matching
  Future<List<BloodRequestListResponse>> getAvailableBloodRequests();
}

/// Implementation dari BloodRequestRepository
class BloodRequestRepositoryImpl implements BloodRequestRepository {
  final BloodRequestApiService _apiService;

  BloodRequestRepositoryImpl(this._apiService);

  @override
  Future<BloodRequestResponse> createBloodRequest(
    BloodRequestRequest request,
  ) async {
    return await _apiService.createBloodRequest(request);
  }

  @override
  Future<List<BloodRequestListResponse>> getMyBloodRequests() async {
    return await _apiService.getMyBloodRequests();
  }

  @override
  Future<BloodRequestDetailResponse> getBloodRequestDetail(
    String requestId,
  ) async {
    return await _apiService.getBloodRequestDetail(requestId);
  }

  @override
  Future<BloodRequestDetailResponse> updateBloodRequest(
    String requestId,
    Map<String, dynamic> data,
  ) async {
    return await _apiService.updateBloodRequest(requestId, data);
  }

  @override
  Future<void> closeBloodRequest(String requestId) async {
    return await _apiService.closeBloodRequest(requestId);
  }

  @override
  Future<List<BloodRequestListResponse>> getAvailableBloodRequests() async {
    return await _apiService.getAvailableBloodRequests();
  }
}

/// Riverpod provider untuk BloodRequestApiService
final bloodRequestApiServiceProvider = Provider<BloodRequestApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return BloodRequestApiService(dio);
});

/// Riverpod provider untuk BloodRequestRepository
final bloodRequestRepositoryProvider = Provider<BloodRequestRepository>((ref) {
  final apiService = ref.watch(bloodRequestApiServiceProvider);
  return BloodRequestRepositoryImpl(apiService);
});
