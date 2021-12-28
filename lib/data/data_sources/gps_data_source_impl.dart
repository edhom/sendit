import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:sendit/data/data_sources/gps_data_source.dart';
import 'package:sendit/domain/entities/location.dart';

/// Implementation of [GpsDataSource].
class GpsDataSourceImpl implements GpsDataSource {
  /// Initializes the [GpsDataSourceImpl].
  Future<void> init() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied.');
    }
  }

  StreamController<Location>? _locationController;

  Timer? _timer;

  void _addEvent(_) {
    _currentLocation().then((location) => _locationController?.add(location));
  }

  void _start() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), _addEvent);
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Stream<Location> get location {
    _locationController ??= StreamController<Location>.broadcast(
      onListen: _start,
      onCancel: _stop,
    );
    return _locationController!.stream;
  }

  @override
  double calcDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  Future<Location> _currentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(milliseconds: 500),
      );
      return Location(
        position.latitude,
        position.longitude,
        position.altitude,
      );
    } catch (e) {
      return Future.error(e);
    }
  }
}
