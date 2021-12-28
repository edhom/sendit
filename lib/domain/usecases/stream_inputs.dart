import 'package:sendit/domain/entities/input.dart';
import 'package:sendit/domain/repositories/input_repo.dart';

/// Use-case for getting a stream of monitored inputs.
class StreamInputs {
  /// Constructs a [GetSensorStream].
  StreamInputs(this._repo);

  final InputRepo _repo;

  /// Returns a stream with monitored inputs.
  Stream<List<Input>> call() => _repo.inputs;
}
