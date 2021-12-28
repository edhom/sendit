import 'dart:typed_data';

/// Class representing a Bluetooth Low Energy Characteristic.
class BleCharacteristic {
  /// Constructs a [BleCharacteristic].
  BleCharacteristic(
    this.id,
    this.monitor,
  );

  /// The uuid of this characteristic.
  String id;

  /// Returns a stream of the characteristic.
  Stream<Uint8List> Function() monitor;
}
