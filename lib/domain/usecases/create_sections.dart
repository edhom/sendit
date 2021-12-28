import 'package:sendit/domain/entities/location.dart';
import 'package:sendit/domain/entities/record_frame.dart';
import 'package:sendit/domain/usecases/get_distance.dart';

/// Use-case for creating sections
class CreateSections {
  /// Constructs a [CreateSections] use-case.
  CreateSections(this._getDistance);

  final GetDistance _getDistance;

  /// The length of a single [TrailSection].
  static const sectionLength = 5;

  /// Splits the recorded [frames] into sections of length [sectionsLength].
  Map<Location, List<RecordFrame>> call(List<RecordFrame> frames) {
    final frameSections = <Location, List<RecordFrame>>{};
    final firstFrame = frames.removeAt(0);
    frameSections[firstFrame.location] = [firstFrame];
    for (final frame in frames) {
      final sectionStart = frameSections.keys.last;
      if (_getDistance(sectionStart, frame.location) < sectionLength) {
        frameSections[sectionStart]!.add(frame);
      } else {
        frameSections[frame.location] = [frame];
      }
    }
    return frameSections;
  }
}
