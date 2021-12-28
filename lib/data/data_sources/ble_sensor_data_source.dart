import 'package:sendit/domain/entities/sensor.dart';

/// Datasource of available Bluetooth Low Energy Devices.
abstract class BleSensorDataSource {
  /// Returns a list with available sensors.
  Stream<List<Sensor>> get sensors;

  /// Scans for available sensors.
  Future<void> refresh();
}
