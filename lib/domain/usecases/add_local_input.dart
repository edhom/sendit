import 'package:sendit/domain/entities/input.dart';
import 'package:sendit/domain/entities/local_sensor.dart';
import 'package:sendit/domain/repositories/input_repo.dart';

/// Use-case for adding a local input.
class AddLocalInput {
  /// Constructs a [AddLocalInput] use-case.
  AddLocalInput(this._repo);

  final InputRepo _repo;

  /// Creates a new input from a device sensor.
  void call(LocalSensor sensor) {
    final input = Input(
      type: sensor.type,
      sensor: sensor,
      inputData: sensor.dataInput(),
    );
    _repo.addInput(input);
  }
}
