import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc_architecture/features/home/data/models/launch_model.dart';

void main() {
  test('Offline SpaceX Launches API Benchmark', () {
    debugPrint('Starting offline SpaceX Launches API Benchmark...');

    // 1. Generate 250 mock launch objects to simulate a large SpaceX launches payload.
    // Each object has nested links and failures list matching LaunchModel expectations.
    final mockLaunchesList = List.generate(250, (index) {
      return {
        'id': 'launch_id_$index',
        'name': 'FalconSat $index',
        'flight_number': index + 1,
        'date_utc': '2020-03-24T22:30:00.000Z',
        'date_unix': 1585089000 + index * 10000,
        'success': index % 10 != 0, // 90% success rate
        'upcoming': false,
        'details': 'Engine failure at 33 seconds and loss of vehicle. ' * (index % 3 + 1), // variable length details
        'rocket': '5e9d0d95eda69955f709d1eb',
        'links': {
          'patch': {
            'small': 'https://images2.imgbox.com/3c/0e/T10HiNaR_o.png',
            'large': 'https://images2.imgbox.com/40/e3/ar9Rnv2C_o.png',
          },
          'reddit': {
            'campaign': null,
            'launch': null,
            'media': null,
            'recovery': null,
          },
          'flickr': {'small': [], 'original': []},
          'presskit': null,
          'webcast': 'https://www.youtube.com/watch?v=0a_00wJJKDs',
          'youtube_id': '0a_00wJJKDs',
          'wikipedia': 'https://en.wikipedia.org/wiki/Falcon_1',
          'article': 'https://www.space.com/2196-spacex-falcon-1-launch-fails.html',
        },
        'failures': [
          if (index % 10 == 0) ...[
            {'time': 33, 'altitude': null, 'reason': 'merlin engine failure'},
            {
              'time': 120,
              'altitude': 40,
              'reason': 'helium leak causing pressure drop',
            }
          ],
        ],
      };
    });

    final jsonString = jsonEncode(mockLaunchesList);
    final payloadSizeKb = jsonString.length / 1024;
    debugPrint('Simulated Payload Size: ${payloadSizeKb.toStringAsFixed(2)} KB');

    // 2. Measure JSON Decoding Time
    debugPrint('Decoding JSON...');
    final stopwatch = Stopwatch()..start();
    final decodedData = jsonDecode(jsonString) as List<dynamic>;
    stopwatch.stop();
    final jsonDecodeTimeMs = stopwatch.elapsedMilliseconds;
    debugPrint('JSON Decoding Time: ${jsonDecodeTimeMs}ms');

    // 3. Measure Model Mapping / Deserialization Time
    debugPrint('Mapping to models...');
    stopwatch.reset();
    stopwatch.start();
    final launches = decodedData.map((e) => LaunchModel.fromJson(e as Map<String, dynamic>)).toList();
    stopwatch.stop();
    final modelMappingTimeMs = stopwatch.elapsedMilliseconds;
    debugPrint('Model Mapping/Deserialization Time: ${modelMappingTimeMs}ms');
    debugPrint('Total Launches parsed: ${launches.length}');
  });
}
