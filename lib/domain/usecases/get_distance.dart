import 'package:sendit/domain/entities/location.dart';
import 'package:sendit/domain/repositories/location_repo.dart';

/// Use-case for calculating the distance between two [Location]s.
class GetDistance {
  /// Constructs a [GetDistance] use-case.
  GetDistance(this._locationRepo);

  final LocationRepo _locationRepo;

  /// Returns the distance between point a and b in meters.
  double call(Location a, Location b) {
    return _locationRepo.calcDistance(a, b);
  }
}
