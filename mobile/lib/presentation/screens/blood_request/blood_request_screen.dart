import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:blood_connect/core/config/theme/app_colors.dart';
import 'package:blood_connect/core/config/theme/app_typography.dart';
import 'package:blood_connect/core/config/router/app_routes.dart';
import 'package:blood_connect/shared/widgets/loading_widget.dart';
import 'package:blood_connect/features/blood_request/domain/domain_export.dart';
import 'package:blood_connect/features/blood_request/data/data_export.dart';
import 'package:intl/intl.dart';

class BloodRequestScreen extends ConsumerStatefulWidget {
  const BloodRequestScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BloodRequestScreen> createState() => _BloodRequestScreenState();
}

class _BloodRequestScreenState extends ConsumerState<BloodRequestScreen> {
  @override
  void initState() {
    super.initState();
    // Load blood requests when screen opens
    Future.microtask(() {
      ref.read(bloodRequestNotifierProvider.notifier).getMyBloodRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bloodRequestNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Permintaan Darah',
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.textPrimary,
          ),
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
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.error,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Terjadi kesalahan',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          state.errorMessage ?? '',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: () {
                            ref
                                .read(
                                    bloodRequestNotifierProvider.notifier)
                                .getMyBloodRequests();
                          },
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  )
                : (state.bloodRequests?.isEmpty ?? true)
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 48,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Belum ada permintaan darah',
                              style: AppTypography.bodyLarge.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Buat permintaan darah pertama Anda',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Blood Request List
                            ...?state.bloodRequests?.map((request) {
                              return Column(
                                children: [
                                  _buildRequestCard(request),
                                  SizedBox(height: 12.h),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.createBloodRequest),
        label: const Text('Buat Permintaan'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildRequestCard(BloodRequestListResponse request) {
    final urgencyColor = request.urgency == 'Critical'
        ? AppColors.error
        : request.urgency == 'High'
            ? Colors.orange
            : request.urgency == 'Medium'
                ? Colors.amber
                : AppColors.success;

    final statusColor = request.status == 'Pending'
        ? Colors.blue
        : request.status == 'Searching'
            ? Colors.orange
            : request.status == 'Donor Found'
                ? Colors.purple
                : request.status == 'Completed'
                    ? AppColors.success
                    : AppColors.error;

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to blood request detail
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Blood Type, Urgency, Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Blood Type Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${request.bloodType}${request.rhesus}',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Urgency Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: urgencyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        request.urgency,
                        style: AppTypography.labelSmall.copyWith(
                          color: urgencyColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    request.status,
                    style: AppTypography.labelSmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Patient Info
            Text(
              'Pasien: ${request.patientName}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              request.hospitalName,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 12.h),

            // Footer: Bags & Created Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${request.bagsNeeded} kantong darah',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  DateFormat('dd MMM yyyy').format(request.createdAt),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
