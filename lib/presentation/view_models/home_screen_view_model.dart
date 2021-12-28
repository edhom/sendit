import 'package:flutter/cupertino.dart';
import 'package:sendit/domain/entities/input.dart';
import 'package:sendit/domain/usecases/remove_input.dart';
import 'package:sendit/domain/usecases/stream_inputs.dart';

/// View model for the [HomeScreen].
class HomeViewModel extends ChangeNotifier {
  /// Constructs a [HomeViewModel].
  HomeViewModel(
    this._streamInputs,
    this._removeInput,
  );

  final StreamInputs _streamInputs;

  final RemoveInput _removeInput;

  /// The currently monitored inputs.
  Stream<List<Input>> get inputs => _streamInputs();

  /// Removes an input.
  void removeInput(Input input) {
    _removeInput(input);
  }
}
