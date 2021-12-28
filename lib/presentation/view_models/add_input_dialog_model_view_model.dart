import 'package:flutter/cupertino.dart';
import 'package:sendit/constants/input_type.dart';

/// View model for the [AddInputDialog] widget.
class AddInputDialogViewModel extends ChangeNotifier {
  /// Text controller for an optional json key, in case the characteristic
  /// contains json content.
  final TextEditingController jsonKeyController = TextEditingController();

  InputType? _type;

  /// Returns the currently selected type.
  InputType? get type => _type;

  /// Sets the type of this input.
  set type(InputType? type) {
    _type = type;
    notifyListeners();
  }

  @override
  void dispose() {
    jsonKeyController.dispose();
    super.dispose();
  }

  /// Returns a newly created input.
  Map<String, dynamic>? save() {
    return {
      'type': type,
      'jsonKey': jsonKeyController.text,
    };
  }
}
