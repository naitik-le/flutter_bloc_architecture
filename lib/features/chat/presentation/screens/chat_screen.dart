import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/core/theme/app_text_styles.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_app_bar.dart';

/// Chat screen placeholder.
///
/// TODO: Implement with feature-specific BLoC and data layers.
class ChatScreen extends StatelessWidget {
  /// Creates a [ChatScreen].
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Chat',
        showBackButton: false,
      ),
      body: Center(
        child: Text(
          'Chat Screen',
          style: AppTextStyles.headlineMedium,
        ),
      ),
    );
  }
}
