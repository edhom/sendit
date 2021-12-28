import 'package:sendit/domain/repositories/sensor_repo.dart';

/// Use-case for scanning available sensors.
class ScanForSensors {
  /// Constructs a [ScanForSensors] use-case.
  ScanForSensors(this._repo);

  final SensorRepo _repo;

  /// Starts a sensor scan.
  Future<void> call() => _repo.scan();
}
