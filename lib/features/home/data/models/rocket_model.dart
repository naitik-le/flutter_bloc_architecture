import 'package:equatable/equatable.dart';

/// Data model representing a SpaceX rocket.
///
/// Parsed from the SpaceX API v4 `/rockets` endpoint.
class RocketModel extends Equatable {
  /// Unique identifier.
  final String id;

  /// Rocket name (e.g. "Falcon 9").
  final String name;

  /// Rocket type (e.g. "rocket").
  final String type;

  /// Whether the rocket is currently active.
  final bool active;

  /// Number of rocket stages.
  final int stages;

  /// Number of boosters.
  final int boosters;

  /// Cost per launch in USD.
  final int costPerLaunch;

  /// Historical success rate percentage.
  final int successRatePct;

  /// Date of first flight (e.g. "2006-03-24").
  final String firstFlight;

  /// Country of origin.
  final String country;

  /// Company name (e.g. "SpaceX").
  final String company;

  /// Height in meters.
  final double heightMeters;

  /// Diameter in meters.
  final double diameterMeters;

  /// Mass in kilograms.
  final int massKg;

  /// Number of engines.
  final int enginesCount;

  /// Engine type (e.g. "merlin").
  final String engineType;

  /// Rocket description.
  final String description;

  /// Wikipedia link.
  final String wikipedia;

  /// Flickr image URLs.
  final List<String> flickrImages;

  /// Creates a [RocketModel].
  const RocketModel({
    required this.id,
    required this.name,
    required this.type,
    required this.active,
    required this.stages,
    required this.boosters,
    required this.costPerLaunch,
    required this.successRatePct,
    required this.firstFlight,
    required this.country,
    required this.company,
    required this.heightMeters,
    required this.diameterMeters,
    required this.massKg,
    required this.enginesCount,
    required this.engineType,
    required this.description,
    required this.wikipedia,
    required this.flickrImages,
  });

  /// Creates a [RocketModel] from a JSON map.
  factory RocketModel.fromJson(Map<String, dynamic> json) {
    final height = json['height'] as Map<String, dynamic>? ?? {};
    final diameter = json['diameter'] as Map<String, dynamic>? ?? {};
    final mass = json['mass'] as Map<String, dynamic>? ?? {};
    final engines = json['engines'] as Map<String, dynamic>? ?? {};
    final images = json['flickr_images'] as List<dynamic>? ?? [];

    return RocketModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      active: json['active'] as bool? ?? false,
      stages: json['stages'] as int? ?? 0,
      boosters: json['boosters'] as int? ?? 0,
      costPerLaunch: json['cost_per_launch'] as int? ?? 0,
      successRatePct: json['success_rate_pct'] as int? ?? 0,
      firstFlight: json['first_flight'] as String? ?? '',
      country: json['country'] as String? ?? '',
      company: json['company'] as String? ?? '',
      heightMeters: (height['meters'] as num?)?.toDouble() ?? 0.0,
      diameterMeters: (diameter['meters'] as num?)?.toDouble() ?? 0.0,
      massKg: (mass['kg'] as num?)?.toInt() ?? 0,
      enginesCount: engines['number'] as int? ?? 0,
      engineType: engines['type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      wikipedia: json['wikipedia'] as String? ?? '',
      flickrImages: images.map((e) => e.toString()).toList(),
    );
  }

  @override
  List<Object?> get props => [id];
}
