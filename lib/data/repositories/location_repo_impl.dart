import 'package:sendit/data/data_sources/gps_data_source.dart';
import 'package:sendit/domain/entities/location.dart';
import 'package:sendit/domain/repositories/location_repo.dart';

/// Implementation of the [LocationRepo].
class LocationRepoImpl implements LocationRepo {
  /// Constructs a [LocationRepoImpl].
  LocationRepoImpl(this._gpsDataSource);

  final GpsDataSource _gpsDataSource;

  @override
  double calcDistance(Location a, Location b) {
    return _gpsDataSource.calcDistance(
      a.latitude,
      a.longitude,
      b.latitude,
      b.longitude,
    );
  }
}
