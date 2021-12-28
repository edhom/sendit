import 'package:sendit/domain/entities/record.dart';
import 'package:sendit/domain/repositories/record_repo.dart';

/// Use-case for deleting a record.
class DeleteRecord {
  /// Constructs a [DeleteRecord] use-case.
  DeleteRecord(this._recordRepo);

  final RecordRepo _recordRepo;

  /// Deletes the record.
  Future<void> call(Record record) async {
    return _recordRepo.delete(record);
  }
}
