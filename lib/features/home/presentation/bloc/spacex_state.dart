part of 'spacex_bloc.dart';

/// State for the [SpacexBloc].
///
/// Uses a single-class pattern with status flags, matching the project's
/// [AuthState] convention.
class SpacexState extends Equatable {
  /// Whether rockets are currently loading.
  final bool isRocketsLoading;

  /// Whether the last rockets request failed.
  final bool isRocketsFailed;

  /// Error message from the last failed rockets request.
  final String? rocketsErrorMsg;

  /// Whether launches are currently loading.
  final bool isLaunchesLoading;

  /// Whether the last launches request failed.
  final bool isLaunchesFailed;

  /// Error message from the last failed launches request.
  final String? launchesErrorMsg;

  /// List of fetched rockets.
  final List<RocketModel> rockets;

  /// List of fetched launches.
  final List<LaunchModel> launches;

  /// Creates a [SpacexState].
  const SpacexState({
    this.isRocketsLoading = false,
    this.isRocketsFailed = false,
    this.rocketsErrorMsg,
    this.isLaunchesLoading = false,
    this.isLaunchesFailed = false,
    this.launchesErrorMsg,
    this.rockets = const [],
    this.launches = const [],
  });

  /// Creates a copy of this state with the given fields replaced.
  SpacexState copyWith({
    bool? isRocketsLoading,
    bool? isRocketsFailed,
    String? rocketsErrorMsg,
    bool? isLaunchesLoading,
    bool? isLaunchesFailed,
    String? launchesErrorMsg,
    List<RocketModel>? rockets,
    List<LaunchModel>? launches,
  }) {
    return SpacexState(
      isRocketsLoading: isRocketsLoading ?? this.isRocketsLoading,
      isRocketsFailed: isRocketsFailed ?? this.isRocketsFailed,
      rocketsErrorMsg: rocketsErrorMsg ?? this.rocketsErrorMsg,
      isLaunchesLoading: isLaunchesLoading ?? this.isLaunchesLoading,
      isLaunchesFailed: isLaunchesFailed ?? this.isLaunchesFailed,
      launchesErrorMsg: launchesErrorMsg ?? this.launchesErrorMsg,
      rockets: rockets ?? this.rockets,
      launches: launches ?? this.launches,
    );
  }

  @override
  List<Object?> get props => [
        isRocketsLoading,
        isRocketsFailed,
        rocketsErrorMsg,
        isLaunchesLoading,
        isLaunchesFailed,
        launchesErrorMsg,
        rockets,
        launches,
      ];
}
