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
  factory Bill.fromMap(Map data) {
    return Bill(
      creator: data['creator'] ?? '',
      uid: data['uid'] ?? '',
      friends: data['friends'] ?? [],
      editors: data['editors'] ?? {},
      name: data['name'] ?? '',
    );
  }
}

class Item {
  String description;
  double cost;
  String paidBy;
  DateTime date;
  List<SharedBy> sharedBy;

  Item(
      {required this.description,
      required this.cost,
      required this.paidBy,
      required this.date,
      required this.sharedBy});

  factory Item.fromMap(Map data) {
    return Item(
      description: data['description'] ?? '',
      cost: data['cost'] ?? 0,
      paidBy: data['paidBy'] ?? '',
      date: data['date'] ?? DateTime.now(),
      sharedBy:
          (data['sharedBy'] as List).map((v) => SharedBy.fromMap(v)).toList(),
    );
  }
}

class SharedBy {
  String friend = '';
  bool settled = false;
  SharedBy({required this.friend, required this.settled});

  factory SharedBy.fromMap(Map data) {
    return SharedBy(
        friend: data['friend'] ?? '', settled: data['settled'] ?? false);
  }
}

// class BillWithItems extends Bill {
//   List<Item> item = [];
//   BillWithItems() {
//     super()
//   };
// }
