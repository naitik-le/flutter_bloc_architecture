import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_architecture/features/profile/domain/repositories/profile_repository.dart';
import 'package:flutter_bloc_architecture/features/profile/presentation/bloc/profile_event.dart';
import 'package:flutter_bloc_architecture/features/profile/presentation/bloc/profile_state.dart';
import 'package:get_it/get_it.dart';

/// Business Logic Component managing user profile interactions.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository = GetIt.I<ProfileRepository>();

  /// Creates a [ProfileBloc].
  ProfileBloc() : super(const ProfileState()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ResetProfileEvent>(_onResetProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final profile = await _repository.getProfile();
      emit(state.copyWith(
        status: ProfileStatus.success,
        profile: profile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMsg: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final updated = await _repository.updateProfile(event.profile);
      emit(state.copyWith(
        status: ProfileStatus.success,
        profile: updated,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMsg: e.toString(),
      ));
    }
  }

  Future<void> _onResetProfile(
    ResetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await _repository.clearProfile();
      emit(const ProfileState(status: ProfileStatus.initial));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.failure,
        errorMsg: e.toString(),
      ));
    }
  }
}
