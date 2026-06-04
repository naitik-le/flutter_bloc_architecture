import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A reusable network image widget that handles loading states, error states,
/// and placeholder styles consistently.
class CustomNetworkImage extends StatelessWidget {
  /// The URL of the image to load.
  final String imageUrl;

  /// How to fit the image into its constraints.
  final BoxFit fit;

  /// Width of the image.
  final double? width;

  /// Height of the image.
  final double? height;

  /// Size of the error icon.
  final double errorIconSize;

  /// Creates a [CustomNetworkImage].
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.errorIconSize = 64,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      progressIndicatorBuilder: (context, url, progress) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Center(
          child: Icon(
            Icons.rocket_launch_rounded,
            size: errorIconSize,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
