import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_connect/features/blood_request/data/data_export.dart';

class ExploreNotifier extends StateNotifier<AsyncValue<List<BloodRequestListResponse>>> {
  final BloodRequestRepository _repository;

  ExploreNotifier(this._repository) : super(const AsyncValue.loading()) {
    getAvailableRequests();
  }

  Future<void> getAvailableRequests() async {
    state = const AsyncValue.loading();
    try {
      final requests = await _repository.getAvailableBloodRequests();
      state = AsyncValue.data(requests);
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }
}

final exploreNotifierProvider = StateNotifierProvider<ExploreNotifier, AsyncValue<List<BloodRequestListResponse>>>((ref) {
  final repository = ref.watch(bloodRequestRepositoryProvider);
  return ExploreNotifier(repository);
});
