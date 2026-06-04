/// Centralized static route name constants.
///
/// All named routes are defined here to avoid scattered string literals.
/// Use with [Navigator.pushNamed] for centralized navigation.
class Routes {
  Routes._();

  // ── Auth Route Constants ──

  /// Root/splash route path.
  static const String splash = '/splash';

  /// Login screen route path.
  static const String login = '/login';

  /// Register screen route path.
  static const String register = '/register';

  /// Forgot password screen route path.
  static const String forgotPassword = '/forgot-password';

  /// OTP verification screen route path.
  static const String otpVerification = '/otp-verification';

  // ── Main Route Constants ──

  /// Primary dashboard/home screen route path.
  static const String dashboard = '/dashboard';

  /// Profile view screen route path.
  static const String profile = '/profile';

  /// Edit profile form screen route path.
  static const String editProfile = '/edit-profile';

  /// Chat screen route path.
  static const String chat = '/chat';

  /// Settings screen route path.
  static const String settings = '/settings';

  // ── SpaceX Route Constants ──

  /// Rocket detail screen route path.
  static const String rocketDetail = '/rocket-detail';

  /// Launch detail screen route path.
  static const String launchDetail = '/launch-detail';
}
