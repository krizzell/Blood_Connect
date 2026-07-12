import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    @JsonKey(name: 'full_name') required String fullName,
    required String email,
    required String phone,
    required String gender,
    @JsonKey(name: 'birth_date') required DateTime birthDate,
    @JsonKey(name: 'blood_type') required String bloodType,
    required String rhesus,
    required int weight,
    @JsonKey(name: 'last_donor_date') DateTime? lastDonorDate,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'profile_photo') String? profilePhoto,
    @JsonKey(name: 'is_available') required bool isAvailable,
    @JsonKey(name: 'is_verified') required bool isVerified,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
}
