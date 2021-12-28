import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sendit/domain/usecases/get_is_recording.dart';
import 'package:sendit/domain/usecases/get_recording_duration.dart';
import 'package:sendit/domain/usecases/start_recording.dart';
import 'package:sendit/domain/usecases/stop_recording.dart';

/// View model for the [HomeScreen].
class RecordBarViewModel extends ChangeNotifier {
  /// Constructs a [RecordBarViewModel].
  RecordBarViewModel(
    this._startRecording,
    this._stopRecording,
    this._getIsRecording,
    this._getRecordStartTime,
  );

  final StartRecording _startRecording;

  final StopRecording _stopRecording;

  final GetIsRecording _getIsRecording;

  final GetRecordingDuration _getRecordStartTime;

  /// Return for how long the current recording is already running.
  Stream<String> get duration {
    return _getRecordStartTime().map((value) => value.toMinAndSec());
  }

  /// Whether there's an ongoing recording.
  Stream<bool> get activeRecording => _getIsRecording();

  /// Start the recording.
  void startRecording() {
    _startRecording.call();
    notifyListeners();
  }

  /// Start the recording.
  void stopRecording() {
    _stopRecording();
    notifyListeners();
  }
}

/// Extension to format a [Duration].
extension DateFormat on Duration {
  /// Formats a duration to mm:ss format
  String toMinAndSec() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
