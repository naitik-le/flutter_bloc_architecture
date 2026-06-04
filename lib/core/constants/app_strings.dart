/// Centralized string constants used throughout the application.
///
/// Eliminates hardcoded strings and ensures consistency across the app.
/// All user-facing strings should be defined here or in localization files.
class AppStrings {
  AppStrings._();

  // ── App Info ──

  /// Application display name.
  static const String appName = 'Flutter BLoC Architecture';

  // ── Auth Strings ──

  /// Login screen title.
  static const String login = 'Login';

  /// Register screen title.
  static const String register = 'Register';

  /// Forgot password prompt.
  static const String forgotPassword = 'Forgot Password?';

  /// Email field label.
  static const String email = 'Email';

  /// Password field label.
  static const String password = 'Password';

  /// Confirm password field label.
  static const String confirmPassword = 'Confirm Password';

  /// Full name field label.
  static const String fullName = 'Full Name';

  /// Login button text.
  static const String loginButton = 'Sign In';

  /// Register button text.
  static const String registerButton = 'Create Account';

  /// Don't have account prompt.
  static const String noAccount = "Don't have an account? ";

  /// Already have account prompt.
  static const String haveAccount = 'Already have an account? ';

  // ── General Strings ──

  /// Generic error message.
  static const String somethingWentWrong = 'Something went wrong';

  /// No internet connection message.
  static const String noInternet = 'No internet connection';

  /// Retry button text.
  static const String retry = 'Retry';

  /// Cancel button text.
  static const String cancel = 'Cancel';

  /// OK button text.
  static const String ok = 'OK';

  /// Save button text.
  static const String save = 'Save';

  /// Loading message.
  static const String loading = 'Loading...';

  /// Success message.
  static const String success = 'Success';

  /// Back online message.
  static const String backOnline = 'Back online';
}
