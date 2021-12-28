import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:sendit/constants/input_type.dart';
import 'package:sendit/domain/entities/input.dart';
import 'package:sendit/domain/entities/location.dart';
import 'package:sendit/domain/entities/trail.dart';
import 'package:sendit/domain/entities/trail_section.dart';
import 'package:sendit/domain/repositories/location_repo.dart';
import 'package:sendit/domain/repositories/record_repo.dart';
import 'package:sendit/domain/repositories/trail_repo.dart';
import 'package:sendit/domain/usecases/analyse_section.dart';
import 'package:sendit/domain/usecases/get_is_recording.dart';

/// Use-case for analysing a trail.
class AnalyseTrail {
  /// Constructs an [AnalyseTrail] use-case.
  AnalyseTrail(
    this._getIsRecording,
    this._trailRepo,
    this._recordRepo,
    this._locationRepo,
    this._calcSectionDifficulty,
  );

  final GetIsRecording _getIsRecording;
  final TrailRepo _trailRepo;
  final RecordRepo _recordRepo;
  final LocationRepo _locationRepo;
  final CalcSectionDifficulty _calcSectionDifficulty;

  /// The values collected in on section.
  final _sectionInputData = <double>[];

  final _listeners = <StreamSubscription>[];

  late final Trail _trail;

  Location? _sectionStart;

  /// Starts the trail analysis.
  Future<void> call(List<Input> inputs) async {
    final latitudeInput = inputs.firstWhere(
      (input) => input.type == InputType.latitude,
    );
    final longitudeInput = inputs.firstWhere(
      (input) => input.type == InputType.longitude,
    );
    final acXInput = inputs.firstWhere(
      (input) => input.type == InputType.accelerationY,
    );

    final location = CombineLatestStream<double, Location>(
      [latitudeInput.inputData, longitudeInput.inputData],
      (values) => Location(values[0], values[1], null),
    ).asBroadcastStream();

    _sectionStart = await location.first;

    _trail = Trail(
      'trails/${_sectionStart!.latitude}${_sectionStart!.longitude}',
      [],
    );

    final acXListener = acXInput.inputData.listen((value) {
      _sectionInputData.add(value);
    });
    _listeners.add(acXListener);

    final locationListener = location.listen((value) async {
      if (_locationRepo.calcDistance(_sectionStart!, value) > 5) {
        await _createNewSection(value);
        _sectionInputData.clear();
        _sectionStart = value;
      }
    });
    _listeners.add(locationListener);

    final endRecordingListener = _getIsRecording().listen((value) {
      if (!value) {
        _stopAnalyzing();
      }
    });
    _listeners.add(endRecordingListener);
  }

  Future<void> _createNewSection(Location sectionEnd) async {
    final difficulty = _calcSectionDifficulty(_sectionInputData);
    final section = TrailSection(
      _sectionStart!,
      sectionEnd,
      difficulty,
    );
    _trail.sections.add(section);
    _trailRepo.save(_trail);
  }

  Future<void> _stopAnalyzing() async {
    await _createNewSection(_sectionStart!);
    for (final listener in _listeners) {
      listener.cancel();
    }
    _listeners.clear();
  }
}
