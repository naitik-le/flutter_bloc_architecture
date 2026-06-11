/// API-related constants including paths, timeouts, and headers.
///
/// Centralizes all API configuration to avoid scattered magic values.
class ApiConstants {
  ApiConstants._();

  // ── Timeouts ──

  /// Connection timeout in milliseconds.
  static const int connectionTimeout = 30000;

  /// Receive timeout in milliseconds.
  static const int receiveTimeout = 30000;

  /// Send timeout in milliseconds.
  static const int sendTimeout = 30000;

  // ── Headers ──

  /// Default content type for API requests.
  static const String contentType = 'application/json';

  /// Accept header value.
  static const String accept = 'application/json';

  // ── Auth Endpoints ──

  /// Login endpoint path.
  static const String login = '/login';

  /// Register endpoint path.
  static const String register = '/register';

  /// Forgot password endpoint path.
  static const String forgotPassword = '/forgot-password';

  /// Logout endpoint path.
  static const String logout = '/logout';

  /// Refresh token endpoint path.
  static const String refreshToken = '/refresh-token';

  // ── User Endpoints ──

  /// User list endpoint path.
  static const String users = '/users';

  /// User profile endpoint path.
  static const String profile = '/users/me';

  // ── SpaceX API ──

  /// SpaceX API base URL (separate from main app base URL).
  static const String spacexBaseUrl = 'https://api.spacexdata.com';

  /// SpaceX rockets list endpoint path.
  static const String spacexRockets = '/v5/rockets';

  /// SpaceX launches list endpoint path.
  static const String spacexLaunches = '/v5/launches';
}
