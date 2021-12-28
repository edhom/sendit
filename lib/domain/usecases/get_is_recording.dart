import 'package:sendit/domain/repositories/record_repo.dart';

/// Use-case to obtain whether we're currently recording or not.
class GetIsRecording {
  /// Constructs a [GetIsRecording] use-case.
  GetIsRecording(this._recordRepo);

  final RecordRepo _recordRepo;

  /// Return whether recording is active.
  Stream<bool> call() =>
      _recordRepo.duration.map((duration) => duration != null);
}
