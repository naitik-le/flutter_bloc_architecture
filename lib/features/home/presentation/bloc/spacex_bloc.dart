import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_bloc_architecture/core/network/api_status.dart';
import 'package:flutter_bloc_architecture/features/home/data/models/launch_model.dart';
import 'package:flutter_bloc_architecture/features/home/data/models/rocket_model.dart';
import 'package:flutter_bloc_architecture/features/home/domain/repositories/spacex_repository.dart';

part 'spacex_event.dart';

part 'spacex_state.dart';

/// BLoC for handling SpaceX data events and state transitions.
///
/// Processes [SpacexEvent]s through [SpacexRepository] and emits [SpacexState]s.
class SpacexBloc extends Bloc<SpacexEvent, SpacexState> {
  final _repository = GetIt.I<SpacexRepository>();

  /// Creates a [SpacexBloc].
  SpacexBloc() : super(const SpacexState()) {
    on<FetchRocketsEvent>(_onFetchRockets);
    on<FetchLaunchesEvent>(_onFetchLaunches);
  }

  Future<void> _onFetchRockets(
    FetchRocketsEvent event,
    Emitter<SpacexState> emit,
  ) async {
    emit(
      state.copyWith(
        isRocketsLoading: true,
        isRocketsFailed: false,
        rocketsErrorMsg: null,
      ),
    );

    final response = await _repository.getRockets();

    if (response.status == ApiStatus.error) {
      emit(
        state.copyWith(
          isRocketsLoading: false,
          isRocketsFailed: true,
          rocketsErrorMsg: response.errorMsg ?? 'Failed to fetch rockets',
        ),
      );
    } else {
      emit(
        state.copyWith(
          isRocketsLoading: false,
          isRocketsFailed: false,
          rockets: response.data ?? [],
        ),
      );
    }
  }

  Future<void> _onFetchLaunches(
    FetchLaunchesEvent event,
    Emitter<SpacexState> emit,
  ) async {
    emit(
      state.copyWith(
        isLaunchesLoading: true,
        isLaunchesFailed: false,
        launchesErrorMsg: null,
      ),
    );

    final response = await _repository.getLaunches();

    if (response.status == ApiStatus.error) {
      emit(
        state.copyWith(
          isLaunchesLoading: false,
          isLaunchesFailed: true,
          launchesErrorMsg: response.errorMsg ?? 'Failed to fetch launches',
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLaunchesLoading: false,
          isLaunchesFailed: false,
          launches: response.data ?? [],
        ),
      );
    }
  }
}
