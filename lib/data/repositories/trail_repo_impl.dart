import 'package:sendit/data/data_sources/database_data_source.dart';
import 'package:sendit/domain/entities/trail.dart';
import 'package:sendit/domain/repositories/trail_repo.dart';

/// Implementation of the [TrailRepo].
class TrailRepoImpl extends TrailRepo {
  /// Constructs a [TrailRepoImpl].
  TrailRepoImpl(this._databaseDataSource);

  final DatabaseDataSource _databaseDataSource;

  /// The path of the trails collection.
  static const trailsCollectionPath = 'trails';

  @override
  Future<List<Trail>> loadTrails() async {
    final rawTrails = await _databaseDataSource.getAll(trailsCollectionPath);
    return rawTrails.map((json) => Trail.fromJson(json)).toList();
  }

  @override
  Future<void> save(Trail trail) async {
    await _databaseDataSource.add(trail.identifier, trail.toJson());
  }
}
