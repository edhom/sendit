import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sendit/constants/sensor_connection_state.dart';

/// Class representing a sensor device.
abstract class Sensor {
  /// Constructs a [Sensor].
  Sensor({
    required this.identifier,
    required this.name,
    required this.state,
    required this.connect,
    required this.disconnect,
  });

  /// The identifier of this sensor.
  final String identifier;

  /// The display name of this sensor.
  final String name;

  /// The connection state of this sensor.
  final BehaviorSubject<SensorConnectionState> state;

  /// Connects the sensor.
  final VoidCallback? connect;

  /// Disconnects the sensor.
  final VoidCallback? disconnect;
}
