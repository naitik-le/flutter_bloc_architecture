import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';

/// A customizable loading indicator widget.
///
/// Displays a centered circular progress indicator with optional message.
class LoadingIndicator extends StatelessWidget {
  /// Optional loading message displayed below the spinner.
  final String? message;

  /// Size of the circular indicator.
  final double size;

  /// Color of the indicator. Defaults to primary.
  final Color? color;

  /// Creates a [LoadingIndicator].
  const LoadingIndicator({
    super.key,
    this.message,
    this.size = 36,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.primary,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
