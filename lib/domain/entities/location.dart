import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

/// Class representing a geographical position.
@JsonSerializable()
class Location {
  /// Constructs a [Location], given it's parameters.
  const Location(
    this.latitude,
    this.longitude,
    this.altitude,
  );

  /// Constructs a [Location] from json.
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  /// The latitude of this location in degrees normalized to the interval -90.0
  /// to +90.0 (both inclusive).
  final double latitude;

  /// The longitude of this location in degrees normalized to the interval -180
  /// (exclusive) to +180 (inclusive).
  final double longitude;

  /// The altitude in meters.
  final double? altitude;

  /// Serializes the [Location] to json.
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
