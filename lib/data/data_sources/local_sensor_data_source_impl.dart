import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:sendit/constants/input_type.dart';
import 'package:sendit/constants/sensor_connection_state.dart';
import 'package:sendit/data/data_sources/gps_data_source.dart';
import 'package:sendit/data/data_sources/local_sensor_data_source.dart';
import 'package:sendit/domain/entities/local_sensor.dart';
import 'package:sendit/domain/entities/sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Implementation of [LocalSensorDataSource].
class LocalSensorDataSourceImpl implements LocalSensorDataSource {
  /// Constructs a [LocalSensorDataSourceImpl].
  LocalSensorDataSourceImpl(this._gpsDataSource) {
    init();
  }

  final GpsDataSource _gpsDataSource;

  /// List of sensors this device has integrated.
  late final List<Sensor> localSensors;

  /// Initializes local sensors.
  void init() {
    localSensors = [
      LocalSensor(
        identifier: 'local_accelerometer_x',
        type: InputType.accelerationX,
        name: 'Local Accelerometer X',
        state: BehaviorSubject.seeded(SensorConnectionState.connected),
        dataInput: () => accelerometerEvents.map(
          (event) => event.x,
        ),
      ),
      LocalSensor(
        identifier: 'local_accelerometer_y',
        type: InputType.accelerationY,
        name: 'Local Accelerometer Y',
        state: BehaviorSubject.seeded(SensorConnectionState.connected),
        dataInput: () => accelerometerEvents.map(
          (event) => event.y,
        ),
      ),
      LocalSensor(
        identifier: 'local_accelerometer_z',
        type: InputType.accelerationZ,
        name: 'Local Accelerometer Z',
        state: BehaviorSubject.seeded(SensorConnectionState.connected),
        dataInput: () => accelerometerEvents.map(
          (event) => event.z,
        ),
      ),
      LocalSensor(
        identifier: 'local_latitude',
        type: InputType.latitude,
        name: 'Local Latitude',
        state: BehaviorSubject.seeded(SensorConnectionState.connected),
        dataInput: () => _gpsDataSource.location.map(
          (event) => event.latitude,
        ),
      ),
      LocalSensor(
        identifier: 'local_longitude',
        type: InputType.longitude,
        name: 'Local Longitude',
        state: BehaviorSubject.seeded(SensorConnectionState.connected),
        dataInput: () => _gpsDataSource.location.map(
          (event) => event.longitude,
        ),
      ),
      LocalSensor(
        identifier: 'local_altitude',
        type: InputType.altitude,
        name: 'Local Altitude',
        state: BehaviorSubject.seeded(SensorConnectionState.connected),
        dataInput: () => _gpsDataSource.location.map(
          (event) => event.altitude ?? 0,
        ),
      ),
    ];
  }

  @override
  Stream<List<Sensor>> get sensors => Stream.value(localSensors);
}
