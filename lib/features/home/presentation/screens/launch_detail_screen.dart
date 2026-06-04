import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';
import 'package:flutter_bloc_architecture/core/theme/app_radius.dart';
import 'package:flutter_bloc_architecture/core/theme/app_spacing.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_app_bar.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_network_image.dart';
import 'package:flutter_bloc_architecture/core/widgets/detail_info_card.dart';
import 'package:flutter_bloc_architecture/core/widgets/status_badge.dart';
import 'package:flutter_bloc_architecture/features/home/data/models/launch_model.dart';

/// Detail screen for a SpaceX launch.
///
/// Displays mission patch, status badge, details, failure info, and links.
class LaunchDetailScreen extends StatelessWidget {
  /// The launch to display.
  final LaunchModel launch;

  /// Creates a [LaunchDetailScreen].
  const LaunchDetailScreen({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: launch.name),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md).copyWith(bottom: AppSpacing.xxl),
          child: Column(
            spacing: AppSpacing.xl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(context),
              _buildDetailsSection(context),
              _buildLinksSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          // Mission patch
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: launch.patchLarge != null
                ? CustomNetworkImage(
                    imageUrl: launch.patchLarge!,
                    errorIconSize: 64,
                  )
                : Icon(
                    Icons.rocket_launch_rounded,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Flight number
          Text(
            'Flight #${launch.flightNumber}',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          // Status badge
          _buildStatusBadge(context),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Launch Date
        DetailInfoCard(
          icon: Icons.calendar_today_rounded,
          label: 'Date',
          value: _formatDate(launch.dateUtc),
        ),

        const SizedBox(height: AppSpacing.xs),

        // Upcoming flag
        DetailInfoCard(
          icon: Icons.schedule_rounded,
          label: 'Status',
          value: launch.upcoming ? 'Upcoming' : 'Completed',
        ),

        // Details
        if (launch.details != null && launch.details!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Mission Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              borderRadius: AppRadius.circularMd,
            ),
            child: Text(
              launch.details!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
          ),
        ],

        // Failures
        if (launch.failures.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Failure Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...launch.failures.map((failure) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: AppSpacing.xs),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                borderRadius: AppRadius.circularMd,
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    failure.reason,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
                  ),
                  if (failure.time != null || failure.altitude != null)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Row(
                        children: [
                          if (failure.time != null) ...[
                            Icon(
                              Icons.timer_rounded,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppSpacing.xxs),
                            Text(
                              'T+${failure.time}s',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                          if (failure.time != null && failure.altitude != null) const SizedBox(width: AppSpacing.md),
                          if (failure.altitude != null) ...[
                            Icon(
                              Icons.flight_rounded,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppSpacing.xxs),
                            Text(
                              '${failure.altitude}km',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildLinksSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Links',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            if (launch.webcast != null)
              _buildLinkChip(
                context,
                icon: Icons.play_circle_filled_rounded,
                label: 'YouTube',
                url: launch.webcast!,
                color: AppColors.error,
              ),
            if (launch.wikipedia != null)
              _buildLinkChip(
                context,
                icon: Icons.menu_book_rounded,
                label: 'Wikipedia',
                url: launch.wikipedia!,
                color: AppColors.info,
              ),
            if (launch.article != null)
              _buildLinkChip(
                context,
                icon: Icons.article_rounded,
                label: 'Article',
                url: launch.article!,
                color: AppColors.primary,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    if (launch.upcoming) {
      return const StatusBadge(
        label: 'Upcoming',
        color: AppColors.info,
        icon: Icons.hourglass_top_rounded,
      );
    } else if (launch.success == true) {
      return const StatusBadge(
        label: 'Success',
        color: AppColors.success,
        icon: Icons.check_circle_rounded,
      );
    } else if (launch.success == false) {
      return const StatusBadge(
        label: 'Failed',
        color: AppColors.error,
        icon: Icons.cancel_rounded,
      );
    } else {
      return const StatusBadge(
        label: 'Unknown',
        color: AppColors.warning,
        icon: Icons.help_outline_rounded,
      );
    }
  }

  Widget _buildLinkChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String url,
    required Color color,
  }) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: color),
      label: Text(label),
      onPressed: () => _launchUrl(url),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.circularFull,
      ),
    );
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
