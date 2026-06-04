import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_app_bar.dart';

/// Profile screen placeholder.
///
/// TODO: Implement with feature-specific BLoC and data layers.
class ProfileScreen extends StatelessWidget {
  /// Creates a [ProfileScreen].
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Profile',
        showBackButton: false,
      ),
      body: Center(
        child: Text(
          'Profile Screen',
          style: AppTextStyles.headlineMedium,
        ),
      ),
    );
  }
}
