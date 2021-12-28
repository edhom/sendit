import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sendit/data/data_sources/ble_sensor_data_source.dart';
import 'package:sendit/data/data_sources/ble_sensor_data_source_impl.dart';
import 'package:sendit/data/data_sources/cloud_storage_data_source.dart';
import 'package:sendit/data/data_sources/cloud_storage_data_source_impl.dart';
import 'package:sendit/data/data_sources/database_data_source.dart';
import 'package:sendit/data/data_sources/database_data_source_impl.dart';
import 'package:sendit/data/data_sources/gps_data_source.dart';
import 'package:sendit/data/data_sources/gps_data_source_impl.dart';
import 'package:sendit/data/data_sources/local_sensor_data_source.dart';
import 'package:sendit/data/data_sources/local_sensor_data_source_impl.dart';
import 'package:sendit/data/data_sources/local_storage_data_source.dart';
import 'package:sendit/data/data_sources/local_storage_data_source_impl.dart';
import 'package:sendit/data/repositories/input_repo_impl.dart';
import 'package:sendit/data/repositories/location_repo_impl.dart';
import 'package:sendit/data/repositories/record_repo_impl.dart';
import 'package:sendit/data/repositories/sensor_repo_impl.dart';
import 'package:sendit/data/repositories/trail_repo_impl.dart';
import 'package:sendit/domain/repositories/input_repo.dart';
import 'package:sendit/domain/repositories/location_repo.dart';
import 'package:sendit/domain/repositories/record_repo.dart';
import 'package:sendit/domain/repositories/sensor_repo.dart';
import 'package:sendit/domain/repositories/trail_repo.dart';
import 'package:sendit/domain/usecases/add_ble_input.dart';
import 'package:sendit/domain/usecases/add_local_input.dart';
import 'package:sendit/domain/usecases/analyse_section.dart';
import 'package:sendit/domain/usecases/analyse_trail.dart';
import 'package:sendit/domain/usecases/create_sections.dart';
import 'package:sendit/domain/usecases/delete_record.dart';
import 'package:sendit/domain/usecases/get_distance.dart';
import 'package:sendit/domain/usecases/get_is_recording.dart';
import 'package:sendit/domain/usecases/get_recording_duration.dart';
import 'package:sendit/domain/usecases/load_records.dart';
import 'package:sendit/domain/usecases/load_trails.dart';
import 'package:sendit/domain/usecases/remove_input.dart';
import 'package:sendit/domain/usecases/scan_for_sensors.dart';
import 'package:sendit/domain/usecases/stream_sensors.dart';
import 'package:sendit/domain/usecases/start_recording.dart';
import 'package:sendit/domain/usecases/stop_recording.dart';
import 'package:sendit/domain/usecases/stream_inputs.dart';
import 'package:sendit/presentation/view_models/add_input_dialog_model_view_model.dart';
import 'package:sendit/presentation/view_models/find_sensors_view_model.dart';
import 'package:sendit/presentation/view_models/home_screen_view_model.dart';
import 'package:sendit/presentation/view_models/map_screen_view_model.dart';
import 'package:sendit/presentation/view_models/record_bar_view_model.dart';
import 'package:sendit/presentation/view_models/records_screen_view_model.dart';

// ------------------------------ View-models ----------------------------------

/// Provides an instance of the [HomeViewModel] view-model.
final homeScreenViewModelProvider = Provider.autoDispose<HomeViewModel>((ref) {
  return HomeViewModel(
    ref.read(streamInputsProvider),
    ref.read(removeInputProvider),
  );
});

/// Provides an instance of the [FindSensorsViewModel] view-model.
final findSensorsViewModelProvider =
    Provider.autoDispose<FindSensorsViewModel>((ref) {
  return FindSensorsViewModel(
    ref.read(scanForSensorsProvider),
    ref.read(showAvailableSensorsProvider),
    ref.read(addInputProvider),
    ref.read(addLocalSensorProvider),
  );
});

