import 'package:sendit/constants/input_type.dart';
import 'package:sendit/domain/entities/ble/ble_sensor.dart';
import 'package:sendit/domain/entities/input.dart';

/// Class representing an input using the bluetooth low energy protocol.
///
/// We extend the [Input] class in order to keep track of the ble service
/// and characteristic this input is using.
class BleInput extends Input {
  /// Constructs a [BleInput].
  BleInput({
    required String identifier,
    required InputType type,
    required BleSensor sensor,
    required Stream<double> inputData,
    required this.serviceId,
    required this.characteristicsId,
  }) : super(
          identifier: identifier,
          type: type,
          sensor: sensor,
          inputData: inputData,
        );

  /// The id of the service this input is using.
  String serviceId;

  /// The id of the characteristic this input is using.
  String characteristicsId;
}
