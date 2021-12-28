import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sendit/presentation/screens/sensors/sensor_details.dart';
import 'package:sendit/presentation/screens/sensors/sensor_list.dart';

/// Screen to search for available sensors.
class DiscoverSensorsScreen extends ConsumerWidget {
  /// Constructs a [DiscoverSensorsScreen].
  const DiscoverSensorsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Navigator(
      initialRoute: '/sensorList',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/sensorList':
            return MaterialPageRoute(
              builder: (context) => const SensorList(),
              settings: settings,
            );
          case '/sensorDetails':
            return MaterialPageRoute(
              builder: (context) => const SensorDetails(),
              settings: settings,
            );
        }
      },
    );
  }
}
