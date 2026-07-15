import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:blood_connect/core/config/theme/app_colors.dart';
import 'package:blood_connect/core/config/theme/app_typography.dart';
import 'package:blood_connect/core/config/router/app_routes.dart';
import 'package:blood_connect/shared/widgets/loading_widget.dart';
import 'package:blood_connect/features/blood_request/domain/domain_export.dart';
import 'package:blood_connect/features/donor_post/domain/notifiers/donor_post_notifier.dart';
import 'package:blood_connect/features/blood_request/data/data_export.dart';
import 'package:blood_connect/features/donor_post/data/models/donor_post_response.dart';
import 'package:blood_connect/shared/widgets/empty_state_widget.dart';
import 'package:blood_connect/shared/widgets/error_widget.dart';
import 'package:intl/intl.dart';

class BloodRequestScreen extends ConsumerStatefulWidget {
  const BloodRequestScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BloodRequestScreen> createState() => _BloodRequestScreenState();
}

class _BloodRequestScreenState extends ConsumerState<BloodRequestScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load blood requests & donor posts when screen opens
    Future.microtask(() {
      ref.read(bloodRequestNotifierProvider.notifier).getMyBloodRequests();
      ref.read(donorPostNotifierProvider.notifier).getMyPosts();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Aktivitas Saya',
          style: AppTypography.headingMedium.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.onSurfaceVariant,
          indicatorColor: AppColors.primary,
          labelStyle: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
          unselectedLabelStyle: AppTypography.labelLarge,
          tabs: const [
            Tab(text: 'Aktif'),
            Tab(text: 'Riwayat'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildActivityTab(isActive: true),
            _buildActivityTab(isActive: false),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateOptionsDialog(context);
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Buat Baru',
          style: AppTypography.labelLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showCreateOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Buat Postingan Baru',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.emergency, color: AppColors.error),
                ),
                title: Text('Butuh Darah', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                subtitle: Text('Buat permintaan darah untuk pasien', style: AppTypography.bodySmall),
                onTap: () {
                  context.pop();
                  context.push(AppRoutes.createBloodRequest);
                },
              ),
              const Divider(),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.successContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite, color: AppColors.success),
                ),
                title: Text('Siap Donor', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                subtitle: Text('Tawarkan ketersediaan donor Anda', style: AppTypography.bodySmall),
                onTap: () {
                  context.pop();
                  context.push(AppRoutes.createDonorPost);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActivityTab({required bool isActive}) {
    final requestState = ref.watch(bloodRequestNotifierProvider);
    final postState = ref.watch(donorPostNotifierProvider);

    if (requestState.isLoading || postState.isLoading) {
      return const Center(child: LoadingWidget());
    }

    if (requestState.errorMessage != null || postState.errorMessage != null) {
      return ErrorStateWidget(
        title: 'Terjadi Kesalahan',
        message: requestState.errorMessage ?? postState.errorMessage ?? 'Unknown error',
        onRetry: () {
          ref.read(bloodRequestNotifierProvider.notifier).getMyBloodRequests();
          ref.read(donorPostNotifierProvider.notifier).getMyPosts();
        },
      );
    }

    // Combine and sort
    List<dynamic> combinedList = [];
    final requests = requestState.bloodRequests ?? [];
    final posts = postState.myPosts ?? [];

    for (var r in requests) {
      bool isPending = r.status == 'Pending' || r.status == 'Searching';
      if ((isActive && isPending) || (!isActive && !isPending)) {
        combinedList.add(r);
      }
    }
    
    for (var p in posts) {
      bool isPending = p.status == 'Pending';
      if ((isActive && isPending) || (!isActive && !isPending)) {
        combinedList.add(p);
      }
    }

    // Sort by date descending
    combinedList.sort((a, b) {
      DateTime dateA = a is BloodRequestListResponse ? a.createdAt : (a as DonorPostListResponse).createdAt;
      DateTime dateB = b is BloodRequestListResponse ? b.createdAt : (b as DonorPostListResponse).createdAt;
      return dateB.compareTo(dateA);
    });

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          ref.read(bloodRequestNotifierProvider.notifier).getMyBloodRequests(),
          ref.read(donorPostNotifierProvider.notifier).getMyPosts(),
        ]);
      },
      child: combinedList.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: EmptyStateWidget(
                    title: isActive ? 'Belum Ada Aktivitas Aktif' : 'Belum Ada Riwayat',
                    subtitle: isActive ? 'Buat permintaan atau tawaran donor.' : 'Riwayat selesai Anda akan muncul di sini.',
                    icon: Icons.history,
                  ),
                ),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: combinedList.length,
              itemBuilder: (context, index) {
                final item = combinedList[index];
                if (item is BloodRequestListResponse) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildRequestCard(item),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildDonorPostCard(item as DonorPostListResponse),
                  );
                }
              },
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
        context.push('${AppRoutes.main}/${AppRoutes.bloodRequest}/${request.id}');
      },
      child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${request.bloodType}${request.rhesus}',
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.primaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: urgencyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        request.urgency,
                        style: AppTypography.labelSmall.copyWith(
                          color: urgencyColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    request.status,
                    style: AppTypography.labelSmall.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Butuh Darah: ${request.patientName}',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${request.bagsNeeded} kantong • ${request.location}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  DateFormat('dd MMM yyyy').format(request.createdAt),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorPostCard(DonorPostListResponse post) {
    return GestureDetector(
      onTap: () {
        context.push('${AppRoutes.main}/${AppRoutes.donorPost}/${post.id}');
      },
      child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${post.bloodType}${post.rhesus}',
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.primaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Siap Donor',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: post.status == 'Pending' ? Colors.blue.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    post.status == 'Pending' ? 'Tersedia' : 'Selesai',
                    style: AppTypography.labelSmall.copyWith(
                      color: post.status == 'Pending' ? Colors.blue : AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Tawaran Donor Anda',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    post.location,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  DateFormat('dd MMM yyyy').format(post.createdAt),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
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
