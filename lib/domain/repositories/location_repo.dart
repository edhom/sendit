import 'package:sendit/domain/entities/location.dart';

/// Repository to receive the current location.
abstract class LocationRepo {
  /// Calculates the distance between two [Location]s in meters.
  double calcDistance(Location a, Location b);
}
