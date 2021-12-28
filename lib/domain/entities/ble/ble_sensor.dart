import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sendit/constants/sensor_connection_state.dart';
import 'package:sendit/domain/entities/ble/ble_service.dart';
import 'package:sendit/domain/entities/sensor.dart';

/// Class representing a ble sensor device.
class BleSensor extends Sensor {
  /// Constructs a [BleSensor].
  BleSensor({
    required String identifier,
    required String name,
    required BehaviorSubject<SensorConnectionState> state,
    required VoidCallback connect,
    required VoidCallback disconnect,
    required this.services,
  }) : super(
          identifier: identifier,
          name: name,
          state: state,
          connect: connect,
          disconnect: disconnect,
        );

  /// Async function that returns a list with services this sensor provides.
  Future<List<BleService>> Function() services;
}
