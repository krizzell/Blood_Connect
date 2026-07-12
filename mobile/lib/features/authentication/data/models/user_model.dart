import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model representing the authenticated user
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    @JsonKey(name: 'full_name') required String fullName,
    required String email,
    required String phone,
    required String gender,
    @JsonKey(name: 'blood_type') required String bloodType,
    required String rhesus,
    required double? weight,
    @JsonKey(name: 'is_available') required bool isAvailable,
    @JsonKey(name: 'is_verified') required bool isVerified,
    @JsonKey(name: 'profile_photo') required String? profilePhoto,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
