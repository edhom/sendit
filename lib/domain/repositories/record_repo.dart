import 'package:sendit/domain/entities/input.dart';
import 'package:sendit/domain/entities/record.dart';

/// Repository holding [Record]s.
abstract class RecordRepo {
  /// Returns for how long the current recording is running.
  ///
  /// Returns 'null' if we're not recording.
  Stream<Duration?> get duration;

  /// Returns the start time of the current record.
  DateTime? get startTime;

  /// Starts a new recording given the [inputs].
  void startRecording(List<Input> inputs);

  /// Stops the current recording and returns the newly created [Record].
  Record stopRecording();

  /// Saves a record.
  Future<void> save(Record record);

  /// Deletes the record.
  Future<void> delete(Record record);

  /// Returns all trails from the sendIT trail library.
  Future<List<Record>> loadRecords();
}
