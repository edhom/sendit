import 'package:json_annotation/json_annotation.dart';
import 'package:sendit/domain/entities/location.dart';

part 'trail_section.g.dart';

/// Class representing a section on a mountain-bike trail.
///
/// A mountain-bike trail is composed out of multiple sections.
@JsonSerializable(explicitToJson: true)
class TrailSection {
  /// Constructs a [TrailSection].
  TrailSection(
    this.start,
    this.end,
    this.difficulty,
  );

  /// Constructs a [TrailSection] from json.
  factory TrailSection.fromJson(Map<String, dynamic> json) =>
      _$TrailSectionFromJson(json);

  /// The point where this section starts.
  Location start;

  /// The point where this section ends.
  Location end;

  /// The difficulty of this section.
  double difficulty;

  /// Serializes the [TrailSection] to json.
  Map<String, dynamic> toJson() => _$TrailSectionToJson(this);
}
