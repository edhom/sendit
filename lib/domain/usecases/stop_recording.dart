import 'package:sendit/domain/repositories/input_repo.dart';
import 'package:sendit/domain/repositories/record_repo.dart';
import 'package:sendit/domain/usecases/analyse_trail.dart';

/// Use-case to stop the current recording.
class StopRecording {
  /// Constructs a [StopRecording] use-case.
  StopRecording(this._inputRepo, this._recordRepo, this._analyseTrail);

  final InputRepo _inputRepo;
  final RecordRepo _recordRepo;
  final AnalyseTrail _analyseTrail;

  /// Stops recording the current inputs.
  Future<void> call() async {
    final record = _recordRepo.stopRecording();
    await _recordRepo.save(record);
  }
}
