import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sendit/constants/strings.dart';
import 'package:sendit/core/providers.dart';

/// Screen showing all recordings.
class RecordsScreen extends ConsumerWidget {
  /// Constructs a [RecordsScreen].
  const RecordsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(recordsScreenViewModelProvider);
    if (model.records.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        for (final record in model.records)
          Card(
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
                    onTap: () => model.deleteRecord(record),
                  ),
                )
              ],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(record.start.toString()),
                    const SizedBox(
                      height: 8,
                    ),
                    Wrap(
                      children: [
                        for (final recordData in record.data)
                          Chip(
                            label: Text(describeEnum(recordData.type)),
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ElevatedButton(
                      onPressed: () => model.analyse(record),
                      child: const Text(kAnalyzeButtonLabel),
                    )
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
