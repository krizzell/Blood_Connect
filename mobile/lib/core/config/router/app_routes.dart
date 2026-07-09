class AppRoutes {
  AppRoutes._();

  // Auth Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main Routes
  static const String main = '/main';
  static const String home = 'home';
  static const String bloodRequest = 'blood-request';
  static const String explore = 'explore';
  static const String profile = 'profile';

  // Feature Routes
  static const String bloodRequestDetail = 'detail/:id';
  static const String screening = 'screening/:id';
  static const String createRequest = 'create-request';
  static const String editProfile = 'edit-profile';
  static const String viewProfile = 'profile/:id';
}
