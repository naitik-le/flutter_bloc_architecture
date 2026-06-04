import 'package:flutter_bloc_architecture/core/config/app_config.dart';
import 'package:flutter_bloc_architecture/core/constants/api_constants.dart';

/// Centralized endpoint definitions for the API.
///
/// Constructs full URLs from [AppConfig.baseUrl] and endpoint paths.
class ApiEndpoints {
  ApiEndpoints._();

  /// Base URL from the current environment configuration.
  static String get baseUrl => AppConfig.baseUrl;

  // ── Auth ──

  /// Full login endpoint URL.
  static String get login => '$baseUrl${ApiConstants.login}';

  /// Full register endpoint URL.
  static String get register => '$baseUrl${ApiConstants.register}';

  /// Full forgot password endpoint URL.
  static String get forgotPassword => '$baseUrl${ApiConstants.forgotPassword}';

  /// Full logout endpoint URL.
  static String get logout => '$baseUrl${ApiConstants.logout}';

  /// Full refresh token endpoint URL.
  static String get refreshToken => '$baseUrl${ApiConstants.refreshToken}';

  // ── Users ──

  /// Full users list endpoint URL.
  static String get users => '$baseUrl${ApiConstants.users}';

  /// Full user profile endpoint URL.
  static String get profile => '$baseUrl${ApiConstants.profile}';

  /// User detail endpoint URL for the given [id].
  static String userById(int id) => '$baseUrl${ApiConstants.users}/$id';
}
