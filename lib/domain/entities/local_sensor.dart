import 'package:rxdart/rxdart.dart';
import 'package:sendit/constants/input_type.dart';
import 'package:sendit/constants/sensor_connection_state.dart';
import 'package:sendit/domain/entities/sensor.dart';

/// Class representing a local sensor.
class LocalSensor extends Sensor {
  /// Constructs a [LocalSensor].
  LocalSensor({
    required String identifier,
    required this.type,
    required String name,
    required BehaviorSubject<SensorConnectionState> state,
    required this.dataInput,
  }) : super(
          identifier: identifier,
          name: name,
          state: state,
          connect: null,
          disconnect: null,
        );

  /// The input type of this sensor.
  InputType type;

  /// Function returning a stream with the data this sensor produces.
  Stream<double> Function() dataInput;
}
