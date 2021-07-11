import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bill_calculator_flutter/services/services.dart';

class BillScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    // if (user == null) {
    //   Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    // }

    return StreamProvider<QuerySnapshot?>.value(
      value: StoreService().getAllBills(user!.uid),
      initialData: null,
      builder: (context, child) {
        final bills = context.watch<QuerySnapshot?>();

        return Scaffold(
          appBar: AppBar(
            title: Text('Bill'),
          ),
          endDrawer: Drawer(),
          body: ListView.builder(
              itemCount: bills?.size,
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    bills?.docs[index].data() as Map<String, dynamic>;
                print(data.toString());
                return ListTile(
                  title: Text(data['name']),
                  subtitle: Text(data['creator']),
                );
              }),
        );
      },
    );
  }
}
