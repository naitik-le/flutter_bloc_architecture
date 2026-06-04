import 'package:flutter_bloc_architecture/core/network/api_response.dart';
import 'package:flutter_bloc_architecture/features/home/data/models/launch_model.dart';
import 'package:flutter_bloc_architecture/features/home/data/models/rocket_model.dart';

/// Abstract contract for SpaceX data operations.
///
/// Defines methods to fetch rockets and launches from the SpaceX API.
abstract class SpacexRepository {
  /// Fetches all SpaceX rockets.
  Future<ApiResponse<List<RocketModel>>> getRockets();

  /// Fetches all SpaceX launches.
  Future<ApiResponse<List<LaunchModel>>> getLaunches();
}
