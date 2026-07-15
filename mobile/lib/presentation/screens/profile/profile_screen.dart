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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Avatar and Background
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 32, bottom: 24),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              border: Border(
                bottom: BorderSide(color: AppColors.outlineVariant, width: 1),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 3),
                    image: const DecorationImage(
                      image: NetworkImage('https://www.gstatic.com/labs-code/stitch/stitch-placeholder-300x300.svg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.fullName,
                  style: AppTypography.headlineLargeMobile.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Golongan Darah: ${profile.bloodType}${profile.rhesus}',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistics Section
                Text(
                  'Aktivitas Donor',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatBox(
                        label: 'Total Donor',
                        value: '0', // TODO: From real history when supported
                        icon: Icons.water_drop,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatBox(
                        label: 'Terakhir Donor',
                        value: lastDonorText,
                        icon: Icons.calendar_month,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Menu Items
                Text(
                  'Pengaturan Akun',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outlineVariant),
                  ),
                  child: Column(
                    children: [
                      _buildMenuItemWithIcon(
                        icon: Icons.person_outline,
                        label: 'Informasi Pribadi',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Informasi Pribadi'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Nama: ${profile.fullName}'),
                                  const SizedBox(height: 8),
                                  Text('Email: ${profile.email}'),
                                  const SizedBox(height: 8),
                                  Text('Telepon: ${profile.phone.isNotEmpty ? profile.phone : '-'}'),
                                  const SizedBox(height: 8),
                                  Text('Jenis Kelamin: ${profile.gender.isNotEmpty ? profile.gender : '-'}'),
                                  const SizedBox(height: 8),
                                  Text('Golongan Darah: ${profile.bloodType}${profile.rhesus}'),
                                  const SizedBox(height: 8),
                                  Text('Berat Badan: ${profile.weight != null ? '${profile.weight} kg' : '-'}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Tutup'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      _buildMenuItemWithIcon(
                        icon: Icons.medical_information_outlined,
                        label: 'Riwayat Medis',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Riwayat Medis'),
                              content: const Text('Menu ini akan menampilkan catatan riwayat screening dan donor darah Anda. Fitur ini sedang dalam pengembangan.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Tutup'),
                                ),
                              ],
                            ),
                          );
                        },
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(authNotifierProvider.notifier).logout();
                    },
                    icon: const Icon(Icons.logout),
                    label: Text(
                      'Keluar',
                      style: AppTypography.labelLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildSkeletonLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                ShimmerLoading(width: 100, height: 100, borderRadius: BorderRadius.circular(50)),
                const SizedBox(height: 16),
                ShimmerLoading(width: 150, height: 28),
                const SizedBox(height: 8),
                ShimmerLoading(width: 120, height: 16),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(child: ShimmerLoading(width: double.infinity, height: 100, borderRadius: BorderRadius.circular(12))),
              const SizedBox(width: 16),
              Expanded(child: ShimmerLoading(width: double.infinity, height: 100, borderRadius: BorderRadius.circular(12))),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryContainer,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemWithIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(16))
          : BorderRadius.zero,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: AppColors.outlineVariant.withOpacity(0.5),
                    width: 1,
                  ),
                ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.onSurface,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
