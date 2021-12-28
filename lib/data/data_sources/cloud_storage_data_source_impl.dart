import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:sendit/data/data_sources/cloud_storage_data_source.dart';

/// Implementation of [CloudStorageDataSource].
class CloudStorageDataSourceImpl implements CloudStorageDataSource {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<void> uploadFile(String path, File file) async {
    await _storage.ref(path).putFile(file);
  }

  @override
  Future<void> deleteFile(String path) async {
    return _storage.ref(path).delete();
  }
}
