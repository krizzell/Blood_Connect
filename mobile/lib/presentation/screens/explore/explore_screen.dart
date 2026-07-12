import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:blood_connect/core/config/theme/app_colors.dart';
import 'package:blood_connect/core/config/theme/app_typography.dart';
import 'package:blood_connect/core/config/router/app_routes.dart';
import 'package:blood_connect/features/blood_request/domain/domain_export.dart';
import 'package:blood_connect/features/donor_post/domain/notifiers/donor_post_notifier.dart';
import 'package:blood_connect/shared/widgets/loading_widget.dart';
import 'package:blood_connect/shared/widgets/error_widget.dart';
import 'package:blood_connect/shared/widgets/empty_state_widget.dart';
import 'package:blood_connect/features/blood_request/data/models/blood_request_response.dart';
import 'package:blood_connect/features/donor_post/data/models/donor_post_response.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _filterLocationController = TextEditingController();
  String _searchQuery = '';
  String _selectedBloodType = 'Semua';
  String _selectedRhesus = 'Semua';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Fetch donor posts as well
    Future.microtask(() {
      ref.read(donorPostNotifierProvider.notifier).getAvailablePosts();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _filterLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Eksplorasi',
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
            Tab(text: 'Membutuhkan Darah'),
            Tab(text: 'Siap Donor'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Filter
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari nama pasien, lokasi...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: Colors.white),
                      onPressed: () => _showFilterDialog(context),
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBloodRequestsTab(),
                  _buildDonorPostsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Pencarian',
                        style: AppTypography.headingSmall,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text('Golongan Darah', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    children: ['Semua', 'A', 'B', 'AB', 'O'].map((type) {
                      final isSelected = _selectedBloodType == type;
                      return ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() => _selectedBloodType = type);
                            setState(() => _selectedBloodType = type);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.h),
                  Text('Rhesus', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    children: ['Semua', '+', '-'].map((type) {
                      final isSelected = _selectedRhesus == type;
                      return ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() => _selectedRhesus = type);
                            setState(() => _selectedRhesus = type);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.h),
                  Text('Lokasi', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: _filterLocationController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Ketik nama kota/daerah...',
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBloodRequestsTab() {
    final exploreState = ref.watch(exploreNotifierProvider);
    
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(exploreNotifierProvider.notifier).getAvailableRequests();
      },
      child: exploreState.when(
        data: (requests) {
          final filteredRequests = requests.where((request) {
            bool matchBlood = _selectedBloodType == 'Semua' || request.bloodType == _selectedBloodType;
            bool matchRhesus = _selectedRhesus == 'Semua' || request.rhesus == _selectedRhesus;
            bool matchLoc = _filterLocationController.text.isEmpty || 
                 request.location.toLowerCase().contains(_filterLocationController.text.toLowerCase());
            bool matchSearch = _searchQuery.isEmpty || 
                 '${request.patientName} ${request.location}'.toLowerCase().contains(_searchQuery);
            return matchBlood && matchRhesus && matchLoc && matchSearch;
          }).toList();

          if (filteredRequests.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: const EmptyStateWidget(
                    title: 'Belum Ada Permintaan',
                    subtitle: 'Tidak ada permintaan darah aktif saat ini.',
                    icon: Icons.search_off,
                  ),
                ),
              ],
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            itemCount: filteredRequests.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              return _buildRequestCard(filteredRequests[index]);
            },
          );
        },
        loading: () => ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          itemCount: 5,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) => ShimmerLoading(
            width: double.infinity,
            height: 120.h,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        error: (error, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ErrorStateWidget(
                title: 'Gagal Memuat Data',
                message: error.toString(),
                onRetry: () {
                  ref.read(exploreNotifierProvider.notifier).getAvailableRequests();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorPostsTab() {
    final donorState = ref.watch(donorPostNotifierProvider);
    
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(donorPostNotifierProvider.notifier).getAvailablePosts();
      },
      child: donorState.isLoading 
          ? ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              itemCount: 5,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) => ShimmerLoading(
                width: double.infinity,
                height: 100.h,
                borderRadius: BorderRadius.circular(12),
              ),
            )
          : donorState.errorMessage != null
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ErrorStateWidget(
                        title: 'Gagal Memuat Data',
                        message: donorState.errorMessage!,
                        onRetry: () {
                          ref.read(donorPostNotifierProvider.notifier).getAvailablePosts();
                        },
                      ),
                    ),
                  ],
                )
              : Builder(
                  builder: (context) {
                    final posts = donorState.availablePosts ?? [];
                    final filteredPosts = posts.where((post) {
                      bool matchBlood = _selectedBloodType == 'Semua' || post.bloodType == _selectedBloodType;
                      bool matchRhesus = _selectedRhesus == 'Semua' || post.rhesus == _selectedRhesus;
                      bool matchLoc = _filterLocationController.text.isEmpty || 
                           post.location.toLowerCase().contains(_filterLocationController.text.toLowerCase());
                      bool matchSearch = _searchQuery.isEmpty || 
                           '${post.userName} ${post.location}'.toLowerCase().contains(_searchQuery);
                      return matchBlood && matchRhesus && matchLoc && matchSearch;
                    }).toList();

                    if (filteredPosts.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: const EmptyStateWidget(
                              title: 'Belum Ada Tawaran',
                              subtitle: 'Tidak ada pendonor yang memposting saat ini.',
                              icon: Icons.search_off,
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                      itemCount: filteredPosts.length,
                      separatorBuilder: (context, index) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        return _buildDonorPostCard(filteredPosts[index]);
                      },
                    );
                  }
                ),
    );
  }

  Widget _buildRequestCard(BloodRequestListResponse request) {
    Color urgencyColor = AppColors.primary;
    if (request.urgency == 'Critical') {
      urgencyColor = AppColors.error;
    } else if (request.urgency == 'Low') {
      urgencyColor = Colors.blue;
    }

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
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: urgencyColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${request.bloodType}${request.rhesus}',
                  style: AppTypography.headingSmall.copyWith(
                    color: urgencyColor,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pasien: ${request.patientName}',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: urgencyColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          request.urgency,
                          style: AppTypography.labelSmall.copyWith(
                            color: urgencyColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          request.location,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Butuh ${request.bagsNeeded} Kantong',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
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
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${post.bloodType}${post.rhesus}',
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pendonor: ${post.userName}',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Siap Donor',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