/// Provides an instance of the [RecordBarViewModel] view-model.
final recordBarViewModelProvider =
    Provider.autoDispose<RecordBarViewModel>((ref) {
  return RecordBarViewModel(
    ref.read(startRecordingProvider),
    ref.read(stopRecordingProvider),
    ref.watch(getIsRecordingProvider),
    ref.watch(getRecordingDurationProvider),
  );
});

/// Provides an instance of the [AddInputDialogViewModel] view-model.
final addInputDialogViewModelProvider =
    ChangeNotifierProvider.autoDispose<AddInputDialogViewModel>((ref) {
  return AddInputDialogViewModel();
});

/// Provides an instance of the [MapScreenViewModel] view-model.
final mapScreenViewModelProvider =
    ChangeNotifierProvider.autoDispose<MapScreenViewModel>((ref) {
  return MapScreenViewModel(ref.read(loadTrailsProvider));
});

/// Provides an instance of the [RecordsScreenViewModel] view-model.
final recordsScreenViewModelProvider =
    ChangeNotifierProvider.autoDispose<RecordsScreenViewModel>((ref) {
  return RecordsScreenViewModel(
    ref.read(loadRecordsProvider),
    ref.read(analyseTrailProvider),
    ref.read(deleteRecordProvider),
  )..init();
});

// ------------------------------- Use-cases -----------------------------------

/// Provides an instance of the [StreamSensors] use-case.
final showAvailableSensorsProvider =
    Provider.autoDispose<StreamSensors>((ref) {
  return StreamSensors(ref.read(sensorRepoProvider));
});

/// Provides an instance of the [ScanForSensors] use-case.
final scanForSensorsProvider = Provider.autoDispose<ScanForSensors>((ref) {
  return ScanForSensors(ref.read(sensorRepoProvider));
});

/// Provides an instance of the [StreamInputs] use-case.
final streamInputsProvider = Provider.autoDispose<StreamInputs>((ref) {
  return StreamInputs(ref.read(inputRepoProvider));
});

/// Provides an instance of the [AddBleInput] use-case.
final addInputProvider = Provider.autoDispose<AddBleInput>((ref) {
  return AddBleInput(ref.read(inputRepoProvider));
});

/// Provides an instance of the [RemoveInput] use-case.
final removeInputProvider = Provider.autoDispose<RemoveInput>((ref) {
  return RemoveInput(ref.read(inputRepoProvider));
});

/// Provides an instance of the [AddLocalInput] use-case.
final addLocalSensorProvider = Provider.autoDispose<AddLocalInput>((ref) {
  return AddLocalInput(ref.read(inputRepoProvider));
});

/// Provides an instance of the [StartRecording] use-case.
final startRecordingProvider = Provider.autoDispose<StartRecording>((ref) {
  return StartRecording(
    ref.read(inputRepoProvider),
    ref.read(recordRepoProvider),
    ref.read(analyseTrailProvider),
  );
});

/// Provides an instance of the [GetDistance] use-case.
final getDistanceProvider = Provider.autoDispose<GetDistance>((ref) {
  return GetDistance(ref.read(locationRepoProvider));
});

/// Provides an instance of the [StopRecording] use-case.
final stopRecordingProvider = Provider.autoDispose<StopRecording>((ref) {
  return StopRecording(
    ref.read(inputRepoProvider),
    ref.read(recordRepoProvider),
    ref.read(analyseTrailProvider),
  );
});

/// Provides an instance of the [GetIsRecording] use-case.
final getIsRecordingProvider = Provider.autoDispose<GetIsRecording>((ref) {
  return GetIsRecording(
    ref.watch(recordRepoProvider),
  );
});

/// Provides an instance of the [GetRecordingDuration] use-case.
final getRecordingDurationProvider =
    Provider.autoDispose<GetRecordingDuration>((ref) {
  return GetRecordingDuration(
    ref.watch(recordRepoProvider),
  );
});

