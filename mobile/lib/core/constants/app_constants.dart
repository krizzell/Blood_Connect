import 'package:blood_connect/core/config/env.dart';

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'BloodConnect';
  static const String appVersion = '1.0.0';

  // Network
  static const String apiBaseUrl = Env.apiBaseUrl;
  static const Duration apiTimeoutDuration = Duration(seconds: 30);

  // Storage Keys
  static const String tokenKey = 'jwt_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';



  // Pagination
  static const int pageSize = 20;
  static const int initialPage = 1;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Default Values
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 16.0;
  static const double cardBorderRadius = 20.0;
}

class AppDimensions {
  AppDimensions._();

  // Spacing System (4/8/16/24/32)
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;

  // Border Radius
  static const double borderRadius8 = 8.0;
  static const double borderRadius12 = 12.0;
  static const double borderRadius16 = 16.0;
  static const double borderRadius20 = 20.0;
  static const double borderRadius24 = 24.0;

  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;

  // Button Heights
  static const double buttonHeightSmall = 32.0;
  static const double buttonHeightMedium = 44.0;
  static const double buttonHeightLarge = 56.0;

  // Avatar Sizes
  static const double avatarSmall = 32.0;
  static const double avatarMedium = 48.0;
  static const double avatarLarge = 64.0;
}
