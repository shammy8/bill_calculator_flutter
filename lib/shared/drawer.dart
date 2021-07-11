import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bill_calculator_flutter/services/models.dart';

class BillDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bills = context.watch<List<Bill>>();

    return Drawer(
      child: ListView.builder(
          itemCount: bills.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(bills[index].name),
              subtitle: Text(bills[index].creator),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/bill',
                    arguments: bills[index].uid);
              },
            );
          }),
    );
  }
}
