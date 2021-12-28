import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sendit/data/data_sources/cloud_storage_data_source.dart';
import 'package:sendit/data/data_sources/database_data_source.dart';
import 'package:sendit/data/data_sources/local_storage_data_source.dart';
import 'package:sendit/domain/entities/input.dart';
import 'package:sendit/domain/entities/record.dart';
import 'package:sendit/domain/entities/record_data.dart';
import 'package:sendit/domain/repositories/record_repo.dart';

/// Implementation of the [RecordRepo].
class RecordRepoImpl implements RecordRepo {
  /// Constructs a [RecordRepoImpl].
  RecordRepoImpl(
    this._cloudStorageDataSource,
    this._databaseDataSource,
    this._localStorageDataSource,
  );

  final CloudStorageDataSource _cloudStorageDataSource;

  final DatabaseDataSource _databaseDataSource;

  final LocalStorageDataSource _localStorageDataSource;

  final List<IOSink> _sinks = [];

  /// The path of the records collection.
  static const recordsCollectionPath = 'records';

  /// The name of the file inside a records directory that contains the record
  /// itself.
  static const recordFileName = 'record';

  StreamSubscription? _durationListener;

  final List<StreamSubscription> _inputListeners = [];

  final BehaviorSubject<Duration?> _durationController =
      BehaviorSubject.seeded(null);

  @override
  Stream<Duration?> get duration => _durationController.stream;

  DateTime? _startTime;

  @override
  DateTime? get startTime => _startTime;

  final List<RecordData> _recordedData = [];

  /// Whether the repo is currently syncing.
  bool syncing = false;

  @override
  Future<void> startRecording(List<Input> inputs) async {
    _startTime = DateTime.now();
    _durationController.add(const Duration());
    _durationListener = Stream.periodic(const Duration(seconds: 1), (_) {
      return DateTime.now();
    }).listen((time) {
      _durationController.add(time.difference(_startTime!));
    });

    for (final input in inputs) {
      final path =
          '$recordsCollectionPath/$startTime/${describeEnum(input.type)}.csv';
      _recordedData.add(
        RecordData(input.sensor.name, input.type, null, null, path),
      );
      final ioSink = await _localStorageDataSource.writeContinously(path);
      _sinks.add(ioSink);
      final listener = input.inputData.listen((value) async {
        final time = DateTime.now().millisecondsSinceEpoch;
        ioSink.writeln('$time;$value');
      });
      _inputListeners.add(listener);
    }
  }

  @override
  Record stopRecording() {
    // Cancels the duration listener.
    _durationListener?.cancel();
    _durationController.add(null);

    // Cancel all input listeners.
    for (final listener in _inputListeners) {
      listener.cancel();
    }
    _inputListeners.clear();

    // Close all io sinks.
    for (final ioSink in _sinks) {
      ioSink.close();
    }
    _sinks.clear();

    // Create a record.
    return Record(
      '$recordsCollectionPath/$startTime',
      _recordedData,
      startTime!,
      DateTime.now(),
    );
  }

  @override
  Future<void> save(Record record) async {
    syncing = true;
    final allDataUploaded = await _uploadRecordData(record);
    if (allDataUploaded) {
      await _uploadRecord(record);
    } else {
      final path = '${record.identifier}/$recordFileName';
      _localStorageDataSource.write(path, jsonEncode(record.toJson()));
    }
    syncing = false;
    _recordedData.clear();
  }

  Future<bool> _uploadRecordData(Record record) async {
    var allUploaded = true;
    for (final recordData in record.data) {
      final file = await _localStorageDataSource.getFile(recordData.path);
      if (!(await file.exists())) {
        continue;
      }
      try {
        await _cloudStorageDataSource.uploadFile(recordData.path, file);
        await _localStorageDataSource.deleteFile(recordData.path);
      } catch (e) {
        allUploaded = false;
      }
    }
    return allUploaded;
  }

  Future<void> _uploadRecord(Record record) async {
    await _localStorageDataSource.deleteDirectory(
      record.identifier,
    );
    await _databaseDataSource.add(
      record.identifier,
      record.toJson(),
    );
  }

  @override
  Future<void> delete(Record record) async {
    for (final data in record.data) {
      _cloudStorageDataSource.deleteFile(data.path);
    }
    return _databaseDataSource.delete(record.identifier);
  }

  @override
  Future<List<Record>> loadRecords() async {
    await _syncOfflineRecords();
    final rawRecords = await _databaseDataSource.getAll(recordsCollectionPath);
    return rawRecords.map((json) => Record.fromJson(json)).toList();
  }

  /// Checks if there are records stored on this device and uploads them to the
  /// database.
  Future<void> _syncOfflineRecords() async {
    if (syncing) return;
    List<Directory> recordDirs;
    try {
      recordDirs =
          await _localStorageDataSource.listDirectories(recordsCollectionPath);
    } catch (e) {
      return;
    }
    for (final recordDir in recordDirs) {
      final name = recordDir.path.split('/').last;
      final rawRecord = await _localStorageDataSource
          .read('$recordsCollectionPath/$name/record');
      final record = Record.fromJson(jsonDecode(rawRecord));
      final allDataUploaded = await _uploadRecordData(record);
      if (allDataUploaded) {
        await _uploadRecord(record);
      }
    }
  }
}
