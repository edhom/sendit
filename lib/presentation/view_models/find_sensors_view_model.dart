import 'package:flutter/cupertino.dart';
import 'package:sendit/constants/input_type.dart';
import 'package:sendit/domain/entities/ble/ble_characteristic.dart';
import 'package:sendit/domain/entities/local_sensor.dart';
import 'package:sendit/domain/entities/sensor.dart';
import 'package:sendit/domain/usecases/add_ble_input.dart';
import 'package:sendit/domain/usecases/add_local_input.dart';
import 'package:sendit/domain/usecases/scan_for_sensors.dart';
import 'package:sendit/domain/usecases/stream_sensors.dart';

/// View model for the [FindDevicesScreen].
class FindSensorsViewModel extends ChangeNotifier {
  /// Constructs a [FindSensorsViewModel].
  FindSensorsViewModel(
    this._scanForSensors,
    this._showAvailableSensors,
    this._addInput,
    this._addLocalSensor,
  ) {
    scanForSensors();
  }

  final ScanForSensors _scanForSensors;

  final StreamSensors _showAvailableSensors;

  final AddBleInput _addInput;

  final AddLocalInput _addLocalSensor;

  Sensor? _selectedSensor;

  /// Returns the currently selected sensor.
  Sensor? get selectedSensor => _selectedSensor;

  /// Sets this sensor as the selected sensor for a detailed view.
  set selectedSensor(Sensor? sensor) {
    _selectedSensor = sensor;
    notifyListeners();
  }

  /// Scans for sensors.
  Future<void> scanForSensors() {
    return _scanForSensors();
  }

  /// Returns a stream with available sensors.
  Stream<List<Sensor>> showAvailableSensors() {
    return _showAvailableSensors();
  }

  /// Adds a characteristic to the inputs.
  void addInput(
    InputType type,
    BleCharacteristic characteristic, {
    String? jsonKey,
  }) {
    _addInput(
      type,
      characteristic,
      _selectedSensor!,
      jsonKey: jsonKey,
    );
  }

  /// Adds a local sensors data input to the inputs.
  void addLocalSensor() {
    _addLocalSensor(_selectedSensor! as LocalSensor);
  }
}
