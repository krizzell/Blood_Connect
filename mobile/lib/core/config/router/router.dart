import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_connect/presentation/screens/splash_screen.dart';
import 'package:blood_connect/presentation/screens/main_scaffold.dart';
import 'package:blood_connect/presentation/screens/home/home_screen.dart';
import 'package:blood_connect/presentation/screens/blood_request/blood_request_screen.dart';
import 'package:blood_connect/presentation/screens/explore/explore_screen.dart';
import 'package:blood_connect/presentation/screens/profile/profile_screen.dart';
import 'package:blood_connect/features/blood_request/presentation/pages/create_blood_request_screen.dart';
import 'package:blood_connect/features/authentication/presentation/pages/login_screen.dart';
import 'package:blood_connect/features/authentication/presentation/pages/register_screen.dart';
import 'package:blood_connect/features/authentication/domain/domain_export.dart';
import 'package:blood_connect/features/blood_request/presentation/pages/blood_request_detail_screen.dart';
import 'package:blood_connect/features/donor_post/presentation/pages/create_donor_post_screen.dart';
import 'package:blood_connect/features/donor_post/presentation/pages/donor_post_detail_screen.dart';
import 'app_routes.dart';

/// Bridge between Riverpod auth state and GoRouter's refreshListenable.
/// This notifies GoRouter to re-evaluate redirects WITHOUT recreating the router.
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(Ref ref) {
    ref.listen(authNotifierProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authChangeNotifier = _AuthChangeNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: authChangeNotifier,
    redirect: (context, state) {
      // Read current auth state (not watch — GoRouter is created once)
      final authState = ref.read(authNotifierProvider);
      final location = state.uri.path;

      // Never redirect splash screen
      if (location == AppRoutes.splash) {
        return null;
      }

      return authState.when(
        // Initial state: show splash
        initial: () {
          if (location != AppRoutes.splash) {
            return AppRoutes.splash;
          }
          return null;
        },
        
        // Loading state: stay on current page
        loading: () => null,
        
        // Authenticated: allow main, redirect auth routes to main
        authenticated: (_, __) {
          if (location == AppRoutes.login ||
              location == AppRoutes.register ||
              location == AppRoutes.forgotPassword) {
            return AppRoutes.main;
          }
          return null;
        },
        
        // Registration success: allow register page and login page
        registrationSuccess: () {
          // Can be on register or navigate to login
          if (location == AppRoutes.login || location == AppRoutes.register) {
            return null;
          }
          // Anything else redirect to login
          if (location != AppRoutes.main &&
              !location.startsWith(AppRoutes.main)) {
            return AppRoutes.login;
          }
          return null;
        },
        
        // Unauthenticated: allow auth routes, redirect main to login
        unauthenticated: () {
          if (location == AppRoutes.main ||
              location.startsWith(AppRoutes.main)) {
            return AppRoutes.login;
          }
          // Allow login, register, forgot password
          if (location == AppRoutes.login ||
              location == AppRoutes.register ||
              location == AppRoutes.forgotPassword) {
            return null;
          }
          return null;
        },
        
        // Error state: stay on current auth page (login/register)
        error: (_) {
          if (location != AppRoutes.login &&
              location != AppRoutes.register) {
            return AppRoutes.login;
          }
          return null;
        },
      );
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Forgot Password - Coming Soon'),
          ),
        ),
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
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const CreateBloodRequestScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => BloodRequestDetailScreen(
                  id: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.donorPost,
            builder: (context, state) => const Scaffold(),
            routes: [
              GoRoute(
                path: 'create',
                builder: (context, state) => const CreateDonorPostScreen(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => DonorPostDetailScreen(
                  id: state.pathParameters['id']!,
                ),
              ),
            ],
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
