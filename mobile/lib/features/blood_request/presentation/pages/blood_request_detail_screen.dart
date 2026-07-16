import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:blood_connect/core/config/theme/app_colors.dart';
import 'package:blood_connect/core/config/theme/app_typography.dart';
import 'package:blood_connect/features/blood_request/domain/domain_export.dart';
import 'package:blood_connect/shared/widgets/loading_widget.dart';
import 'package:blood_connect/shared/widgets/error_widget.dart';

class BloodRequestDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const BloodRequestDetailScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  ConsumerState<BloodRequestDetailScreen> createState() =>
      _BloodRequestDetailScreenState();
}

class _BloodRequestDetailScreenState
    extends ConsumerState<BloodRequestDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(bloodRequestNotifierProvider.notifier).getBloodRequestDetail(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bloodRequestNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Permintaan',
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: LoadingWidget())
            : state.errorMessage != null
                ? ErrorStateWidget(
                    title: 'Gagal Memuat Detail',
                    message: state.errorMessage!,
                    onRetry: () {
                      ref
                          .read(bloodRequestNotifierProvider.notifier)
                          .getBloodRequestDetail(widget.id);
                    },
                  )
                : state.selectedRequest == null
                    ? const Center(child: Text('Data tidak ditemukan'))
                    : SingleChildScrollView(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(state.selectedRequest!),
                            SizedBox(height: 24.h),
                            _buildInfoSection(state.selectedRequest!),
                            SizedBox(height: 24.h),
                            if ((state.bloodRequests?.any((r) => r.id == state.selectedRequest!.id) ?? false) && state.selectedRequest!.status == 'Pending') ...[
                              _buildMarkCompletedButton(context, state.selectedRequest!),
                              SizedBox(height: 16.h),
                            ],
                            _buildActionSection(state.selectedRequest!, state.bloodRequests?.any((r) => r.id == state.selectedRequest!.id) ?? false),
                          ],
                        ),
                      ),
      ),
    );
  }

  Widget _buildHeader(dynamic request) {
    Color urgencyColor = AppColors.primary;
    if (request.urgency == 'Critical') {
      urgencyColor = AppColors.error;
    } else if (request.urgency == 'Low') {
      urgencyColor = Colors.blue;
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: urgencyColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: urgencyColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: urgencyColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${request.bloodType}${request.rhesus}',
                style: AppTypography.headingLarge.copyWith(
                  color: urgencyColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dibutuhkan Darah',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${request.bagsNeeded} Kantong',
                  style: AppTypography.headingMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: urgencyColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Urgensi: ${request.urgency}',
                    style: AppTypography.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(dynamic request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi Pasien',
          style: AppTypography.headingSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        _buildInfoRow(Icons.water_drop_outlined, 'Golongan Darah', '${request.bloodType}${request.rhesus}'),
        _buildInfoRow(Icons.person_outline, 'Nama Pasien', request.patientName),
        _buildInfoRow(Icons.location_on_outlined, 'Lokasi', request.location),
        _buildInfoRow(Icons.calendar_today_outlined, 'Dibuat Pada',
            DateFormat('dd MMMM yyyy, HH:mm').format(request.createdAt)),
        if (request.notes != null && request.notes!.isNotEmpty) ...[
          SizedBox(height: 16.h),
          Text(
            'Catatan Tambahan',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              request.notes!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24,
            color: AppColors.primary,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(dynamic request, bool isOwner) {
    // Only show button if status is pending
    if (request.status != 'Pending') {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(Icons.check_circle_outline, color: AppColors.success, size: 48),
            SizedBox(height: 8.h),
            Text(
              'Permintaan ini sudah selesai',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (isOwner) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          // Launch WhatsApp
          String phone = request.contactPhone;
          if (phone.startsWith('0')) {
            phone = '62${phone.substring(1)}';
          }
          final String message = 'Halo, saya ingin mendonorkan darah untuk pasien ${request.patientName} (${request.bloodType}${request.rhesus}). Apakah masih membutuhkan darah?';
          final Uri url = Uri.parse('whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}');
          final Uri webUrl = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(message)}');
          
          // Simulasi buka WhatsApp
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => Container(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.chat, color: Colors.green, size: 28),
                      SizedBox(width: 12.w),
                      Text('Simulasi WhatsApp', style: AppTypography.headingSmall),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text('Mengirim pesan ke:', style: AppTypography.bodySmall),
                  Text('+$phone', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.h),
                  Text('Isi Pesan:', style: AppTypography.bodySmall),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 8.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(message, style: AppTypography.bodyMedium),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        try {
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            await launchUrl(webUrl, mode: LaunchMode.externalApplication);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tidak dapat membuka WhatsApp.'),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('Lanjutkan Buka Aplikasi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          backgroundColor: AppColors.primary,
        ),
        icon: const Icon(Icons.chat, color: Colors.white),
        label: const Text('Hubungi via WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildMarkCompletedButton(BuildContext context, dynamic request) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Tandai Selesai?'),
              content: const Text('Apakah permintaan darah ini sudah terpenuhi?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref
                        .read(bloodRequestNotifierProvider.notifier)
                        .closeBloodRequest(request.id)
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Permintaan darah berhasil ditandai selesai'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      // Refresh the detail
                      ref
                          .read(bloodRequestNotifierProvider.notifier)
                          .getBloodRequestDetail(request.id);
                    });
                  },
                  child: const Text('Ya, Selesai'),
                ),
              ],
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          side: BorderSide(color: AppColors.success),
        ),
        icon: Icon(Icons.check_circle, color: AppColors.success),
        label: Text('Tandai Sudah Terpenuhi', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
