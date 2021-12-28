import 'package:json_annotation/json_annotation.dart';
import 'package:sendit/domain/entities/location.dart';

part 'record_frame.g.dart';

/// Class representing recorded sensor data at on point in time.
///
/// Every [RecordFrame] is characterised by the [time] the sensor values where
/// captured. Which values are included depends on the use-case and the
/// available sensor.
@JsonSerializable(explicitToJson: true)
class RecordFrame {
  /// Constructs a [RecordFrame], given it's [time], [location] and [data].
  const RecordFrame(this.time, this.location, this.data);

  /// Constructs a [RecordFrame] from json.
  factory RecordFrame.fromJson(Map<String, dynamic> json) =>
      _$RecordFrameFromJson(json);

  /// The time when this frame was captured.
  final DateTime time;

  /// The location where this frame was captured.
  final Location location;

  /// The sensor values that were captured.
  final Map<String, dynamic> data;

  /// Serializes the [RecordFrame] to json.
  Map<String, dynamic> toJson() => _$RecordFrameToJson(this);
}
