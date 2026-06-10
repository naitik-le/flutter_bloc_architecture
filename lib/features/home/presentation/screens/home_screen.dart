import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_bloc_architecture/core/theme/app_colors.dart';
import 'package:flutter_bloc_architecture/core/theme/app_spacing.dart';
import 'package:flutter_bloc_architecture/core/widgets/app_error_widget.dart';
import 'package:flutter_bloc_architecture/core/widgets/custom_app_bar.dart';
import 'package:flutter_bloc_architecture/core/widgets/loading_indicator.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/bloc/spacex_bloc.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/widgets/launch_card.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/widgets/rocket_card.dart';

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
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurfaceVariant,
            labelStyle: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
            tabs: const [
              Tab(
                icon: Icon(Icons.rocket_launch_rounded, size: 20),
                text: 'Rockets',
              ),
              Tab(
                icon: Icon(Icons.flight_takeoff_rounded, size: 20),
                text: 'Launches',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRocketsTab(context),
            _buildLaunchesTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRocketsTab(BuildContext context) {
    return BlocBuilder<SpacexBloc, SpacexState>(
      buildWhen: (previous, current) =>
          previous.isRocketsLoading != current.isRocketsLoading ||
          previous.isRocketsFailed != current.isRocketsFailed ||
          previous.rocketsErrorMsg != current.rocketsErrorMsg ||
          previous.rockets != current.rockets,
      builder: (context, state) {
        if (state.isRocketsLoading && state.rockets.isEmpty) {
          return const LoadingIndicator(message: 'Loading rockets...');
        }

        if (state.isRocketsFailed && state.rockets.isEmpty) {
          return AppErrorWidget(
            message: state.rocketsErrorMsg ?? 'Failed to load rockets',
            onRetry: () =>
                context.read<SpacexBloc>().add(const FetchRocketsEvent()),
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
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            itemCount: state.rockets.length,
            itemBuilder: (context, index) {
              return RocketCard(rocket: state.rockets[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildLaunchesTab(BuildContext context) {
    return BlocBuilder<SpacexBloc, SpacexState>(
      buildWhen: (previous, current) =>
          previous.isLaunchesLoading != current.isLaunchesLoading ||
          previous.isLaunchesFailed != current.isLaunchesFailed ||
          previous.launchesErrorMsg != current.launchesErrorMsg ||
          previous.launches != current.launches,
      builder: (context, state) {
        if (state.isLaunchesLoading && state.launches.isEmpty) {
          return const LoadingIndicator(message: 'Loading launches...');
        }

        if (state.isLaunchesFailed && state.launches.isEmpty) {
          return AppErrorWidget(
            message: state.launchesErrorMsg ?? 'Failed to load launches',
            onRetry: () =>
                context.read<SpacexBloc>().add(const FetchLaunchesEvent()),
          );
        }

        if (state.launches.isEmpty) {
          return const Center(child: Text('No launches found'));
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<SpacexBloc>().add(const FetchLaunchesEvent());
          },
          color: AppColors.secondary,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md).copyWith(bottom: 80),
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            itemCount: state.launches.length,
            itemBuilder: (context, index) {
              return LaunchCard(launch: state.launches[index]);
            },
          ),
        );
      },
    );
  }
}
