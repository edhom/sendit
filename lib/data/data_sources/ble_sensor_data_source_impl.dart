import 'dart:async';
import 'dart:io';

import 'package:flutter_ble_lib_ios_15/flutter_ble_lib.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sendit/constants/sensor_connection_state.dart';
import 'package:sendit/data/data_sources/ble_sensor_data_source.dart';
import 'package:sendit/domain/entities/ble/ble_characteristic.dart';
import 'package:sendit/domain/entities/ble/ble_sensor.dart';
import 'package:sendit/domain/entities/ble/ble_service.dart';

/// Implementation of [BleSensorDataSource].
class BleSensorDataSourceImpl implements BleSensorDataSource {
  /// Constructs a [BleSensorDataSourceImpl].
  BleSensorDataSourceImpl() {
    initialized = _init();
  }

  /// Whether the [BleSensorDataSourceImpl] is done initializing.
  Future? initialized;

  final _bleManager = BleManager();

  /// List of already known ble sensors.
  ///
  /// If a new device is detected, we check whether we already know it.
  final List<BleSensor> bleSensors = <BleSensor>[];

  /// Behavior subject emitting the last recently discovered ble devices around.
  BehaviorSubject<List<BleSensor>> _visibleDevicesController =
      BehaviorSubject<List<BleSensor>>.seeded(<BleSensor>[]);

  StreamSubscription<ScanResult>? _scanSubscription;
  StreamSubscription<BleSensor>? _selectedDeviceSubscription;

  @override
  ValueStream<List<BleSensor>> get sensors => _visibleDevicesController;

  /// Dispose stream controllers and subscriptions.
  ///
  /// Note: This has to be called explicitly in the provider.
  void dispose() {
    _selectedDeviceSubscription?.cancel();
    _visibleDevicesController.close();
    _scanSubscription?.cancel();
  }

  /// Initializes the [BleSensorDataSourceImpl].
  Future<void> _init() async {
    await _bleManager.createClient(
      restoreStateIdentifier: 'sendIT-restore-id',
    );
    try {
      await _checkPermissions();
    } catch (e) {
      print('Permission not granted');
    }
    await _waitForBluetoothPoweredOn();
    _startScan();

    if (_visibleDevicesController.isClosed) {
      _visibleDevicesController =
          BehaviorSubject<List<BleSensor>>.seeded(<BleSensor>[]);
    }
  }

  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      var locGranted = await Permission.location.isGranted;
      if (locGranted == false) {
        locGranted = (await Permission.location.request()).isGranted;
      }
      if (locGranted == false) {
        return Future.error(Exception('Location permission not granted'));
      }
    }
  }

  Future<void> _waitForBluetoothPoweredOn() async {
    final completer = Completer();
    StreamSubscription<BluetoothState>? subscription;
    subscription =
        _bleManager.observeBluetoothState().listen((bluetoothState) async {
      if (bluetoothState == BluetoothState.POWERED_ON &&
          !completer.isCompleted) {
        await subscription?.cancel();
        completer.complete();
      }
    });

    return completer.future;
  }

  void _startScan() {
    print('Ble start scan');
    _scanSubscription = _bleManager.startPeripheralScan().listen((scanResult) {
      final device = scanResult.peripheral;
      if (device.name == null) {
        return;
      }
      final bleSensor = device.asBleSensor();
      if (!bleSensors
          .map((device) => device.identifier)
          .contains(bleSensor.identifier)) {
        bleSensors.add(bleSensor);
        _visibleDevicesController.add(List.of(bleSensors));
      }
    });
  }

  @override
  Future<void> refresh() async {
    await initialized;
    await _bleManager.stopPeripheralScan();
    await _scanSubscription?.cancel();
    bleSensors.clear();

    _visibleDevicesController.add(List.of(bleSensors));

    await _checkPermissions()
        .then((_) => _startScan())
        .catchError((_) => print('Permission not granted'));
  }
}

/// Extension for mapping a [ScanResult] to an [BleSensor].
extension ScanResultMapper on Peripheral {
  /// Returns a [ScanResult] as [BleSensor].
  BleSensor asBleSensor() {
    final stateSubject =
        BehaviorSubject.seeded(SensorConnectionState.disconnected);
    observeConnectionState().listen((state) {
      stateSubject.add(state.toConnectionState());
    });
    return BleSensor(
      identifier: identifier,
      name: name ?? '',
      state: stateSubject,
      connect: () async {
        await connect(
          timeout: const Duration(seconds: 5),
        );
        await discoverAllServicesAndCharacteristics();
      },
      disconnect: disconnectOrCancelConnection,
      services: () {
        return services().then((servicesList) =>
            servicesList.map((service) => service.toBleService()).toList());
      },
    );
  }
}

/// Extension mapping a library specific [PeripheralConnectionState] from
/// flutter_ble_lib to a [SensorConnectionState] in the domain layer.
extension ConnectionStateMapper on PeripheralConnectionState {
  /// Maps to a [SensorConnectionState].
  SensorConnectionState toConnectionState() {
    switch (this) {
      case PeripheralConnectionState.connected:
        return SensorConnectionState.connected;
      case PeripheralConnectionState.connecting:
        return SensorConnectionState.connecting;
      case PeripheralConnectionState.disconnected:
        return SensorConnectionState.disconnected;
      case PeripheralConnectionState.disconnecting:
        return SensorConnectionState.disconnecting;
    }
  }
}

/// Extension mapping a library specific [Service] from flutter_ble_lib to a
/// [BleService] in the domain layer.
extension ServiceMapper on Service {
  /// Maps to a [BleService].
  BleService toBleService() {
    return BleService(
      uuid,
      () {
        return characteristics().then((characteristicsList) =>
            characteristicsList
                .map((characteristic) => characteristic.toBleCharacteristic())
                .toList());
      },
    );
  }
}

/// Extension mapping a library specific [Characteristic] from flutter_ble_lib
/// to a [BleCharacteristic] in the domain layer.
extension CharacteristicsMapper on Characteristic {
  /// Maps to a [BleCharacteristic].
  BleCharacteristic toBleCharacteristic() {
    return BleCharacteristic(uuid, monitor);
  }
}
