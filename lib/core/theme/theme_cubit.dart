import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_architecture/core/storage/local_storage_service.dart';
import 'package:get_it/get_it.dart';

/// Cubit for managing the dynamic application theme (Light, Dark).
///
/// Loads preferences on initialization and persists modifications.
class ThemeCubit extends Cubit<ThemeMode> {
  final LocalStorageService _storage = GetIt.I<LocalStorageService>();
  static const String _themeKey = 'app_theme_mode';

  /// Creates a [ThemeCubit] and initializes the stored theme.
  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  void _loadTheme() {
    final savedTheme = _storage.getString(_themeKey);
    if (savedTheme == 'light') {
      emit(ThemeMode.light);
    } else if (savedTheme == 'dark') {
      emit(ThemeMode.dark);
    } else {
      emit(ThemeMode.system);
    }
  }

  /// Toggles the theme between Light and Dark mode.
  void toggleTheme() {
    final nextMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    setThemeMode(nextMode);
  }

  /// Explicitly sets the [ThemeMode] and stores the preference.
  Future<void> setThemeMode(ThemeMode mode) async {
    emit(mode);
    String modeString = 'system';
    if (mode == ThemeMode.light) {
      modeString = 'light';
    } else if (mode == ThemeMode.dark) {
      modeString = 'dark';
    }
    await _storage.setString(_themeKey, modeString);
  }
}
