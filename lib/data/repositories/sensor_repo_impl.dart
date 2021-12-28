import 'package:rxdart/rxdart.dart';
import 'package:sendit/data/data_sources/ble_sensor_data_source.dart';
import 'package:sendit/data/data_sources/local_sensor_data_source.dart';
import 'package:sendit/domain/entities/sensor.dart';
import 'package:sendit/domain/repositories/sensor_repo.dart';

/// Implementation of the [SensorRepo].
class SensorRepoImpl implements SensorRepo {
  /// Constructs a [SensorRepoImpl].
  SensorRepoImpl(
    this._bleDataSource,
    this._localDataSource,
  );

  final BleSensorDataSource _bleDataSource;

  final LocalSensorDataSource _localDataSource;

  @override
  Stream<List<Sensor>> get sensors => CombineLatestStream(
        [_bleDataSource.sensors, _localDataSource.sensors],
        (List<List<Sensor>> value) =>
            value.expand((sensors) => sensors).toList(),
      );

  @override
  Future<void> scan() async {
    return;
  }
// Future<void> scan() => _dataSource.refresh();

}
