/// Centralized storage key constants.
///
/// Keeps all key strings for LocalStorageService and SecureStorageService in one place.
class StorageConstants {
  StorageConstants._();

  /// Key for storing the authentication token.
  static const String token = 'auth_token';

  /// Key for checking if the user is logged in.
  static const String isLoggedIn = 'is_logged_in';
}
