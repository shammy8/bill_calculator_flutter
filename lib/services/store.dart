import 'package:bill_calculator_flutter/services/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Bill>> getAllBills(String userId) {
    return _db
        .collection('bills')
        .where('editors.$userId', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((bill) => Bill.fromMap(bill.data(), bill.id))
            .toList());
  }

  // Stream<Bill> getBill(String billId) {
  //   return _db.doc('bills/$billId').snapshots().map((event) => null);
  // }
}
