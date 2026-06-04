import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wrapper around [FlutterSecureStorage] for sensitive data storage.
///
/// Use this for storing tokens, passwords, and other sensitive information
/// that requires encrypted storage on the device.
class SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  /// Key for storing the authentication token.
  static const String _tokenKey = 'auth_token';

  /// Key for storing the refresh token.
  static const String _refreshTokenKey = 'refresh_token';

  /// Key for storing the user ID.
  static const String _userIdKey = 'user_id';

  /// Creates a [SecureStorageService] with the given [FlutterSecureStorage].
  SecureStorageService(this._secureStorage);

  // ── Token Management ──

  /// Stores the authentication [token].
  Future<void> saveToken(String token) =>
      _secureStorage.write(key: _tokenKey, value: token);

  /// Retrieves the stored authentication token.
  Future<String?> getToken() => _secureStorage.read(key: _tokenKey);

  /// Removes the stored authentication token.
  Future<void> deleteToken() => _secureStorage.delete(key: _tokenKey);

  /// Stores the refresh [token].
  Future<void> saveRefreshToken(String token) =>
      _secureStorage.write(key: _refreshTokenKey, value: token);

  /// Retrieves the stored refresh token.
  Future<String?> getRefreshToken() =>
      _secureStorage.read(key: _refreshTokenKey);

  // ── User ID ──

  /// Stores the current [userId].
  Future<void> saveUserId(String userId) =>
      _secureStorage.write(key: _userIdKey, value: userId);

  /// Retrieves the stored user ID.
  Future<String?> getUserId() => _secureStorage.read(key: _userIdKey);

  // ── Generic Operations ──

  /// Writes a [value] for the given [key] to secure storage.
  Future<void> write(String key, String value) =>
      _secureStorage.write(key: key, value: value);

  /// Reads the value for the given [key] from secure storage.
  Future<String?> read(String key) => _secureStorage.read(key: key);

  /// Deletes the value for the given [key] from secure storage.
  Future<void> delete(String key) => _secureStorage.delete(key: key);

  /// Clears all values from secure storage.
  Future<void> clearAll() => _secureStorage.deleteAll();
}
