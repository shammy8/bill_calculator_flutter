import 'package:flutter/material.dart';
import 'package:bill_calculator_flutter/services/models.dart';

class CalculateScreen extends StatelessWidget {
  final Bill bill;
  final List<Item> items;

  const CalculateScreen({required this.bill, required this.items, Key? key})
      : super(key: key);

  // createMapWithEveryone() {
  //   final map = {};
  //   items.
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text('hi'),
      ),
    );
  }
}
