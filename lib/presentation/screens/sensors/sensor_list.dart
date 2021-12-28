import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sendit/constants/sensor_connection_state.dart';
import 'package:sendit/core/providers.dart';
import 'package:sendit/domain/entities/sensor.dart';

/// List showing nearby sensors.
class SensorList extends ConsumerWidget {
  /// Constructs a [SensorList].
  const SensorList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(findSensorsViewModelProvider);
    return RefreshIndicator(
      onRefresh: model.scanForSensors,
      child: StreamBuilder<List<Sensor>>(
        stream: model.showAvailableSensors(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              padding: const EdgeInsets.all(8),
              children: [
                for (final sensor in snapshot.data!)
                  if (sensor.name.isNotEmpty)
                    _SensorListItem(
                      sensor: sensor,
                    ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class _SensorListItem extends ConsumerWidget {
  const _SensorListItem({
    Key? key,
    required this.sensor,
  }) : super(key: key);

  final Sensor sensor;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(findSensorsViewModelProvider);
    return StreamBuilder(
      stream: sensor.state,
      builder: (context, snapshot) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            onTap: () {
              if (snapshot.hasData &&
                  snapshot.data == SensorConnectionState.connected) {
                model.selectedSensor = sensor;
                Navigator.of(context).pushNamed('/sensorDetails');
              } else {
                sensor.connect!();
              }
            },
            title: Text(sensor.name),
            subtitle: Text(sensor.identifier),
            trailing: Builder(
              builder: (context) {
                if (snapshot.hasData) {
                  switch (snapshot.data) {
                    case SensorConnectionState.connected:
                      return GestureDetector(
                        onTap: sensor.disconnect,
                        child: const Icon(Icons.check),
                      );
                    case SensorConnectionState.connecting:
                      return const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(),
                      );
                    default:
                      return const Icon(Icons.add);
                  }
                } else {
                  return const Icon(Icons.add);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
