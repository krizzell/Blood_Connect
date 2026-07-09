import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_connect/presentation/screens/splash_screen.dart';
import 'package:blood_connect/presentation/screens/main_scaffold.dart';
import 'package:blood_connect/presentation/screens/home/home_screen.dart';
import 'package:blood_connect/presentation/screens/blood_request/blood_request_screen.dart';
import 'package:blood_connect/presentation/screens/explore/explore_screen.dart';
import 'package:blood_connect/presentation/screens/profile/profile_screen.dart';
import 'package:blood_connect/features/authentication/presentation/pages/login_screen.dart';
import 'package:blood_connect/features/authentication/presentation/pages/register_screen.dart';
import 'package:blood_connect/features/authentication/domain/domain_export.dart';
import 'app_routes.dart';

final routerProvider = Provider((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.main, // TODO: Change to AppRoutes.splash after testing
    redirect: (context, state) {
      // TODO: Uncomment redirect logic after testing register/login flow
      // If we're on the splash screen, don't redirect
      // if (state.matchedLocation == AppRoutes.splash) {
      //   return null;
      // }

      // Check auth state
      // return authState.when(
      //   initial: () => AppRoutes.splash,
      //   loading: () => null,
      //   authenticated: (_, __) {
      //     // If user is authenticated and tries to access auth routes, redirect to main
      //     if (state.matchedLocation == AppRoutes.login ||
      //         state.matchedLocation == AppRoutes.register ||
      //         state.matchedLocation == AppRoutes.forgotPassword) {
      //       return AppRoutes.main;
      //     }
      //     return null;
      //   },
      //   registrationSuccess: () {
      //     // Allow user to see success message and navigate to login
      //     if (state.matchedLocation == AppRoutes.register) {
      //       return null; // Stay on register screen for now
      //     }
      //     return null;
      //   },
      //   unauthenticated: () {
      //     // If user is not authenticated and tries to access protected routes, redirect to login
      //     if (state.matchedLocation == AppRoutes.main ||
      //         state.matchedLocation.startsWith(AppRoutes.main)) {
      //       return AppRoutes.login;
      //     }
      //     return null;
      //   },
      //   error: (_) {
      //     // On error, redirect to login
      //     if (state.matchedLocation != AppRoutes.login &&
      //         state.matchedLocation != AppRoutes.register) {
      //       return AppRoutes.login;
      //     }
      //     return null;
      //   },
      // );
      
      // Redirect logic disabled for testing - allows direct access to all routes
      return null;
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
