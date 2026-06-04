part of 'spacex_bloc.dart';

/// State for the [SpacexBloc].
///
/// Uses a single-class pattern with status flags, matching the project's
/// [AuthState] convention.
class SpacexState extends Equatable {
  /// Whether a network request is in progress.
  final bool isLoading;

  /// Whether the last request failed.
  final bool isFailed;

  /// Error message from the last failed request.
  final String? errorMsg;

  /// List of fetched rockets.
  final List<RocketModel> rockets;

  /// List of fetched launches.
  final List<LaunchModel> launches;

  /// Creates a [SpacexState].
  const SpacexState({
    this.isLoading = false,
    this.isFailed = false,
    this.errorMsg,
    this.rockets = const [],
    this.launches = const [],
  });

  /// Creates a copy of this state with the given fields replaced.
  SpacexState copyWith({
    bool? isLoading,
    bool? isFailed,
    String? errorMsg,
    List<RocketModel>? rockets,
    List<LaunchModel>? launches,
  }) {
    return SpacexState(
      isLoading: isLoading ?? this.isLoading,
      isFailed: isFailed ?? this.isFailed,
      errorMsg: errorMsg ?? this.errorMsg,
      rockets: rockets ?? this.rockets,
      launches: launches ?? this.launches,
    );
  }

  @override
  List<Object?> get props => [isLoading, isFailed, errorMsg, rockets, launches];
}
