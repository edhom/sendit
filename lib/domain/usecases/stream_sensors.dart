import 'package:sendit/domain/entities/sensor.dart';
import 'package:sendit/domain/repositories/sensor_repo.dart';

/// Use-case for listing available sensors.
class StreamSensors {
  /// Constructs a [StreamSensors] use-case.
  StreamSensors(this._repo);

  final SensorRepo _repo;

  /// Returns a stream with available sensors.
  Stream<List<Sensor>> call() => _repo.sensors;
}
