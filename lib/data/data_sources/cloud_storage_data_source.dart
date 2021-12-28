import 'dart:io';

/// Datasource for accessing storage in the cloud.
abstract class CloudStorageDataSource {
  /// Uploads a file to cloud storage at the given [path].
  Future<void> uploadFile(String path, File file);

  /// Deletes the file at [path] from cloud storage.
  Future<void> deleteFile(String path);
}
