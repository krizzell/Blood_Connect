import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:blood_connect/core/config/theme/app_colors.dart';
import 'package:blood_connect/core/config/theme/app_typography.dart';
import 'package:blood_connect/core/config/router/app_routes.dart';
import 'package:blood_connect/features/authentication/domain/domain_export.dart';
import 'package:blood_connect/features/blood_request/domain/domain_export.dart';
import 'package:blood_connect/shared/widgets/loading_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final exploreState = ref.watch(exploreNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              ref.read(profileNotifierProvider.notifier).refreshProfile(),
              ref.read(exploreNotifierProvider.notifier).getAvailableRequests(),
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                profileState.when(
                  data: (profile) {
                    final firstName = profile?.fullName.split(' ').first ?? 'Pengguna';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, $firstName',
                          style: AppTypography.headingLarge.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Bantu menyelamatkan nyawa dengan berbagi darah',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => _buildHeaderSkeleton(),
                  error: (error, _) => Text(
                    'Halo',
                    style: AppTypography.headingLarge.copyWith(color: AppColors.textPrimary),
                  ),
                ),
                SizedBox(height: 32.h),

                // Blood Request Section
                exploreState.when(
                  data: (requests) {
                    final urgentCount = requests.where((r) => r.urgency == 'Critical' || r.urgency == 'High').length;
                    return _buildSectionCard(
                      title: 'Permintaan Darah Mendesak',
                      subtitle: 'Ada $urgentCount permintaan darah darurat',
                      icon: Icons.local_hospital,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: AppColors.primary,
                    );
                  },
                  loading: () => ShimmerLoading(width: double.infinity, height: 80.h, borderRadius: BorderRadius.circular(12)),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                SizedBox(height: 16.h),

                // Available Donors Section
                exploreState.when(
                  data: (requests) {
                    return _buildSectionCard(
                      title: 'Permintaan Darah Aktif',
                      subtitle: '${requests.length} permintaan darah di area Anda',
                      icon: Icons.people,
                      backgroundColor: const Color(0xFFE8F5E9),
                      iconColor: const Color(0xFF4CAF50),
                    );
                  },
                  loading: () => ShimmerLoading(width: double.infinity, height: 80.h, borderRadius: BorderRadius.circular(12)),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                SizedBox(height: 16.h),

                // Statistics
                Text(
                  'Statistik Anda',
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                profileState.when(
                  data: (profile) {
                    String lastDonorText = '-';
                    if (profile?.lastDonorDate != null) {
                      final difference = DateTime.now().difference(profile!.lastDonorDate!);
                      if (difference.inDays < 30) {
                        lastDonorText = '${difference.inDays} hari';
                      } else {
                        lastDonorText = '${(difference.inDays / 30).floor()} bulan';
                      }
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            label: 'Total Donor',
                            value: '-',
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildStatCard(
                            label: 'Terakhir Donor',
                            value: lastDonorText,
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => Row(
                    children: [
                      Expanded(child: ShimmerLoading(width: double.infinity, height: 80.h, borderRadius: BorderRadius.circular(12))),
                      SizedBox(width: 12.w),
                      Expanded(child: ShimmerLoading(width: double.infinity, height: 80.h, borderRadius: BorderRadius.circular(12))),
                    ],
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                SizedBox(height: 32.h),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push(AppRoutes.createBloodRequest);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Buat Permintaan Darah'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerLoading(width: 200.w, height: 32.h),
        SizedBox(height: 8.h),
        ShimmerLoading(width: 280.w, height: 16.h),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
