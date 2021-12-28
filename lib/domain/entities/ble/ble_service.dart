import 'package:sendit/domain/entities/ble/ble_characteristic.dart';

/// Class representing a Bluetooth Low Energy Service.
class BleService {
  /// Constructs a [BleService].
  BleService(this.id, this.characteristics);

  /// The uuid of this service.
  String id;

  /// Async function returning a list with characteristics within this service.
  Future<List<BleCharacteristic>> Function() characteristics;
}
