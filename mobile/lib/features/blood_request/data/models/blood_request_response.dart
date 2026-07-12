import 'package:freezed_annotation/freezed_annotation.dart';

part 'blood_request_response.freezed.dart';
part 'blood_request_response.g.dart';

/// DTO untuk response dari POST /api/v1/blood-requests
/// Berisi data blood request yang baru dibuat
@freezed
class BloodRequestResponse with _$BloodRequestResponse {
  const factory BloodRequestResponse({
    /// ID unik blood request (UUID)
    required String id,

    /// ID user yang membuat blood request
    @JsonKey(name: 'user_id')
    required String userId,

    /// Nama pasien
    @JsonKey(name: 'patient_name')
    required String patientName,

    /// Hubungan dengan pasien
    required String relationship,

    /// Lokasi / Daerah
    required String location,

    /// Jenis darah
    @JsonKey(name: 'blood_type')
    required String bloodType,

    /// Rhesus darah
    required String rhesus,

    /// Jumlah kantong yang dibutuhkan
    @JsonKey(name: 'bags_needed')
    required int bagsNeeded,

    /// Tingkat urgency
    required String urgency,

    /// Status permintaan (Pending, Searching, Donor Found, Completed, Cancelled)
    required String status,

    /// Catatan tambahan
    String? notes,

    /// Timestamp kapan blood request dibuat
    @JsonKey(name: 'created_at')
    required DateTime createdAt,
  }) = _BloodRequestResponse;

  factory BloodRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$BloodRequestResponseFromJson(json);
}

/// DTO untuk GET /api/v1/blood-requests/my
/// Berisi list blood request user dengan info minimal
@freezed
class BloodRequestListResponse with _$BloodRequestListResponse {
  const factory BloodRequestListResponse({
    required String id,
    @JsonKey(name: 'patient_name')
    required String patientName,
    required String location,
    @JsonKey(name: 'blood_type')
    required String bloodType,
    required String rhesus,
    @JsonKey(name: 'bags_needed')
    required int bagsNeeded,
    required String urgency,
    required String status,
    @JsonKey(name: 'created_at')
    required DateTime createdAt,
  }) = _BloodRequestListResponse;

  factory BloodRequestListResponse.fromJson(Map<String, dynamic> json) =>
      _$BloodRequestListResponseFromJson(json);
}

/// DTO untuk GET /api/v1/blood-requests/:id
/// Berisi detail lengkap satu blood request
@freezed
class BloodRequestDetailResponse with _$BloodRequestDetailResponse {
  const factory BloodRequestDetailResponse({
    required String id,
    @JsonKey(name: 'patient_name')
    required String patientName,
    required String relationship,
    required String location,
    @JsonKey(name: 'blood_type')
    required String bloodType,
    required String rhesus,
    @JsonKey(name: 'bags_needed')
    required int bagsNeeded,
    required String urgency,
    required String status,
    String? notes,
    @JsonKey(name: 'contact_phone')
    required String contactPhone,
    @JsonKey(name: 'created_at')
    required DateTime createdAt,
    @JsonKey(name: 'updated_at')
    required DateTime updatedAt,
    @JsonKey(name: 'fulfilled_at')
    DateTime? fulfilledAt,
  }) = _BloodRequestDetailResponse;

  factory BloodRequestDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$BloodRequestDetailResponseFromJson(json);
}
