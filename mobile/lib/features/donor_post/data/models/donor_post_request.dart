import 'package:freezed_annotation/freezed_annotation.dart';

part 'donor_post_request.freezed.dart';
part 'donor_post_request.g.dart';

@freezed
class CreateDonorPostRequest with _$CreateDonorPostRequest {
  const factory CreateDonorPostRequest({
    @JsonKey(name: 'blood_type') required String bloodType,
    required String rhesus,
    required String location,
    @JsonKey(name: 'contact_phone') required String contactPhone,
    String? notes,
  }) = _CreateDonorPostRequest;

  factory CreateDonorPostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateDonorPostRequestFromJson(json);
}
