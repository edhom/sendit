import 'package:sendit/domain/entities/sensor.dart';

/// Repository to load currently available sensors.
abstract class SensorRepo {
  /// Stream of currently available sensors.
  Stream<List<Sensor>> get sensors;

  /// Scans for available sensors.
  Future<void> scan();
}
