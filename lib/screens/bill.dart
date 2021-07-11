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

    return StreamProvider<List<Bill>>.value(
      value: StoreService().getAllBills(user!.uid),
      initialData: [],
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(),
          endDrawer: BillDrawer(),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('hi', style: Theme.of(context).textTheme.headline5),
                    Text(billId, style: Theme.of(context).textTheme.headline5)
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
