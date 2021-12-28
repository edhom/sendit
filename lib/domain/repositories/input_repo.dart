import 'package:sendit/domain/entities/input.dart';

/// Repository holding [Input]s.
abstract class InputRepo {
  /// Stream of currently available inputs.
  Stream<List<Input>> get inputs;

  /// Add a new input to monitor it.
  void addInput(Input input);

  /// Remove a input that is currently monitored.
  void removeInput(Input input);
}
