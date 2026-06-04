import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/app.dart';
import 'package:flutter_bloc_architecture/core/config/app_config.dart';
import 'package:flutter_bloc_architecture/core/di/injection.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';
import 'package:flutter_bloc_architecture/core/utils/app_logger.dart';

/// Production environment entry point.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Initialize App Config ──
  AppConfig.init(
    environment: Environment.prod,
    appName: 'Flutter BLoC Architecture',
    baseUrl: 'https://your-production-api.com/api',
    apiKey: 'your_production_api_key',
  );

  AppLogger.info('🚀 Starting app in PRODUCTION mode');

  // ── Initialize Typography ──
  AppTextStyles.init();

  // ── Setup Dependencies ──
  await setupDependencies();

  // ── Run App ──
  runApp(const App());
}
