import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_network_image.dart';

import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';
import 'package:flutter_bloc_architecture/core/theme/app_radius.dart';
import 'package:flutter_bloc_architecture/core/theme/app_spacing.dart';
import 'package:flutter_bloc_architecture/core/widgets/app_error_widget.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_app_bar.dart';
import 'package:flutter_bloc_architecture/core/widgets/loading_indicator.dart';
import 'package:flutter_bloc_architecture/features/home/data/models/launch_model.dart';
import 'package:flutter_bloc_architecture/features/home/data/models/rocket_model.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/bloc/spacex_bloc.dart';
import 'package:flutter_bloc_architecture/routes/app_routes.dart';

/// Home screen displaying SpaceX rockets and launches in a tabbed layout.
///
/// Data is fetched via [SpacexBloc] and displayed using [BlocBuilder].
class HomeScreen extends StatefulWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch both fetch events on screen initialization
    final bloc = context.read<SpacexBloc>();
    bloc.add(const FetchRocketsEvent());
    bloc.add(const FetchLaunchesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'SpaceX Explorer',
          showBackButton: false,
          bottom: TabBar(
            indicatorColor: AppColors.secondary,
            indicatorWeight: 3,
            labelColor: Theme.of(context).colorScheme.onSurface,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(
                icon: Icon(Icons.rocket_launch_rounded, size: 20),
                text: 'Rockets 1',
              ),
              Tab(
                icon: Icon(Icons.flight_takeoff_rounded, size: 20),
                text: 'Launches 2',
              ),
            ],
          ),
        ),
        body: BlocBuilder<SpacexBloc, SpacexState>(
          builder: (context, state) {
            return TabBarView(
              children: [
                _buildRocketsTab(context, state),
                _buildLaunchesTab(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRocketsTab(BuildContext context, SpacexState state) {
    if (state.isLoading && state.rockets.isEmpty) {
      return const LoadingIndicator(message: 'Loading rockets...');
    }

    if (state.isFailed && state.rockets.isEmpty) {
      return AppErrorWidget(
        message: state.errorMsg ?? 'Failed to load rockets',
        onRetry: () => context.read<SpacexBloc>().add(const FetchRocketsEvent()),
      );
    }

    if (state.rockets.isEmpty) {
      return const Center(child: Text('No rockets found'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<SpacexBloc>().add(const FetchRocketsEvent());
      },
      color: AppColors.secondary,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md).copyWith(bottom: 80),
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: state.rockets.length,
        itemBuilder: (context, index) {
          return _RocketCard(rocket: state.rockets[index]);
        },
      ),
    );
  }

  Widget _buildLaunchesTab(BuildContext context, SpacexState state) {
    if (state.isLoading && state.launches.isEmpty) {
      return const LoadingIndicator(message: 'Loading launches...');
    }

    if (state.isFailed && state.launches.isEmpty) {
      return AppErrorWidget(
        message: state.errorMsg ?? 'Failed to load launches',
        onRetry: () => context.read<SpacexBloc>().add(const FetchLaunchesEvent()),
      );
    }

    if (state.launches.isEmpty) {
      return const Center(child: Text('No launches found'));
    }

    // Show launches in reverse chronological order (latest first)
    final sortedLaunches = List<LaunchModel>.from(state.launches)..sort((a, b) => b.dateUnix.compareTo(a.dateUnix));

    return RefreshIndicator(
      onRefresh: () async {
        context.read<SpacexBloc>().add(const FetchLaunchesEvent());
      },
      color: AppColors.secondary,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md).copyWith(bottom: 80),
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemCount: sortedLaunches.length,
        itemBuilder: (context, index) {
          return _LaunchCard(launch: sortedLaunches[index]);
        },
      ),
    );
  }
}

// ── Rocket Card ──

class _RocketCard extends StatelessWidget {
  final RocketModel rocket;

  const _RocketCard({required this.rocket});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.circularMd),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: theme.colorScheme.surface,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.rocketDetail,
            arguments: rocket,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rocket image
            if (rocket.flickrImages.isNotEmpty)
              SizedBox(
                height: 160,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomNetworkImage(
                      imageUrl: rocket.flickrImages.first,
                      errorIconSize: 48,
                    ),
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.black.withValues(alpha: 0.5),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Active/Retired badge
                    Positioned(
                      top: AppSpacing.xs,
                      right: AppSpacing.xs,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: AppSpacing.xxxs,
                        ),
                        decoration: BoxDecoration(
                          color: rocket.active ? AppColors.success.withValues(alpha: 0.9) : AppColors.error.withValues(alpha: 0.9),
                          borderRadius: AppRadius.circularFull,
                        ),
                        child: Text(
                          rocket.active ? 'Active' : 'Retired',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rocket.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    rocket.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Quick specs row
                  Row(
                    children: [
                      _buildSpecChip(
                        context,
                        Icons.local_fire_department_rounded,
                        '${rocket.enginesCount} engines',
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      _buildSpecChip(
                        context,
                        Icons.show_chart_rounded,
                        '${rocket.successRatePct}% success',
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecChip(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.secondary),
          const SizedBox(width: AppSpacing.xxs),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Launch Card ──

class _LaunchCard extends StatelessWidget {
  final LaunchModel launch;

  const _LaunchCard({required this.launch});

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
                    if (launch.details != null && launch.details!.isNotEmpty) ...[
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
      return const Icon(Icons.hourglass_top_rounded, size: 18, color: AppColors.info);
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
