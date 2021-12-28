import 'package:json_annotation/json_annotation.dart';
import 'package:sendit/domain/entities/input.dart';
import 'package:sendit/domain/entities/record_data.dart';

part 'record.g.dart';

/// Class representing a record.
///
/// E.g. the sensor values collected while riding a trail.

@JsonSerializable(explicitToJson: true)
class Record {
  /// Constructs a [Record].
  Record(
    this.identifier,
    this.data,
    this.start,
    this.end,
  );

  /// Constructs a [Record] from json.
  factory Record.fromJson(Map<String, dynamic> json) => _$RecordFromJson(json);

  /// The identifier of this record.
  final String identifier;

  /// List with recorded [Input]s.
  final List<RecordData> data;

  /// The time when this recording started.
  final DateTime start;

  /// The time when this recording ended.
  final DateTime end;

  /// Serializes the [Record] to json.
  Map<String, dynamic> toJson() => _$RecordToJson(this);
}
