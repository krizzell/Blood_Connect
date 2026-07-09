import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model representing the authenticated user
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String fullName,
    required String email,
    required String phone,
    required String gender,
    required String bloodType,
    required String rhesus,
    required double? weight,
    required bool isAvailable,
    required bool isVerified,
    required String? profilePhoto,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
