import 'dart:async';

import 'package:sendit/constants/input_type.dart';
import 'package:sendit/domain/entities/sensor.dart';

/// Class representing a data input from an arbitrary sensor.
///
/// Note that there may exist multiple inputs that belong to one sensor device.
/// E.g. sensors using the BLE protocol can provide multiple services, each of
/// them represented by a [Input].
class Input {
  /// Constructs a [Input].
  Input({
    this.identifier,
    required this.type,
    required this.sensor,
    required this.inputData,
  });

  /// The identifier of this input.
  final String? identifier;

  /// The type of this input.
  final InputType type;

  /// The sensor of this input.
  final Sensor sensor;

  /// The data of this input.
  final Stream<double> inputData;

  // /// The collected values.
  // List<double> values = [];

  // /// The collected values.
  // List<double> values = [];
  //
  // StreamSubscription? _recordListener;
  //
  // /// Start recording the input.
  // void startRecord() {
  //   _recordListener = inputData.listen((value) {
  //     values.add(value);
  //   });
  // }
  //
  // /// Stops recording.
  // InputData stopRecord() {
  //   _recordListener?.cancel();
  //   final data = InputData(
  //     identifier,
  //     values,
  //   );
  //   values = <double>[];
  //   return data;
  // }
}
