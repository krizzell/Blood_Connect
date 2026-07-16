import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:blood_connect/core/config/theme/app_colors.dart';
import 'package:blood_connect/core/config/theme/app_typography.dart';
import 'package:blood_connect/core/config/router/app_routes.dart';
import 'package:blood_connect/features/authentication/domain/domain_export.dart';
import 'package:blood_connect/features/blood_request/domain/domain_export.dart';
import 'package:blood_connect/features/blood_request/data/models/blood_request_response.dart';
import 'package:blood_connect/shared/widgets/loading_widget.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  String _selectedBloodTypeFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 20 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 20 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final exploreState = ref.watch(exploreNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                ref.read(profileNotifierProvider.notifier).refreshProfile(),
                ref.read(exploreNotifierProvider.notifier).getAvailableRequests(),
              ]);
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _buildSliverAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildWelcomeSection(profileState),
                        const SizedBox(height: 32),
                        _buildHorizontalActivityCards(exploreState),
                        const SizedBox(height: 32),
                        _buildStatisticsSection(profileState),
                        const SizedBox(height: 32),
                        _buildRecentRequestsSection(exploreState),
                        const SizedBox(height: 100), // Padding for bottom FAB
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Main CTA Button
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                context.push(AppRoutes.createBloodRequest);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                shadowColor: AppColors.primary.withOpacity(0.4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Buat Permintaan Darah Baru',
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: _isScrolled ? 4 : 0,
      backgroundColor: AppColors.surface.withOpacity(0.9),
      surfaceTintColor: Colors.transparent,
      titleSpacing: 16,
      title: Row(
        children: [
          Icon(Icons.water_drop, color: AppColors.primary, size: 28),
          const SizedBox(width: 8),
          Text(
            'BloodConnect',
            style: AppTypography.headlineLargeMobile.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: AppColors.onSurfaceVariant),
          onPressed: () {},
        ),
        Container(
          margin: const EdgeInsets.only(right: 16, left: 8),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.outlineVariant, width: 2),
            image: const DecorationImage(
              image: NetworkImage('https://www.gstatic.com/labs-code/stitch/stitch-placeholder-300x300.svg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(AsyncValue profileState) {
    return profileState.when(
      data: (profile) {
        final firstName = profile?.fullName.split(' ').first ?? 'Pengguna';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, $firstName',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Bantu menyelamatkan nyawa dengan berbagi darah',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        );
      },
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoading(width: 150, height: 36, borderRadius: BorderRadius.circular(8)),
          const SizedBox(height: 8),
          ShimmerLoading(width: 250, height: 20, borderRadius: BorderRadius.circular(8)),
        ],
      ),
      error: (_, __) => Text('Halo', style: AppTypography.headlineLargeMobile),
    );
  }

  Widget _buildHorizontalActivityCards(AsyncValue<List<BloodRequestListResponse>> exploreState) {
    return exploreState.when(
      data: (requests) {
        final urgentCount = requests.where((r) => r.urgency == 'Critical' || r.urgency == 'High').length;
        
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              // Urgent or Safe Card
              if (urgentCount > 0)
                Container(
                  width: 320,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.favorite, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'MENDESAK!',
                            style: AppTypography.labelLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Saat ini ada $urgentCount permintaan darah kritis di dekat Anda.',
                        style: AppTypography.bodyLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                           context.go('${AppRoutes.main}/${AppRoutes.explore}');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFE53935),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Text('Lihat Semua', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  width: 320,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.blue.shade700, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'SEMUA AMAN!',
                            style: AppTypography.labelLarge.copyWith(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tidak ada permintaan darah kritis di sekitar Anda saat ini.',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                           context.go('${AppRoutes.main}/${AppRoutes.explore}');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Text('Jelajahi Permintaan', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 16),
              // Active Card
              Container(
                width: 320,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.group, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'SIAP DONOR?',
                          style: AppTypography.labelLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${requests.length} orang sedang membutuhkan darah hari ini.',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.go('${AppRoutes.main}/${AppRoutes.explore}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text('Cari Golongan Darah', style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Row(
        children: [
          ShimmerLoading(width: 320, height: 180, borderRadius: BorderRadius.circular(12)),
          const SizedBox(width: 16),
          ShimmerLoading(width: 320, height: 180, borderRadius: BorderRadius.circular(12)),
        ],
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatisticsSection(AsyncValue profileState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistik Anda',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        profileState.when(
          data: (profile) {
            String lastDonorText = '-';
            if (profile?.lastDonorDate != null) {
               lastDonorText = DateFormat('dd MMM yyyy').format(profile!.lastDonorDate!);
            }

            return Row(
              children: [
                Expanded(
                  child: _buildStatBox(
                    label: 'TOTAL DONOR',
                    value: '0', // TODO: From real history when supported
                    icon: Icons.water_drop,
                    iconColor: AppColors.primary,
                    iconBgColor: AppColors.primary.withOpacity(0.1),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatBox(
                    label: 'TERAKHIR DONOR',
                    value: lastDonorText,
                    icon: Icons.calendar_month,
                    iconColor: AppColors.secondary,
                    iconBgColor: AppColors.secondary.withOpacity(0.1),
                  ),
                ),
              ],
            );
          },
          loading: () => Row(
            children: [
              Expanded(child: ShimmerLoading(width: double.infinity, height: 120, borderRadius: BorderRadius.circular(12))),
              const SizedBox(width: 16),
              Expanded(child: ShimmerLoading(width: double.infinity, height: 120, borderRadius: BorderRadius.circular(12))),
            ],
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildStatBox({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRequestsSection(AsyncValue<List<BloodRequestListResponse>> exploreState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kebutuhan Darah Terkini',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // Quick Filters
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildBloodTypeFilter('Semua'),
            _buildBloodTypeFilter('A+'),
            _buildBloodTypeFilter('B+'),
            _buildBloodTypeFilter('O+'),
            _buildBloodTypeFilter('AB+'),
          ],
        ),
        const SizedBox(height: 16),
        exploreState.when(
          data: (requests) {
            final filteredRequests = _selectedBloodTypeFilter == 'Semua' 
              ? requests 
              : requests.where((r) => '${r.bloodType}${r.rhesus}' == _selectedBloodTypeFilter).toList();

            if (filteredRequests.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Belum ada kebutuhan ${_selectedBloodTypeFilter == "Semua" ? "" : "darah $_selectedBloodTypeFilter"} saat ini.', style: AppTypography.bodyMedium),
              );
            }
            final recentRequests = filteredRequests.take(3).toList();
            return Column(
              children: recentRequests.map((request) => _buildRequestListItem(request)).toList(),
            );
          },
          loading: () => Column(
            children: List.generate(3, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ShimmerLoading(width: double.infinity, height: 80, borderRadius: BorderRadius.circular(16)),
            )),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildBloodTypeFilter(String type) {
    final isSelected = _selectedBloodTypeFilter == type;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedBloodTypeFilter = type;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          type,
          style: AppTypography.labelLarge.copyWith(
            color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRequestListItem(BloodRequestListResponse request) {
    return GestureDetector(
      onTap: () => context.push('${AppRoutes.main}/${AppRoutes.bloodRequest}/${request.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${request.bloodType}${request.rhesus}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.location,
                    style: AppTypography.titleLarge.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${request.bagsNeeded} Kantong • ${request.urgency}',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
