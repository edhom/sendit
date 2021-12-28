import 'package:sendit/domain/entities/location.dart';

/// Datasource to determine the current location.
abstract class GpsDataSource {
  /// Returns the users current position.
  Stream<Location> get location;

  /// Returns the distance between location a and b in meters.
  double calcDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  );
}
