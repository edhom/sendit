import 'package:sendit/domain/repositories/record_repo.dart';

/// Use-case to obtain for how long the current recording is running.
class GetRecordingDuration {
  /// Constructs a [GetRecordingDuration] use-case.
  GetRecordingDuration(this._recordRepo);

  final RecordRepo _recordRepo;

  /// Returns the duration of the current record.
  Stream<Duration> call() {
    return _recordRepo.duration.map((duration) => duration ?? const Duration());
  }
}
