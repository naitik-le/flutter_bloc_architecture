import 'package:flutter/material.dart';
import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';
import 'package:flutter_bloc_architecture/core/theme/app_radius.dart';
import 'package:flutter_bloc_architecture/core/theme/app_spacing.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_network_image.dart';
import 'package:flutter_bloc_architecture/features/home/data/models/launch_model.dart';
import 'package:flutter_bloc_architecture/routes/app_routes.dart';

class LaunchCard extends StatelessWidget {
  final LaunchModel launch;

  const LaunchCard({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.circularMd),
      elevation: 0,
      color: theme.colorScheme.surface,
      child: InkWell(
        borderRadius: AppRadius.circularMd,
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.launchDetail,
            arguments: launch,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Mission patch
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: AppRadius.circularMd,
                ),
                child: launch.patchSmall != null
                    ? ClipRRect(
                        borderRadius: AppRadius.circularMd,
                        child: CustomNetworkImage(
                          imageUrl: launch.patchSmall!,
                          errorIconSize: 28,
                        ),
                      )
                    : const Icon(Icons.rocket_launch_rounded, size: 28),
              ),

              const SizedBox(width: AppSpacing.sm),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            launch.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        _buildStatusIcon(context),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxxs),
                    Text(
                      'Flight #${launch.flightNumber} · ${_formatDate(launch.dateUtc)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (launch.details != null &&
                        launch.details!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xxs),
                      Text(
                        launch.details!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.xs),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(BuildContext context) {
    if (launch.upcoming) {
      return const Icon(Icons.hourglass_top_rounded,
          size: 18, color: AppColors.info,);
    } else if (launch.success == true) {
      return const Icon(
        Icons.check_circle_rounded,
        size: 18,
        color: AppColors.success,
      );
    } else if (launch.success == false) {
      return const Icon(Icons.cancel_rounded, size: 18, color: AppColors.error);
    } else {
      return const Icon(
        Icons.help_outline_rounded,
        size: 18,
        color: AppColors.warning,
      );
    }
  }

  String _formatDate(String dateUtc) {
    try {
      final dt = DateTime.parse(dateUtc);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return dateUtc;
    }
  }
}
