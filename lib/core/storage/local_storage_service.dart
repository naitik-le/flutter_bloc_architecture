import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper around [SharedPreferences] for local key-value storage.
///
/// Provides a clean API for storing and retrieving simple data types
/// (strings, booleans, integers, doubles) in local persistent storage.
class LocalStorageService {
  final SharedPreferences _prefs;

  /// Creates a [LocalStorageService] with the given [SharedPreferences] instance.
  LocalStorageService(this._prefs);

  /// Retrieves a string value for the given [key], or `null` if not found.
  String? getString(String key) => _prefs.getString(key);

  /// Stores a [value] string for the given [key].
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  /// Retrieves a boolean value for the given [key], or `null` if not found.
  bool? getBool(String key) => _prefs.getBool(key);

  /// Stores a [value] boolean for the given [key].
  Future<bool> setBool(String key, {required bool value}) =>
      _prefs.setBool(key, value);

  /// Retrieves an integer value for the given [key], or `null` if not found.
  int? getInt(String key) => _prefs.getInt(key);

  /// Stores a [value] integer for the given [key].
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  /// Retrieves a double value for the given [key], or `null` if not found.
  double? getDouble(String key) => _prefs.getDouble(key);

  /// Stores a [value] double for the given [key].
  Future<bool> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);

  /// Removes the value associated with the given [key].
  Future<bool> remove(String key) => _prefs.remove(key);

  /// Clears all stored preferences.
  Future<bool> clear() => _prefs.clear();

  /// Checks if a value exists for the given [key].
  bool containsKey(String key) => _prefs.containsKey(key);
}
