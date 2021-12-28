import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sendit/data/data_sources/database_data_source.dart';

/// Implementation of [DatabaseDataSource].
class DatabaseDataSourceImpl implements DatabaseDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> add(String documentIdentifier, Map<String, dynamic> data) async {
    _firestore.doc(documentIdentifier).set(data);
    return;
  }

  @override
  Future<List<Map<String, dynamic>>> getAll(String collectionIdentifier) async {
    final snapshot = await _firestore.collection(collectionIdentifier).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<void> delete(String documentIdentifier) {
    return _firestore.doc(documentIdentifier).delete();
  }

  @override
  String newDoc(String collectionIdentifier) {
    return _firestore.collection(collectionIdentifier).doc().path;
  }
}
