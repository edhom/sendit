import 'package:sendit/domain/entities/trail.dart';
import 'package:sendit/domain/repositories/trail_repo.dart';

/// Use-case for loading trails in the sendIT library.
class LoadTrails {
  /// Constructs a [LoadTrail] use-case.
  LoadTrails(this._trailRepo);

  final TrailRepo _trailRepo;

  /// Loads trails in the sendIT library.
  Future<List<Trail>> call() {
    return _trailRepo.loadTrails();
  }
}
