import 'dart:convert';
import 'package:equatable/equatable.dart';

/// Data model representing a SpaceX launch.
///
/// Parsed from the SpaceX API v4 `/launches` endpoint.
class LaunchModel extends Equatable {
  /// Unique identifier.
  final String id;

  /// Mission name (e.g. "FalconSat").
  final String name;

  /// Flight number.
  final int flightNumber;

  /// UTC date of the launch.
  final String dateUtc;

  /// Unix timestamp of the launch.
  final int dateUnix;

  /// Whether the launch was successful.
  final bool? success;

  /// Whether this is an upcoming launch.
  final bool upcoming;

  /// Mission details/description.
  final String? details;

  /// Rocket ID used for this launch.
  final String rocketId;

  /// Small mission patch image URL.
  final String? patchSmall;

  /// Large mission patch image URL.
  final String? patchLarge;

  /// YouTube webcast URL.
  final String? webcast;

  /// YouTube video ID.
  final String? youtubeId;

  /// Wikipedia article URL.
  final String? wikipedia;

  /// News article URL.
  final String? article;

  /// List of failure reasons (if any).
  final List<LaunchFailure> failures;

  /// Creates a [LaunchModel].
  const LaunchModel({
    required this.id,
    required this.name,
    required this.flightNumber,
    required this.dateUtc,
    required this.dateUnix,
    required this.success,
    required this.upcoming,
    required this.details,
    required this.rocketId,
    required this.patchSmall,
    required this.patchLarge,
    required this.webcast,
    required this.youtubeId,
    required this.wikipedia,
    required this.article,
    required this.failures,
  });

  /// Creates a [LaunchModel] from a JSON map.
  factory LaunchModel.fromJson(Map<String, dynamic> json) {
    final links = json['links'] as Map<String, dynamic>? ?? {};
    final patch = links['patch'] as Map<String, dynamic>? ?? {};
    final failuresList = json['failures'] as List<dynamic>? ?? [];

    return LaunchModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      flightNumber: json['flight_number'] as int? ?? 0,
      dateUtc: json['date_utc'] as String? ?? '',
      dateUnix: json['date_unix'] as int? ?? 0,
      success: json['success'] as bool?,
      upcoming: json['upcoming'] as bool? ?? false,
      details: json['details'] as String?,
      rocketId: json['rocket'] as String? ?? '',
      patchSmall: patch['small'] as String?,
      patchLarge: patch['large'] as String?,
      webcast: links['webcast'] as String?,
      youtubeId: links['youtube_id'] as String?,
      wikipedia: links['wikipedia'] as String?,
      article: links['article'] as String?,
      failures: failuresList
          .map(
            (e) => LaunchFailure.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  /// Parses a raw JSON string into a list of [LaunchModel]s, pre-sorting them in reverse chronological order.
  /// Designed to be executed in a background isolate using `compute`.
  static List<LaunchModel> parseLaunchesFromJson(String jsonString) {
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    final launches = decoded
        .map((e) => LaunchModel.fromJson(e as Map<String, dynamic>))
        .toList();
    // Pre-sort launches by date_unix in descending order (latest first)
    launches.sort((a, b) => b.dateUnix.compareTo(a.dateUnix));
    return launches;
  }

  @override
  List<Object?> get props => [id];
}

/// Represents a failure that occurred during a launch.
class LaunchFailure extends Equatable {
  /// Time of failure in seconds after launch.
  final int? time;

  /// Altitude at failure in km.
  final int? altitude;

  /// Reason for failure.
  final String reason;

  /// Creates a [LaunchFailure].
  const LaunchFailure({
    this.time,
    this.altitude,
    required this.reason,
  });

  /// Creates a [LaunchFailure] from a JSON map.
  factory LaunchFailure.fromJson(Map<String, dynamic> json) {
    return LaunchFailure(
      time: json['time'] as int?,
      altitude: json['altitude'] as int?,
      reason: json['reason'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [time, altitude, reason];
}
