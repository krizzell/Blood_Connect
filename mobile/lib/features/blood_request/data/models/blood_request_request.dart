import 'package:freezed_annotation/freezed_annotation.dart';

part 'blood_request_request.freezed.dart';
part 'blood_request_request.g.dart';

/// DTO untuk POST /api/v1/blood-requests
/// Digunakan untuk mengirim data ketika membuat blood request baru
@freezed
class BloodRequestRequest with _$BloodRequestRequest {
  const factory BloodRequestRequest({
    /// Nama pasien yang membutuhkan darah
    @JsonKey(name: 'patient_name')
    required String patientName,

    /// Hubungan dengan pasien (ayah, ibu, saudara, dll)
    required String relationship,

    /// Lokasi / Daerah
    required String location,

    /// Jenis darah: A, B, AB, O
    @JsonKey(name: 'blood_type')
    required String bloodType,

    /// Rhesus darah: +, -
    required String rhesus,

    /// Jumlah kantong darah yang dibutuhkan (minimal 1)
    @JsonKey(name: 'bags_needed')
    required int bagsNeeded,

    /// Tingkat urgency: Low, Medium, High, Critical
    required String urgency,

    /// Catatan tambahan (opsional)
    String? notes,
  }) = _BloodRequestRequest;

  factory BloodRequestRequest.fromJson(Map<String, dynamic> json) =>
      _$BloodRequestRequestFromJson(json);
}
