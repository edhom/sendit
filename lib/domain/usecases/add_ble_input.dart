import 'dart:convert';

import 'package:sendit/constants/input_type.dart';
import 'package:sendit/domain/entities/ble/ble_characteristic.dart';
import 'package:sendit/domain/entities/input.dart';
import 'package:sendit/domain/entities/sensor.dart';
import 'package:sendit/domain/repositories/input_repo.dart';

/// Use-case for adding an input.
class AddBleInput {
  /// Constructs an [AddBleInput] use-case.
  AddBleInput(this._repo);

  final InputRepo _repo;

  /// Adds a new input.
  void call(
    InputType type,
    BleCharacteristic characteristic,
    Sensor sensor, {
    String? jsonKey,
  }) {
    final input = Input(
      type: type,
      sensor: sensor,
      inputData: characteristic.monitor().map((rawData) {
        final stringValue = String.fromCharCodes(rawData);
        if (jsonKey == null) {
          return double.tryParse(stringValue)!;
        } else {
          final Map<String, dynamic> jsonValue = jsonDecode(stringValue);
          return jsonValue[jsonKey];
        }
      }),
    );
    _repo.addInput(input);
  }
}
