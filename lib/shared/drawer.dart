import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class BillDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bills = context.watch<QuerySnapshot?>();

    return Drawer(
      child: ListView.builder(
          itemCount: bills?.size,
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
                bills?.docs[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['name']),
              subtitle: Text(data['creator']),
            );
          }),
    );
  }
}
