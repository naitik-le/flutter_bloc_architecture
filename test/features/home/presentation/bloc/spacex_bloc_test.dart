import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_architecture/core/network/api_response.dart';
import 'package:flutter_bloc_architecture/features/home/data/models/launch_model.dart';
import 'package:flutter_bloc_architecture/features/home/data/models/rocket_model.dart';
import 'package:flutter_bloc_architecture/features/home/domain/repositories/spacex_repository.dart';
import 'package:flutter_bloc_architecture/features/home/presentation/bloc/spacex_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

// Manual Fake class to stub SpacexRepository responses without needing mockito build_runner code-generation.
class FakeSpacexRepository extends SpacexRepository {
  ApiResponse<List<RocketModel>> rocketsResponse =
      ApiResponse.success(data: const []);
  ApiResponse<List<LaunchModel>> launchesResponse =
      ApiResponse.success(data: const []);

  int rocketsCallCount = 0;
  int launchesCallCount = 0;
  Duration delay = Duration.zero;

  @override
  Future<ApiResponse<List<RocketModel>>> getRockets() async {
    rocketsCallCount++;
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }
    return rocketsResponse;
  }

  @override
  Future<ApiResponse<List<LaunchModel>>> getLaunches() async {
    launchesCallCount++;
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }
    return launchesResponse;
  }
}

void main() {
  late FakeSpacexRepository fakeRepository;

  setUp(() async {
    fakeRepository = FakeSpacexRepository();
    // Register the fake repository to GetIt
    await GetIt.I.reset();
    GetIt.I.registerLazySingleton<SpacexRepository>(() => fakeRepository);
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  group('SpacexBloc State Transitions & Parallel Isolation', () {
    test('initial state has default flags', () {
      final bloc = SpacexBloc();
      expect(bloc.state.isRocketsLoading, isFalse);
      expect(bloc.state.isLaunchesLoading, isFalse);
      expect(bloc.state.isRocketsFailed, isFalse);
      expect(bloc.state.isLaunchesFailed, isFalse);
      expect(bloc.state.rockets, isEmpty);
      expect(bloc.state.launches, isEmpty);
      bloc.close();
    });

    blocTest<SpacexBloc, SpacexState>(
      'FetchRocketsEvent emits rockets loading and success states',
      build: () {
        fakeRepository.rocketsResponse = ApiResponse.success(data: [
          const RocketModel(
            id: '1',
            name: 'Falcon 9',
            type: 'rocket',
            active: true,
            stages: 2,
            boosters: 0,
            costPerLaunch: 67000000,
            successRatePct: 98,
            firstFlight: '2010-06-04',
            country: 'USA',
            company: 'SpaceX',
            heightMeters: 70.0,
            diameterMeters: 3.7,
            massKg: 549000,
            enginesCount: 9,
            engineType: 'merlin',
            description: 'Falcon 9 description',
            wikipedia: 'wikipedia.org',
            flickrImages: [],
          ),
        ],);
        return SpacexBloc();
      },
      act: (bloc) => bloc.add(const FetchRocketsEvent()),
      expect: () => [
        const SpacexState(
          isRocketsLoading: true,
          isRocketsFailed: false,
          rocketsErrorMsg: null,
        ),
        isA<SpacexState>()
            .having((s) => s.isRocketsLoading, 'isRocketsLoading', isFalse)
            .having((s) => s.isRocketsFailed, 'isRocketsFailed', isFalse)
            .having((s) => s.rockets.length, 'rockets.length', 1),
      ],
    );

    blocTest<SpacexBloc, SpacexState>(
      'FetchLaunchesEvent emits launches loading and success states',
      build: () {
        fakeRepository.launchesResponse = ApiResponse.success(data: [
          const LaunchModel(
            id: '1',
            name: 'FalconSat',
            flightNumber: 1,
            dateUtc: '2006-03-24',
            dateUnix: 1143239400,
            success: false,
            upcoming: false,
            details: 'engine failure',
            rocketId: '1',
            patchSmall: null,
            patchLarge: null,
            webcast: null,
            youtubeId: null,
            wikipedia: null,
            article: null,
            failures: [],
          ),
        ],);
        return SpacexBloc();
      },
      act: (bloc) => bloc.add(const FetchLaunchesEvent()),
      expect: () => [
        const SpacexState(
          isLaunchesLoading: true,
          isLaunchesFailed: false,
          launchesErrorMsg: null,
        ),
        isA<SpacexState>()
            .having((s) => s.isLaunchesLoading, 'isLaunchesLoading', isFalse)
            .having((s) => s.isLaunchesFailed, 'isLaunchesFailed', isFalse)
            .having((s) => s.launches.length, 'launches.length', 1),
      ],
    );

    test('Parallel calls do not reset or conflict each other flags', () async {
      // Configure a delay so that the loading states don't complete synchronously in the event loop
      fakeRepository.delay = const Duration(milliseconds: 20);
      final bloc = SpacexBloc();

      // Start fetching rockets (sets loading: true)
      bloc.add(const FetchRocketsEvent());
      await Future.delayed(Duration.zero);
      expect(bloc.state.isRocketsLoading, isTrue);
      expect(bloc.state.isLaunchesLoading, isFalse);

      // Start fetching launches (sets loading: true)
      bloc.add(const FetchLaunchesEvent());
      await Future.delayed(Duration.zero);
      expect(bloc.state.isRocketsLoading, isTrue);
      expect(bloc.state.isLaunchesLoading, isTrue);

      // Complete requests and check they both resolved
      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.isRocketsLoading, isFalse);
      expect(bloc.state.isLaunchesLoading, isFalse);
      bloc.close();
    });
  });
}
