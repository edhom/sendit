import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sendit/constants/strings.dart';
import 'package:sendit/core/providers.dart';
import 'package:sendit/domain/entities/input.dart';
import 'package:sendit/presentation/widgets/input_preview.dart';

/// Screen showing the currently collected data.
class HomeScreen extends ConsumerWidget {
  /// Constructs a [HomeScreen].
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(homeScreenViewModelProvider);
    return StreamBuilder<List<Input>>(
      stream: model.inputs,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
              for (final input in snapshot.data!)
                InputTile(
                  input: input,
                ),
            ],
          );
        } else {
          return const Center(
            child: Text(kNoInputsHint),
          );
        }
      },
    );
  }
}

/// Widget displaying a input.
class InputTile extends ConsumerWidget {
  /// Constructs a [InputTile].
  const InputTile({
    Key? key,
    required this.input,
  }) : super(key: key);

  /// The input this tile previews
  final Input input;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(homeScreenViewModelProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Slidable(
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              child: IconSlideAction(
                icon: Icons.delete_outline,
                color: Colors.red,
                onTap: () => model.removeInput(input),
              ),
            )
          ],
          child: Column(
            children: [
              Text(
                describeEnum(input.type),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: AbsorbPointer(
                  child: InputPreview(
                    input: input.inputData,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