/// Provides an instance of the [AnalyseTrail] use-case.
final analyseTrailProvider = Provider<AnalyseTrail>((ref) {
  return AnalyseTrail(
    ref.read(getIsRecordingProvider),
    ref.read(trailRepoProvider),
    ref.read(recordRepoProvider),
    ref.read(locationRepoProvider),
    ref.read(calcSectionsDifficultyProvider),
  );
});

/// Provides an instance of the [CreateSections] use-case.
final createSectionsProvider = Provider.autoDispose<CreateSections>((ref) {
  return CreateSections(ref.read(getDistanceProvider));
});

/// Provides an instance of the [CalcSectionDifficulty] use-case.
final calcSectionsDifficultyProvider =
    Provider.autoDispose<CalcSectionDifficulty>((ref) {
  return CalcSectionDifficulty();
});

/// Provides an instance of the [LoadTrails] use-case.
final loadTrailsProvider = Provider.autoDispose<LoadTrails>((ref) {
  return LoadTrails(ref.read(trailRepoProvider));
});

/// Provides an instance of the [LoadRecords] use-case.
final loadRecordsProvider = Provider.autoDispose<LoadRecords>((ref) {
  return LoadRecords(ref.read(recordRepoProvider));
});

/// Provides an instance of the [DeleteRecord] use-case.
final deleteRecordProvider = Provider.autoDispose<DeleteRecord>((ref) {
  return DeleteRecord(ref.read(recordRepoProvider));
});

// ----------------------------- Repositories ----------------------------------

/// Provides an instance of [SensorRepo].
final sensorRepoProvider = Provider<SensorRepo>((ref) {
  return SensorRepoImpl(
    ref.read(bleSensorDataSourceProvider),
    ref.read(localSensorDataSourceProvider),
  );
});

/// Provides an instance of [InputRepo].
final inputRepoProvider = Provider<InputRepo>((ref) {
  return InputRepoImpl();
});

/// Provides an instance of [RecordRepo].
final recordRepoProvider = Provider<RecordRepo>((ref) {
  return RecordRepoImpl(
    ref.read(cloudStorageDataSourceProvider),
    ref.read(databaseDataSourceProvider),
    ref.read(localStorageDataSourceProvider),
  );
});

/// Provides an instance of [LocationRepo].
final locationRepoProvider = Provider<LocationRepo>((ref) {
  return LocationRepoImpl(ref.read(gpsDataSourceProvider));
});

/// Provides an instance of [TrailRepoImpl].
final trailRepoProvider = Provider<TrailRepo>((ref) {
  return TrailRepoImpl(ref.read(databaseDataSourceProvider));
});

// ----------------------------- Data-sources ----------------------------------

/// Provides an instance of [BleSensorDataSource].
final bleSensorDataSourceProvider = Provider<BleSensorDataSource>((ref) {
  return BleSensorDataSourceImpl();
});

/// Provides an instance of [CloudStorageDataSource].
final cloudStorageDataSourceProvider = Provider<CloudStorageDataSource>((ref) {
  return CloudStorageDataSourceImpl();
});

/// Provides an instance of [DatabaseDataSource].
final databaseDataSourceProvider = Provider<DatabaseDataSource>((ref) {
  return DatabaseDataSourceImpl();
});

/// Provides an instance of [LocalStorageDataSource].
final localStorageDataSourceProvider = Provider<LocalStorageDataSource>((ref) {
  return LocalStorageDataSourceImpl();
});

/// Provides an instance of [GpsDataSource].
final gpsDataSourceProvider = Provider<GpsDataSource>((ref) {
  return GpsDataSourceImpl();
});

/// Provides an instance of [LocalSensorDataSource].
final localSensorDataSourceProvider = Provider<LocalSensorDataSource>((ref) {
  return LocalSensorDataSourceImpl(ref.read(gpsDataSourceProvider));
});
