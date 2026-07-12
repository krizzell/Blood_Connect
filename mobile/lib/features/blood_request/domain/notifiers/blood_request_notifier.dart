import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:blood_connect/features/blood_request/data/data_export.dart';

/// Blood Request State - untuk track state operasi blood request
class BloodRequestState {
  final bool isLoading;
  final List<BloodRequestListResponse>? bloodRequests;
  final BloodRequestResponse? createdRequest;
  final BloodRequestDetailResponse? selectedRequest;
  final String? errorMessage;
  final bool isSuccess;

  BloodRequestState({
    this.isLoading = false,
    this.bloodRequests,
    this.createdRequest,
    this.selectedRequest,
    this.errorMessage,
    this.isSuccess = false,
  });

  /// Copy with untuk update state
  BloodRequestState copyWith({
    bool? isLoading,
    List<BloodRequestListResponse>? bloodRequests,
    BloodRequestResponse? createdRequest,
    BloodRequestDetailResponse? selectedRequest,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return BloodRequestState(
      isLoading: isLoading ?? this.isLoading,
      bloodRequests: bloodRequests ?? this.bloodRequests,
      createdRequest: createdRequest ?? this.createdRequest,
      selectedRequest: selectedRequest ?? this.selectedRequest,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  /// Reset state ke initial
  BloodRequestState reset() {
    return BloodRequestState();
  }
}

/// Blood Request Notifier - untuk manage blood request operations
class BloodRequestNotifier extends StateNotifier<BloodRequestState> {
  final BloodRequestRepository _repository;

  BloodRequestNotifier(this._repository) : super(BloodRequestState());

  /// Create blood request baru
  /// Validate data dan kirim ke backend
  Future<void> createBloodRequest(BloodRequestRequest request) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

    try {
      final response = await _repository.createBloodRequest(request);
      
      state = state.copyWith(
        isLoading: false,
        createdRequest: response,
        isSuccess: true,
        errorMessage: null,
      );

      // Reload blood requests list setelah create
      await getMyBloodRequests();
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _handleDioError(e),
        isSuccess: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
    }
  }

  /// Get semua blood request milik user yang login
  Future<void> getMyBloodRequests() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final requests = await _repository.getMyBloodRequests();
      
      state = state.copyWith(
        isLoading: false,
        bloodRequests: requests,
        errorMessage: null,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _handleDioError(e),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Get detail blood request by ID
  Future<void> getBloodRequestDetail(String requestId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final detail = await _repository.getBloodRequestDetail(requestId);
      
      state = state.copyWith(
        isLoading: false,
        selectedRequest: detail,
        errorMessage: null,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _handleDioError(e),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Update blood request
  Future<void> updateBloodRequest(
    String requestId,
    Map<String, dynamic> data,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

    try {
      final updated = await _repository.updateBloodRequest(requestId, data);
      
      state = state.copyWith(
        isLoading: false,
        selectedRequest: updated,
        isSuccess: true,
        errorMessage: null,
      );

      // Reload blood requests list setelah update
      await getMyBloodRequests();
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _handleDioError(e),
        isSuccess: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
    }
  }

  /// Close blood request
  Future<void> closeBloodRequest(String requestId) async {
    state = state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);

    try {
      await _repository.closeBloodRequest(requestId);
      
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
      );

      // Reload blood requests list setelah close
      await getMyBloodRequests();
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _handleDioError(e),
        isSuccess: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
    }
  }

  /// Get available blood requests for explore/matching
  Future<List<BloodRequestListResponse>> getAvailableBloodRequests() async {
    try {
      return await _repository.getAvailableBloodRequests();
    } on DioException catch (e) {
      state = state.copyWith(
        errorMessage: _handleDioError(e),
      );
      return [];
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString(),
      );
      return [];
    }
  }

  /// Reset state ke initial
  void resetState() {
    state = state.reset();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
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

/// Riverpod state notifier provider for BloodRequestNotifier
final bloodRequestNotifierProvider =
    StateNotifierProvider<BloodRequestNotifier, BloodRequestState>((ref) {
  final repository = ref.watch(bloodRequestRepositoryProvider);
  return BloodRequestNotifier(repository);
});
