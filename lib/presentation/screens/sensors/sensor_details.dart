import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sendit/constants/strings.dart';
import 'package:sendit/core/providers.dart';
import 'package:sendit/domain/entities/ble/ble_sensor.dart';
import 'package:sendit/domain/entities/local_sensor.dart';
import 'package:sendit/presentation/widgets/ble_services_list.dart';

/// Screen to search for available sensors.
class SensorDetails extends ConsumerWidget {
  /// Constructs a [SensorDetails] widget.
  const SensorDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(findSensorsViewModelProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Text(
          model.selectedSensor?.name ?? '',
          style: Theme.of(context).textTheme.headline4,
        ),
        const SizedBox(height: 16),
        if (model.selectedSensor! is BleSensor) const BleServicesList(),
        if (model.selectedSensor! is LocalSensor)
          ElevatedButton(
            onPressed: model.addLocalSensor,
            child: const Text(kMonitorButtonLabel),
          )
      ],
    );
  }
}
