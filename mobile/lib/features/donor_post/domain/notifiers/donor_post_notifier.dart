import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_connect/features/donor_post/data/models/donor_post_request.dart';
import 'package:blood_connect/features/donor_post/data/models/donor_post_response.dart';
import 'package:blood_connect/features/donor_post/data/repositories/donor_post_repository.dart';

class DonorPostState {
  final bool isLoading;
  final String? errorMessage;
  final List<DonorPostListResponse>? myPosts;
  final List<DonorPostListResponse>? availablePosts;
  final DonorPostDetailResponse? selectedPost;

  DonorPostState({
    this.isLoading = false,
    this.errorMessage,
    this.myPosts,
    this.availablePosts,
    this.selectedPost,
  });

  DonorPostState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<DonorPostListResponse>? myPosts,
    List<DonorPostListResponse>? availablePosts,
    DonorPostDetailResponse? selectedPost,
  }) {
    return DonorPostState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      myPosts: myPosts ?? this.myPosts,
      availablePosts: availablePosts ?? this.availablePosts,
      selectedPost: selectedPost ?? this.selectedPost,
    );
  }
}

class DonorPostNotifier extends StateNotifier<DonorPostState> {
  final DonorPostRepository _repository;

  DonorPostNotifier(this._repository) : super(DonorPostState());

  Future<void> getAvailablePosts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final posts = await _repository.getAvailablePosts();
      state = state.copyWith(isLoading: false, availablePosts: posts);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> getMyPosts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final posts = await _repository.getMyPosts();
      state = state.copyWith(isLoading: false, myPosts: posts);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> getPostDetail(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final post = await _repository.getPostDetail(id);
      state = state.copyWith(isLoading: false, selectedPost: post);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> createPost(CreateDonorPostRequest request) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.createDonorPost(request);
      state = state.copyWith(isLoading: false);
      await getMyPosts();
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> closePost(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _repository.closePost(id);
      state = state.copyWith(isLoading: false);
      
      // Update local state instead of refetching to save bandwidth
      if (state.myPosts != null) {
        final updatedList = state.myPosts!.map((p) {
          if (p.id == id) {
            return p.copyWith(status: 'Completed');
          }
          return p;
        }).toList();
        state = state.copyWith(myPosts: updatedList);
      }
      
      if (state.selectedPost != null && state.selectedPost!.id == id) {
        state = state.copyWith(
          selectedPost: state.selectedPost!.copyWith(status: 'Completed'),
        );
      }
      
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final donorPostNotifierProvider = StateNotifierProvider<DonorPostNotifier, DonorPostState>((ref) {
  return DonorPostNotifier(ref.watch(donorPostRepositoryProvider));
});
