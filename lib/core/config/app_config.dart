/// Environment-specific application configuration.
///
/// Supports multiple environments (dev, staging, prod) with different
/// base URLs, API keys, and feature flags. Initialize once at app startup.
///
/// Usage:
/// ```dart
/// AppConfig.init(
///   environment: Environment.dev,
///   appName: 'My App (Dev)',
///   baseUrl: 'https://api.example.com',
///   apiKey: 'your_api_key',
/// );
/// ```
class AppConfig {
  AppConfig._();

  static late Environment _environment;
  static late String _appName;
  static late String _baseUrl;
  static late String _apiKey;

  /// Initializes the app configuration for the given [environment].
  static void init({
    required Environment environment,
    required String appName,
    required String baseUrl,
    required String apiKey,
  }) {
    _environment = environment;
    _appName = appName;
    _baseUrl = baseUrl;
    _apiKey = apiKey;
  }

  /// Current environment.
  static Environment get environment => _environment;

  /// Application display name.
  static String get appName => _appName;

  /// Base URL for API calls.
  static String get baseUrl => _baseUrl;

  /// API key for authentication.
  static String get apiKey => _apiKey;

  /// Whether the app is running in debug mode.
  static bool get isDebug => _environment == Environment.dev;

  /// Whether the app is running in production mode.
  static bool get isProduction => _environment == Environment.prod;
}

/// Supported application environments.
enum Environment {
  /// Development environment.
  dev,

  /// Staging environment.
  staging,

  /// Production environment.
  prod,
}
