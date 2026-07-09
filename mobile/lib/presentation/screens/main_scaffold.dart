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
          BloodRequestScreen(),
          ExploreScreen(),
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
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                ref,
                0,
                currentTab,
                icon: Iconsax.home,
                label: 'Home',
              ),
              _buildNavItem(
                ref,
                1,
                currentTab,
                icon: Iconsax.heart,
                label: 'Blood Request',
              ),
              _buildNavItem(
                ref,
                2,
                currentTab,
                icon: Iconsax.search_normal,
                label: 'Explore',
              ),
              _buildNavItem(
                ref,
                3,
                currentTab,
                icon: Iconsax.profile_circle,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    WidgetRef ref,
    int index,
    int currentTab,
    {required IconData icon, required String label}
  ) {
    final isActive = currentTab == index;

    return GestureDetector(
      onTap: () {
        ref.read(currentTabProvider.notifier).state = index;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
