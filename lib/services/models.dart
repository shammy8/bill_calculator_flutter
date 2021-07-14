import 'package:cloud_firestore/cloud_firestore.dart';

class Bill {
  String uid;
  String name;
  List<String> friends;
  Map<String, bool> editors;
  String creator;

  Bill(
      {required this.uid,
      required this.name,
      required this.friends,
      required this.editors,
      required this.creator});

  // factory returns an instance of a class
  factory Bill.fromMap(Map data, String billId) {
    return Bill(
      creator: data['creator'] as String? ?? '',
      uid: billId,
      friends: (data['friends'] as List).map((e) => e as String).toList(),
      editors: (data['editors'] as Map)
          .map((key, value) => MapEntry(key as String, value as bool)),
      name: data['name'] as String? ?? '',
    );
  }
}

class Item {
  String id;
  String description;
  num cost;
  String paidBy;
  Timestamp date;
  List<SharedByElement> sharedBy;

  Item(
      {required this.description,
      required this.id,
      required this.cost,
      required this.paidBy,
      required this.date,
      required this.sharedBy});

  factory Item.fromMap(Map data, String itemId) {
    return Item(
      id: itemId,
      description: data['description'] as String? ?? '',
      cost: data['cost'] as num? ?? 0.0,
      paidBy: data['paidBy'] as String? ?? '',
      date: data['date'] as Timestamp? ?? Timestamp(0, 0),
      sharedBy: (data['sharedBy'] as List)
          .map((v) => SharedByElement.fromMap(v as Map<dynamic, dynamic>))
          .toList(),
    );
  }
}

class SharedByElement {
  String friend = '';
  bool settled = false;
  SharedByElement({required this.friend, required this.settled});

  factory SharedByElement.fromMap(Map data) {
    return SharedByElement(
        friend: data['friend'] as String? ?? '',
        settled: data['settled'] as bool? ?? false);
  }

  Map<String, dynamic> toJson() {
    return {'friend': friend, 'settled': settled};
  }
}

// class BillWithItems extends Bill {
//   List<Item> item = [];
//   BillWithItems() {
//     super()
//   };
// }
