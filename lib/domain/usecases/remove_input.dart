import 'package:sendit/domain/entities/input.dart';
import 'package:sendit/domain/repositories/input_repo.dart';

/// Use-case for removing an input.
class RemoveInput {
  /// Constructs an [RemoveInput] use-case.
  RemoveInput(this._repo);

  final InputRepo _repo;

  /// Removes an input.
  void call(Input input) {
    _repo.removeInput(input);
  }
}
