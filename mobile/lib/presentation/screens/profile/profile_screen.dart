import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blood_connect/core/config/theme/app_colors.dart';
import 'package:blood_connect/core/config/theme/app_typography.dart';
import 'package:blood_connect/features/authentication/domain/domain_export.dart';
import 'package:blood_connect/shared/widgets/error_widget.dart';
import 'package:blood_connect/shared/widgets/loading_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil',
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
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(profileNotifierProvider.notifier).refreshProfile();
          },
          child: profileState.when(
            data: (profile) {
              if (profile == null) {
                return const Center(child: Text('No profile data'));
              }
              return _buildProfileContent(profile);
            },
            loading: () => _buildSkeletonLoading(),
            error: (error, stack) => ErrorStateWidget(
              title: 'Gagal Memuat Profil',
              message: error.toString(),
              onRetry: () {
                ref.read(profileNotifierProvider.notifier).fetchProfile();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(dynamic profile) {
    // Determine last donor text
    String lastDonorText = '-';
    if (profile.lastDonorDate != null) {
      final difference = DateTime.now().difference(profile.lastDonorDate!);
      if (difference.inDays < 30) {
        lastDonorText = '${difference.inDays} hari';
      } else {
        lastDonorText = '${(difference.inDays / 30).floor()} bulan';
      }
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  profile.fullName,
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  profile.email,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${profile.bloodType} Rhesus ${profile.rhesus}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),

          // Statistics Section
          Text(
            'Riwayat Donor',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  label: 'Total Donor',
                  value: '-', // Backend currently doesn't provide this exact stat
                  icon: Icons.bloodtype,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatBox(
                  label: 'Terakhir Donor',
                  value: lastDonorText,
                  icon: Icons.calendar_today,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Menu Items
          Text(
            'Pengaturan',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          _buildMenuItemWithIcon(
            icon: Icons.edit,
            label: 'Edit Profil',
            onTap: () {},
          ),
          _buildMenuItemWithIcon(
            icon: Icons.security,
            label: 'Ubah Password',
            onTap: () {},
          ),
          _buildMenuItemWithIcon(
            icon: Icons.notifications,
            label: 'Notifikasi',
            onTap: () {},
          ),
          _buildMenuItemWithIcon(
            icon: Icons.help,
            label: 'Bantuan & Dukungan',
            onTap: () {},
          ),
          SizedBox(height: 24.h),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ref.read(authNotifierProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                ShimmerLoading(width: 80.w, height: 80.w, borderRadius: BorderRadius.circular(40)),
                SizedBox(height: 16.h),
                ShimmerLoading(width: 150.w, height: 24.h),
                SizedBox(height: 4.h),
                ShimmerLoading(width: 120.w, height: 16.h),
                SizedBox(height: 12.h),
                ShimmerLoading(width: 100.w, height: 32.h, borderRadius: BorderRadius.circular(20)),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          ShimmerLoading(width: 120.w, height: 24.h),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(child: ShimmerLoading(width: double.infinity, height: 100.h, borderRadius: BorderRadius.circular(12))),
              SizedBox(width: 12.w),
              Expanded(child: ShimmerLoading(width: double.infinity, height: 100.h, borderRadius: BorderRadius.circular(12))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
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
          Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
          SizedBox(height: 8.h),
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

  Widget _buildMenuItemWithIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.border,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.textSecondary,
              size: 24,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
