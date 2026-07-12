import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request.freezed.dart';
part 'register_request.g.dart';

/// Request model for register endpoint
@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    @JsonKey(name: 'full_name') required String fullName,
    required String email,
    required String password,
    required String phone,
    required String gender,
    @JsonKey(name: 'birth_date') required String birthDate,
    @JsonKey(name: 'blood_type') required String bloodType,
    required String rhesus,
    required int weight,
    @JsonKey(name: 'last_donor_date') required String? lastDonorDate,
    required double latitude,
    required double longitude,
    @JsonKey(name: 'profile_photo') required String? profilePhoto,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}
