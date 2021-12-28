import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sendit/core/providers.dart';

/// Widget displaying a bar to start/pause records.
class RecordBar extends ConsumerWidget {
  /// Constructs a [RecordBar].
  const RecordBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(recordBarViewModelProvider);
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        child: Row(
          children: [
            StreamBuilder<String>(
              stream: model.duration,
              builder: (context, snapshot) => Text(
                snapshot.data ?? '00:00',
              ),
            ),
            const Spacer(),
            StreamBuilder<bool>(
              stream: model.activeRecording,
              builder: (context, snapshot) {
                if (snapshot.data ?? false) {
                  return FloatingActionButton(
                    onPressed: model.stopRecording,
                    child: const Icon(
                      Icons.stop,
                      color: Colors.white,
                      size: 24,
                    ),
                  );
                } else {
                  return FloatingActionButton(
                    onPressed: model.startRecording,
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
