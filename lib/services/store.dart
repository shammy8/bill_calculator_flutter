import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllBills(String userId) {
    return _db
        .collection('bills')
        .where('editors.$userId', isEqualTo: true)
        .snapshots();
  }
}
