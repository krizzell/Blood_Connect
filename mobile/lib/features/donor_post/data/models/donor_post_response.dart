import 'package:freezed_annotation/freezed_annotation.dart';

part 'donor_post_response.freezed.dart';
part 'donor_post_response.g.dart';

@freezed
class DonorPostListResponse with _$DonorPostListResponse {
  const factory DonorPostListResponse({
    required String id,
    @JsonKey(name: 'user_name') required String userName,
    @JsonKey(name: 'blood_type') required String bloodType,
    required String rhesus,
    required String location,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _DonorPostListResponse;

  factory DonorPostListResponse.fromJson(Map<String, dynamic> json) =>
      _$DonorPostListResponseFromJson(json);
}

@freezed
class DonorPostDetailResponse with _$DonorPostDetailResponse {
  const factory DonorPostDetailResponse({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'user_name') required String userName,
    @JsonKey(name: 'contact_phone') required String contactPhone,
    @JsonKey(name: 'blood_type') required String bloodType,
    required String rhesus,
    required String location,
    String? notes,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _DonorPostDetailResponse;

  factory DonorPostDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$DonorPostDetailResponseFromJson(json);
}
