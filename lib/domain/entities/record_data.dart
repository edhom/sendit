import 'package:json_annotation/json_annotation.dart';
import 'package:sendit/constants/input_type.dart';

part 'record_data.g.dart';

/// Class representing recorded sensor data of one input.
///
/// A [RecordData] contains information about the input and a url to the file
/// that holds the recorded data.
@JsonSerializable(explicitToJson: true)
class RecordData {
  /// Constructs a [RecordData], given it's [time], [location] and [data].
  const RecordData(this.name, this.type, this.min, this.max, this.path);

  /// Constructs a [RecordFrame] from json.
  factory RecordData.fromJson(Map<String, dynamic> json) =>
      _$RecordDataFromJson(json);

  /// The name of the input that produces this data.
  final String name;

  /// The type of the data.
  final InputType type;

  /// The minimum for values of this input.
  final int? min;

  /// The maximum for values of this input.
  final int? max;

  /// The path to the file that holds the actual data.
  ///
  /// The data is stored in the form of a csv file, where every row contains
  /// the timestamp in `millisecondsSinceEpoch` and the value recorded at that
  /// time.
  final String path;

  /// Serializes the [RecordFrame] to json.
  Map<String, dynamic> toJson() => _$RecordDataToJson(this);
}
