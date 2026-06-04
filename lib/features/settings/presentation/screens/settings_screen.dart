import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_app_bar.dart';

/// Settings screen placeholder.
///
/// TODO: Implement with feature-specific BLoC and data layers.
class SettingsScreen extends StatelessWidget {
  /// Creates a [SettingsScreen].
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
      ),
      body: Center(
        child: Text(
          'Settings Screen',
          style: AppTextStyles.headlineMedium,
        ),
      ),
    );
  }
}
