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
  static const String donorPost = 'donor-post';
  static const String explore = 'explore';
  static const String profile = 'profile';

  // Blood Request Routes
  static const String createBloodRequest = '$main/$bloodRequest/create';
  static const String bloodRequestDetail = '$main/$bloodRequest/detail/:id';

  // Donor Post Routes
  static const String createDonorPost = '$main/$donorPost/create';
  static const String donorPostDetail = '$main/$donorPost/detail/:id';

  // Other Routes
  static const String screening = '$main/screening/:id';
  static const String editProfile = '$main/edit-profile';
  static const String viewProfile = '$main/profile/:id';
}
