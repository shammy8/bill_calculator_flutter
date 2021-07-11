import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bill_calculator_flutter/services/models.dart';
import 'package:bill_calculator_flutter/services/auth.dart';

class BillDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final bills = context.watch<List<Bill>>();
    final user = context.watch<User?>();

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: TextButton.icon(
                label: Text(
                  'Sign out',
                  style: TextStyle(color: Colors.red),
                ),
                icon: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                onPressed: () async {
                  await auth.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: user?.uid));
                  },
                  icon: Icon(Icons.copy),
                  label: Text('Copy UID to clipboard')),
            ),
            Divider(),
            Expanded(
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
            ),
          ],
        ),
      ),
    );
  }
}
