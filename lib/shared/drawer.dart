import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:bill_calculator_flutter/services/models.dart';

class BillDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bills = context.watch<List<Bill>>();
    print(bills);
    return Drawer(
      child: ListView.builder(
          itemCount: bills.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(bills[index].name),
              subtitle: Text(bills[index].creator),
            );
          }),
    );
  }
}
