import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sendit/constants/strings.dart';
import 'package:sendit/core/providers.dart';
import 'package:sendit/domain/entities/ble/ble_characteristic.dart';
import 'package:sendit/domain/entities/ble/ble_sensor.dart';
import 'package:sendit/domain/entities/ble/ble_service.dart';
import 'package:sendit/presentation/widgets/add_input_dialog.dart';

/// Widget listing bluetooth low energy services provided by an [BleSensor].
class BleServicesList extends ConsumerWidget {
  /// Constructs a [BleServicesList] widget.
  const BleServicesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(findSensorsViewModelProvider);
    return FutureBuilder<List<BleService>>(
      future: (model.selectedSensor! as BleSensor).services(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return const Text(kNoServicesFoundHint);
          }
          return ListView(
            shrinkWrap: true,
            children: [
              for (final service in snapshot.data!)
                _ServiceExpansionTile(bleService: service),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

/// Widget displaying a ble service.
class _ServiceExpansionTile extends StatelessWidget {
  /// Constructs a [_CharacteristicsExpansionTile].
  const _ServiceExpansionTile({
    Key? key,
    required this.bleService,
  }) : super(key: key);

  /// The service this tile is showing.
  final BleService bleService;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(bleService.id),
      children: [
        FutureBuilder<List<BleCharacteristic>>(
          future: bleService.characteristics(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Text(kNoCharacteristicFoundHint);
              }
              return Column(
                children: [
                  for (final characteristic in snapshot.data!)
                    _CharacteristicsExpansionTile(
                      bleCharacteristic: characteristic,
                    ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}

/// Widget displaying a ble service.
class _CharacteristicsExpansionTile extends ConsumerWidget {
  /// Constructs a [_CharacteristicsExpansionTile].
  const _CharacteristicsExpansionTile({
    Key? key,
    required this.bleCharacteristic,
  }) : super(key: key);

  /// The service this tile is showing.
  final BleCharacteristic bleCharacteristic;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(findSensorsViewModelProvider);
    return ExpansionTile(
      title: Text(bleCharacteristic.id),
      children: [
        StreamBuilder<Uint8List>(
          stream: bleCharacteristic.monitor(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Text('0');
              }
              return SizedBox(
                height: 80,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (final value in snapshot.data!)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                value.toString(),
                              ),
                            ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await showDialog<Map<String, dynamic>?>(
                          context: context,
                          builder: (context) {
                            return const AddInputDialog();
                          },
                        );
                        if (result != null) {
                          model.addInput(
                            result['type']!,
                            bleCharacteristic,
                            jsonKey: result['jsonKey'],
                          );
                        }
                      },
                      child: const Text(kMonitorButtonLabel),
                    )
                  ],
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}
