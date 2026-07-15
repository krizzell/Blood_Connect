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
    @Default('') String phone,
    @Default('') String gender,
    @Default('') @JsonKey(name: 'blood_type') String bloodType,
    @Default('') String rhesus,
    double? weight,
    @Default(true) @JsonKey(name: 'is_available') bool isAvailable,
    @Default(false) @JsonKey(name: 'is_verified') bool isVerified,
    @JsonKey(name: 'profile_photo') String? profilePhoto,
    @Default('user') String role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
