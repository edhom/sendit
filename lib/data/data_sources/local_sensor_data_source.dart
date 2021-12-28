import 'package:sendit/domain/entities/sensor.dart';

/// Datasource of sensors integrated in the users device.
abstract class LocalSensorDataSource {
  /// Returns a list with available sensors.
  Stream<List<Sensor>> get sensors;
}
