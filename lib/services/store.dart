import 'package:bill_calculator_flutter/services/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addBill(
      String userId, String name, List<String> friends, List<String> editors) {
    final Map<String, bool> formattedEditors = {userId: true};
    for (final editor in editors) {
      formattedEditors[editor] = true;
    }
    return _db.collection('bills').add({
      'name': name,
      'friends': friends,
      'editors': formattedEditors,
      'creator': userId
    });
  }

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

  Future<void> addItem(String billId, String description, num cost,
      String paidBy, List<dynamic> sharedBy, DateTime date) {
    final formattedSharedBy = sharedBy
        .map((e) => {
              'friend': e,
              'settled': e == paidBy,
            })
        .toList();
    return _db.collection('bills/$billId/items').add({
      'description': description,
      'cost': cost,
      'paidBy': paidBy,
      'sharedBy': formattedSharedBy,
      'date': date
    });
  }

  Future<void> updateItem(
      List<SharedByElement> sharedBy, String itemId, String billId) {
    final sharedByAsList = sharedBy.map((element) {
      return element.toJson();
    }).toList();
    return _db
        .doc('bills/$billId/items/$itemId')
        .update({'sharedBy': sharedByAsList});
  }
}
