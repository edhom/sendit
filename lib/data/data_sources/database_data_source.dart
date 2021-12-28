/// Datasource for accessing a remote database.
abstract class DatabaseDataSource {
  /// Creates a new document in the [collectionIdentifier] collection
  /// with the provided [data].
  Future<void> add(String documentIdentifier, Map<String, dynamic> data);

  /// Returns the query result as a list.
  Future<List<Map<String, dynamic>>> getAll(String collectionIdentifier);

  /// Deletes the document with [documentIdentifier].
  Future<void> delete(String documentIdentifier);

  /// Creates a new document and returns the identifier.
  String newDoc(String collectionIdentifier);
}
