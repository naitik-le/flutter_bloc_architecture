import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_architecture/core/theme/app_dimensions.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/bloc/carousel_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';
import 'package:flutter_bloc_architecture/core/theme/app_radius.dart';
import 'package:flutter_bloc_architecture/core/theme/app_spacing.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_app_bar.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_network_image.dart';
import 'package:flutter_bloc_architecture/core/widgets/detail_info_card.dart';
import 'package:flutter_bloc_architecture/core/widgets/status_badge.dart';
import 'package:flutter_bloc_architecture/features/home/data/models/rocket_model.dart';

/// Detail screen for a SpaceX rocket.
///
/// Displays images, specifications, description, and a Wikipedia link.
class RocketDetailScreen extends StatelessWidget {
  final RocketModel rocket;

  const RocketDetailScreen({super.key, required this.rocket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: rocket.name),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md).copyWith(bottom: AppSpacing.xxl),
              child: Column(
                spacing: AppSpacing.xl,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(context),
                  _buildSpecificationsSection(context),
                  _buildDetailsSection(context),
                  _buildWikipediaSection(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    if (rocket.flickrImages.isEmpty) return const SizedBox.shrink();

    return BlocBuilder<CarouselCubit, int>(
      builder: (context, activeIndex) {
        return SizedBox(
          height: AppDimensions.carouselHeight(context),
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                itemCount: rocket.flickrImages.length,
                onPageChanged: context.read<CarouselCubit>().onPageChanged,
                itemBuilder: (context, index) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CustomNetworkImage(
                        imageUrl: rocket.flickrImages[index],
                        errorIconSize: 64,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.black.withValues(alpha: 0.6),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              // Image counter
              if (rocket.flickrImages.length > 1)
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      rocket.flickrImages.length,
                      (dotIndex) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: dotIndex == activeIndex ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: dotIndex == activeIndex ? AppColors.white : AppColors.white.withValues(alpha: 0.4),
                          borderRadius: AppRadius.circularFull,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            StatusBadge(
              label: rocket.active ? 'Active' : 'Retired',
              color: rocket.active ? AppColors.success : AppColors.error,
              icon: rocket.active ? Icons.check_circle_rounded : Icons.cancel_rounded,
            ),
            const SizedBox(width: AppSpacing.xs),
            StatusBadge(
              label: '${rocket.successRatePct}% success',
              color: AppColors.info,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          rocket.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecificationsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specifications',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildSpecsGrid(context),
      ],
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSpacing.sm),
        DetailInfoCard(
          icon: Icons.public_rounded,
          label: 'Country',
          value: rocket.country,
        ),
        const SizedBox(height: AppSpacing.xs),
        DetailInfoCard(
          icon: Icons.business_rounded,
          label: 'Company',
          value: rocket.company,
        ),
        const SizedBox(height: AppSpacing.xs),
        DetailInfoCard(
          icon: Icons.calendar_today_rounded,
          label: 'First Flight',
          value: rocket.firstFlight,
        ),
        const SizedBox(height: AppSpacing.xs),
        DetailInfoCard(
          icon: Icons.attach_money_rounded,
          label: 'Cost Per Launch',
          value: '\$${(rocket.costPerLaunch / 1000000).toStringAsFixed(1)}M',
        ),
      ],
    );
  }

  Widget _buildWikipediaSection(BuildContext context) {
    if (rocket.wikipedia.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _launchUrl(rocket.wikipedia),
        icon: const Icon(Icons.open_in_new_rounded, size: 18),
        label: const Text('View on Wikipedia'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.circularMd,
          ),
        ),
      ),
    );
  }

  Widget _buildSpecsGrid(BuildContext context) {
    final specs = [
      _SpecItem(
        icon: Icons.height_rounded,
        label: 'Height',
        value: '${rocket.heightMeters}m',
      ),
      _SpecItem(
        icon: Icons.straighten_rounded,
        label: 'Diameter',
        value: '${rocket.diameterMeters}m',
      ),
      _SpecItem(
        icon: Icons.fitness_center_rounded,
        label: 'Mass',
        value: '${(rocket.massKg / 1000).toStringAsFixed(0)}t',
      ),
      _SpecItem(
        icon: Icons.layers_rounded,
        label: 'Stages',
        value: '${rocket.stages}',
      ),
      _SpecItem(
        icon: Icons.local_fire_department_rounded,
        label: 'Engines',
        value: '${rocket.enginesCount}× ${rocket.engineType}',
      ),
      _SpecItem(
        icon: Icons.rocket_rounded,
        label: 'Boosters',
        value: '${rocket.boosters}',
      ),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - (AppSpacing.md * 2) - (AppSpacing.xs * 2)) / 3;

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: specs.map((spec) {
        final theme = Theme.of(context);
        return Container(
          width: itemWidth,
          height: itemWidth / 1.1,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            border: Border.all(
              color: theme.dividerTheme.color ?? AppColors.dividerLight,
            ),
            borderRadius: AppRadius.circularMd,
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                spec.icon,
                size: 22,
                color: AppColors.secondary,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                spec.value,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xxxs),
              Text(
                spec.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SpecItem {
  final IconData icon;
  final String label;
  final String value;

  const _SpecItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}
