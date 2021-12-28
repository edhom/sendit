import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sendit/constants/input_type.dart';
import 'package:sendit/constants/strings.dart';
import 'package:sendit/core/providers.dart';

/// Widget showing a dialog to configure an input.
class AddInputDialog extends StatelessWidget {
  /// Constructs an [AddInputDialog] widget.
  const AddInputDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer(
          builder: (context, watch, child) {
            final model = watch(addInputDialogViewModelProvider);
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(kInputTypeLabel),
                    DropdownButton<InputType?>(
                      value: model.type,
                      onChanged: (type) => model.type = type,
                      items: [
                        // TODO: Fetch values from database
                        for (final type in InputType.values)
                          DropdownMenuItem(
                            value: type,
                            child: Text(describeEnum(type)),
                          ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(kInputJsonToggleLabel),
                    Switch(
                      value: true,
                      onChanged: (value) {
                        // TODO: Support double without json
                      },
                    ),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: kInputJsonKeyLabel,
                  ),
                  controller: model.jsonKeyController,
                ),
                const SizedBox(
                  height: 16,
                ),
                Center(
                  child: FloatingActionButton(
                    onPressed: () {
                      final result = model.save();
                      if (result != null) {
                        Navigator.of(context).pop(result);
                      }
                    },
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
