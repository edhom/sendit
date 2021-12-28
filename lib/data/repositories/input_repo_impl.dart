import 'package:rxdart/rxdart.dart';
import 'package:sendit/domain/entities/input.dart';
import 'package:sendit/domain/repositories/input_repo.dart';

/// Implementation of the [InputRepo].
class InputRepoImpl implements InputRepo {
  /// List keeping track of already added inputs.
  final _inputsController = BehaviorSubject.seeded(<Input>[]);

  final _inputs = <Input>[];

  @override
  Stream<List<Input>> get inputs => _inputsController.stream;

  @override
  void addInput(Input connection) {
    if (!_inputs.contains(connection)) {
      _inputs.add(connection);
      _inputsController.add(_inputs);
    }
  }

  @override
  void removeInput(Input connection) {
    if (_inputs.contains(connection)) {
      _inputs.remove(connection);
      _inputsController.add(_inputs);
    }
  }
}
