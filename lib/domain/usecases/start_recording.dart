import 'package:sendit/domain/repositories/input_repo.dart';
import 'package:sendit/domain/repositories/record_repo.dart';
import 'package:sendit/domain/usecases/analyse_trail.dart';

/// Use-case to start recording the current inputs.
class StartRecording {
  /// Constructs a [StartRecording] use-case.
  StartRecording(this._inputRepo, this._recordRepo, this._analyseTrail);

  final InputRepo _inputRepo;
  final RecordRepo _recordRepo;
  final AnalyseTrail _analyseTrail;

  /// Starts recording the current inputs.
  ///
  /// If [liveTrailAnalysis] is enabled, trail sections will be created and
  /// analyzed on the fly and immediately uploaded to the database.
  Future<void> call({bool liveTrailAnalysis = false}) async {
    _recordRepo.startRecording(await _inputRepo.inputs.first);
    if (liveTrailAnalysis) {
      _analyseTrail(await _inputRepo.inputs.first);
    }
  }
}
