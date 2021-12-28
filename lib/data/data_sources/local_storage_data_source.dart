import 'dart:io';

/// Datasource for the file system of the device.
abstract class LocalStorageDataSource {
  /// Returns a list with all files stored in the directory at [path].
  Future<List<File>> listFiles(String path);

  /// Returns a list with all directories stored in the directory at [path].
  Future<List<Directory>> listDirectories(String path);

  /// Writes the [data] to a file at [path].
  Future<void> write(String path, String data);

  /// Saves a file at path [path].
  Future<IOSink> writeContinously(String path);

  /// Reads the file at [path].
  Future<String> read(String path);

  /// Returns the file at [path].
  Future<File> getFile(String path);

  /// Deletes the file at path.
  Future<void> deleteFile(String path);

  /// Deletes the directory at [path].
  Future<void> deleteDirectory(String path);
}
