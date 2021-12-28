import 'package:flutter/cupertino.dart';
import 'package:sendit/domain/entities/record.dart';
import 'package:sendit/domain/usecases/analyse_trail.dart';
import 'package:sendit/domain/usecases/delete_record.dart';
import 'package:sendit/domain/usecases/load_records.dart';

/// View model for the [RecordsScreen].
class RecordsScreenViewModel extends ChangeNotifier {
  /// Constructs a [RecordsScreenViewModel].
  RecordsScreenViewModel(
    this._loadRecords,
    this._analyseTrail,
    this._deleteRecord,
  );

  /// The records to show.
  List<Record> records = [];

  final LoadRecords _loadRecords;

  final AnalyseTrail _analyseTrail;

  final DeleteRecord _deleteRecord;

  /// Initializes the [RecordsScreenViewModel].
  Future<void> init() async {
    records = await _loadRecords();
    notifyListeners();
  }

  /// Analyses the selected record.
  Future<void> analyse(Record record) async {
    // _analyseTrail(record);
  }

  /// Deletes the record.
  Future<void> deleteRecord(Record record) async {
    await _deleteRecord(record);
    init();
  }
}
