part of 'spacex_bloc.dart';

/// Events for the [SpacexBloc].
@immutable
abstract class SpacexEvent {
  /// Creates a [SpacexEvent].
  const SpacexEvent();
}

/// Requests fetching of all SpaceX rockets.
class FetchRocketsEvent extends SpacexEvent {
  /// Creates a [FetchRocketsEvent].
  const FetchRocketsEvent();
}

/// Requests fetching of all SpaceX launches.
class FetchLaunchesEvent extends SpacexEvent {
  /// Creates a [FetchLaunchesEvent].
  const FetchLaunchesEvent();
}
