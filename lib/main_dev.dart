import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/app.dart';
import 'package:flutter_bloc_architecture/core/config/app_config.dart';
import 'package:flutter_bloc_architecture/core/di/injection.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';
import 'package:flutter_bloc_architecture/core/utils/app_logger.dart';

/// Development environment entry point.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Initialize App Config ──
  AppConfig.init(
    environment: Environment.dev,
    appName: 'Flutter BLoC Arch (Dev)',
    baseUrl: 'https://reqres.in/api',
    apiKey: 'reqres_2d6ae74eba434b03839c422d65eff92a',
  );

  AppLogger.info('🚀 Starting app in DEV mode');

  // ── Initialize Typography ──
  AppTextStyles.init();

  // ── Setup Dependencies ──
  await setupDependencies();

  // ── Run App ──
  runApp(const App());
}
