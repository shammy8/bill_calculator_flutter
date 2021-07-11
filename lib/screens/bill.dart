import 'package:bill_calculator_flutter/shared/items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bill_calculator_flutter/services/services.dart';
import 'package:bill_calculator_flutter/shared/drawer.dart';
import 'package:bill_calculator_flutter/services/models.dart';

class BillScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  final String billId;
  BillScreen({required this.billId});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    // if (user == null) {
    //   Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    // }

    return MultiProvider(
      providers: [
        StreamProvider<List<Bill>>.value(
          value: StoreService().getAllBills(user!.uid),
          initialData: [],
        ),
        StreamProvider<List<Item>>.value(
          value: StoreService().getAllItems(billId),
          initialData: [],
        ),
      ],
      builder: (context, child) {
        final List<Bill> bills = context.watch<List<Bill>>();
        if (billId != 'empty') {
          Bill bill = bills.firstWhere((bill) => bill.uid == billId);
          return Scaffold(
            appBar: AppBar(),
            endDrawer: BillDrawer(),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(bill.name,
                          style: Theme.of(context).textTheme.headline5),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                        label: Text('Add Item'),
                      )
                    ],
                  ),
                  Items()
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(),
            endDrawer: BillDrawer(),
            body: Center(
              child: Text('Add or choose a bill'),
            ),
          );
        }
      },
    );
  }
}
