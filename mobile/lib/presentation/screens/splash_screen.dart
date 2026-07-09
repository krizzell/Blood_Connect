import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:blood_connect/core/config/theme/app_colors.dart';
import 'package:blood_connect/core/constants/app_constants.dart';
import 'package:blood_connect/core/config/router/app_routes.dart';
import 'package:blood_connect/features/authentication/domain/domain_export.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _checkAuthStatusAndNavigate();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  void _checkAuthStatusAndNavigate() {
    // Check authentication status
    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).checkAuthStatus();
    });

    // Navigate after delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted || _hasNavigated) {
        return;
      }

      _hasNavigated = true;
      
      // Route will be handled by the router based on auth state
      // The redirect logic in routerProvider will handle the navigation
      final authState = ref.read(authNotifierProvider);
      authState.whenOrNull(
        authenticated: (_, __) {
          context.go(AppRoutes.main);
        },
        unauthenticated: () {
          context.go(AppRoutes.login);
        },
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_hasNavigated) {
          return;
        }

        _hasNavigated = true;
        
        final authState = ref.read(authNotifierProvider);
        authState.whenOrNull(
          authenticated: (_, __) {
            context.go(AppRoutes.main);
          },
          unauthenticated: () {
            context.go(AppRoutes.login);
          },
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppConstants.appName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Connecting Blood Donors with Those in Need',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
