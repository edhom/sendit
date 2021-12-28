import 'package:json_annotation/json_annotation.dart';
import 'package:sendit/domain/entities/trail_section.dart';

part 'trail.g.dart';

/// Class representing a mountain bike trail.
@JsonSerializable(explicitToJson: true)
class Trail {
  /// Constructs a [Trail].
  Trail(this.identifier, this.sections);

  /// Constructs a [Trail] from json.
  factory Trail.fromJson(Map<String, dynamic> json) => _$TrailFromJson(json);

  /// Identifies a trail.
  final String identifier;

  /// The trail sections that form this trail.
  final List<TrailSection> sections;

  /// Serializes the [Trail] to json.
  Map<String, dynamic> toJson() => _$TrailToJson(this);
}
