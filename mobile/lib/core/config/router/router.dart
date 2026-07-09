import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_connect/presentation/screens/splash_screen.dart';
import 'package:blood_connect/presentation/screens/main_scaffold.dart';
import 'package:blood_connect/presentation/screens/home/home_screen.dart';
import 'package:blood_connect/presentation/screens/blood_request/blood_request_screen.dart';
import 'package:blood_connect/presentation/screens/explore/explore_screen.dart';
import 'package:blood_connect/presentation/screens/profile/profile_screen.dart';
import 'app_routes.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Main Navigation
      GoRoute(
        path: AppRoutes.main,
        builder: (context, state) => const MainScaffold(),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.bloodRequest,
            builder: (context, state) => const BloodRequestScreen(),
          ),
          GoRoute(
            path: AppRoutes.explore,
            builder: (context, state) => const ExploreScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
