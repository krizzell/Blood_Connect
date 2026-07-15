import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:blood_connect/core/config/theme/app_colors.dart';
import 'package:blood_connect/presentation/screens/blood_request/blood_request_screen.dart';
import 'package:blood_connect/presentation/screens/explore/explore_screen.dart';
import 'package:blood_connect/presentation/screens/home/home_screen.dart';
import 'package:blood_connect/presentation/screens/profile/profile_screen.dart';

final currentTabProvider = StateProvider<int>((ref) => 0);

class MainScaffold extends ConsumerWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentTab,
        children: const [
          HomeScreen(),
          ExploreScreen(), // Cari
          BloodRequestScreen(), // Aktivitas
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(context, ref, currentTab),
    );
  }

  Widget _buildBottomNavigation(
    BuildContext context,
    WidgetRef ref,
    int currentTab,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                ref,
                index: 0,
                currentTab: currentTab,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Beranda',
              ),
              _buildNavItem(
                ref,
                index: 1,
                currentTab: currentTab,
                icon: Icons.search_outlined,
                activeIcon: Icons.search,
                label: 'Cari',
              ),
              _buildNavItem(
                ref,
                index: 2,
                currentTab: currentTab,
                icon: Icons.analytics_outlined,
                activeIcon: Icons.analytics,
                label: 'Aktivitas',
              ),
              _buildNavItem(
                ref,
                index: 3,
                currentTab: currentTab,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    WidgetRef ref, {
    required int index,
    required int currentTab,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = currentTab == index;

    return GestureDetector(
      onTap: () {
        ref.read(currentTabProvider.notifier).state = index;
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.secondaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.onSecondaryContainer : AppColors.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Be Vietnam Pro',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.onSecondaryContainer : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
