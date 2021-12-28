import 'package:sendit/domain/entities/record.dart';
import 'package:sendit/domain/repositories/record_repo.dart';

/// Use-case for loading records in the sendIT library.
class LoadRecords {
  /// Constructs a [LoadRecords] use-case.
  LoadRecords(this._recordRepo);

  final RecordRepo _recordRepo;

  /// Loads records in the sendIT library.
  Future<List<Record>> call() {
    return _recordRepo.loadRecords();
  }
}
