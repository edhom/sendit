import 'package:sendit/domain/entities/trail.dart';

/// Repository to load trails from the sendIT database.
abstract class TrailRepo {
  /// Returns all trails from the sendIT trail library.
  Future<List<Trail>> loadTrails();

  /// Save a trail.
  Future<void> save(Trail trail);
}
