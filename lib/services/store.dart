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

  Stream<List<Item>> getAllItems(String billId) {
    return _db.collection('bills/$billId/items').snapshots().map((snapshot) =>
        snapshot.docs
            .map((item) => Item.fromMap(item.data(), item.id))
            .toList());
  }

  // Future<String>
  updateItem(List<SharedByElement> sharedBy, String itemId, String billId) {
    print(sharedBy[0].friend);
    print(sharedBy[0].settled);
    // print(sharedBy[1].friend);
    // print(sharedBy[1].settled);
    // sharedBy.toString().
    // return _db
    //     .doc('bills/$billId/items/$itemId')
    //     .update({'sharedBy': sharedBy});
  }
}
