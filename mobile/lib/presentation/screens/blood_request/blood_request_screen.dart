import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Permintaan Darah'),
            Tab(text: 'Tawaran Donor'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildMyRequestsTab(),
            _buildMyDonorPostsTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateOptionsDialog(context);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showCreateOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Buat Postingan Baru',
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 24.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
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
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
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
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMyRequestsTab() {
    final state = ref.watch(bloodRequestNotifierProvider);
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(bloodRequestNotifierProvider.notifier).getMyBloodRequests();
      },
      child: state.isLoading
          ? const Center(child: LoadingWidget())
          : state.errorMessage != null
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ErrorStateWidget(
                        title: 'Terjadi Kesalahan',
                        message: state.errorMessage!,
                        onRetry: () {
                          ref.read(bloodRequestNotifierProvider.notifier).getMyBloodRequests();
                        },
                      ),
                    ),
                  ],
                )
              : (state.bloodRequests?.isEmpty ?? true)
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: const EmptyStateWidget(
                            title: 'Belum Ada Permintaan',
                            subtitle: 'Buat permintaan darah pertama Anda',
                            icon: Icons.inbox_outlined,
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                      itemCount: state.bloodRequests!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _buildRequestCard(state.bloodRequests![index]),
                        );
                      },
                    ),
    );
  }

  Widget _buildMyDonorPostsTab() {
    final state = ref.watch(donorPostNotifierProvider);
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(donorPostNotifierProvider.notifier).getMyPosts();
      },
      child: state.isLoading
          ? const Center(child: LoadingWidget())
          : state.errorMessage != null
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ErrorStateWidget(
                        title: 'Terjadi Kesalahan',
                        message: state.errorMessage!,
                        onRetry: () {
                          ref.read(donorPostNotifierProvider.notifier).getMyPosts();
                        },
                      ),
                    ),
                  ],
                )
              : (state.myPosts?.isEmpty ?? true)
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: const EmptyStateWidget(
                            title: 'Belum Ada Tawaran',
                            subtitle: 'Buat tawaran donor darah pertama Anda',
                            icon: Icons.favorite_border,
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                      itemCount: state.myPosts!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: _buildDonorPostCard(state.myPosts![index]),
                        );
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

  Widget _buildDonorPostCard(DonorPostListResponse post) {
    return GestureDetector(
      onTap: () {
        context.push('${AppRoutes.main}/${AppRoutes.donorPost}/${post.id}');
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
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
                        '${post.bloodType}${post.rhesus}',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Siap Donor',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: post.status == 'Pending' ? Colors.blue.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    post.status == 'Pending' ? 'Tersedia' : 'Selesai',
                    style: AppTypography.labelSmall.copyWith(
                      color: post.status == 'Pending' ? Colors.blue : AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              'Pendonor: ${post.userName}',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    post.location,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  DateFormat('dd MMM yyyy').format(post.createdAt),
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
