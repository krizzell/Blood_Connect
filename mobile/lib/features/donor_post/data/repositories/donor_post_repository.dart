import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_connect/core/network/dio_client.dart';
import 'package:blood_connect/features/donor_post/data/models/donor_post_request.dart';
import 'package:blood_connect/features/donor_post/data/models/donor_post_response.dart';

final donorPostRepositoryProvider = Provider<DonorPostRepository>((ref) {
  return DonorPostRepository(ref.watch(dioProvider));
});

class DonorPostRepository {
  final Dio _dio;

  DonorPostRepository(this._dio);

  Future<void> createDonorPost(CreateDonorPostRequest request) async {
    try {
      await _dio.post(
        '/donor-posts',
        data: request.toJson(),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  Future<List<DonorPostListResponse>> getAvailablePosts() async {
    try {
      final response = await _dio.get('/donor-posts/available');
      final data = response.data['data'] as List<dynamic>?;
      if (data == null) return [];
      return data.map((json) => DonorPostListResponse.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  Future<List<DonorPostListResponse>> getMyPosts() async {
    try {
      final response = await _dio.get('/donor-posts/my');
      final data = response.data['data'] as List<dynamic>?;
      if (data == null) return [];
      return data.map((json) => DonorPostListResponse.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  Future<DonorPostDetailResponse> getPostDetail(String id) async {
    try {
      final response = await _dio.get('/donor-posts/$id');
      return DonorPostDetailResponse.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  Future<void> closePost(String id) async {
    try {
      await _dio.put('/donor-posts/$id/close');
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  String _handleError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response?.data;
      if (data['errors'] != null) {
        final errors = data['errors'] as Map<String, dynamic>;
        if (errors.isNotEmpty) {
          return errors.values.first[0].toString();
        }
      }
      if (data['message'] != null) {
        return data['message'].toString();
      }
    }
    return 'Terjadi kesalahan jaringan. Silakan coba lagi.';
  }
}
