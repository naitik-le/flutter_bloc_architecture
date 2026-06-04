import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing the active index of the [DashboardScreen].
class DashboardCubit extends Cubit<int> {
  /// Creates a [DashboardCubit] initialized to the first tab (index 0).
  DashboardCubit() : super(0);

  /// Sets the currently active tab index.
  void setTab(int index) => emit(index);
}
