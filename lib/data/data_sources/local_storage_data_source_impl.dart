import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sendit/data/data_sources/local_storage_data_source.dart';

/// Implementation of [LocalStorageDataSource].
class LocalStorageDataSourceImpl implements LocalStorageDataSource {
  Future<String> get _documentPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Future<List<File>> listFiles(String path) async {
    final root = await _documentPath;
    return Directory('$root/$path').listSync().whereType<File>().toList();
  }

  @override
  Future<List<Directory>> listDirectories(String path) async {
    final root = await _documentPath;
    return Directory('$root/$path').listSync().whereType<Directory>().toList();
  }

  @override
  Future<void> write(String path, String data) async {
    final root = await _documentPath;
    final file = File('$root/$path');
    await file.create(recursive: true);
    await file.writeAsString(data);
  }

  @override
  Future<IOSink> writeContinously(String path) async {
    final root = await _documentPath;
    final file = File('$root/$path');
    await file.create(recursive: true);
    final sink = file.openWrite();
    return sink;
  }

  @override
  Future<String> read(String path) async {
    final root = await _documentPath;
    final file = File('$root/$path');
    return file.readAsString();
  }

  @override
  Future<File> getFile(String path) async {
    final root = await _documentPath;
    final file = File('$root/$path');
    return file;
  }

  @override
  Future<void> deleteFile(String path) async {
    final root = await _documentPath;
    final file = File('$root/$path');
    if (!(await file.exists())) {
      return;
    }
    await file.delete(recursive: true);
  }

  @override
  Future<void> deleteDirectory(String path) async {
    final root = await _documentPath;
    final directory = Directory('$root/$path');
    if (!(await directory.exists())) {
      return;
    }
    await directory.delete(recursive: true);
  }
}
