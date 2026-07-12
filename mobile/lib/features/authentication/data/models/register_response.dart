import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_response.freezed.dart';
part 'register_response.g.dart';

/// Response model for register endpoint
@freezed
class RegisterResponse with _$RegisterResponse {
  const factory RegisterResponse({
    required String id,
    @JsonKey(name: 'full_name') required String fullName,
    required String email,
  }) = _RegisterResponse;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}
