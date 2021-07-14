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
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextButton.icon(
                label: const Text(
                  'Sign out',
                  style: TextStyle(color: Colors.red),
                ),
                icon: const Icon(
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
              padding: const EdgeInsets.only(left: 8),
              child: TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: user?.uid));
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy UID to clipboard')),
            ),
            const Divider(),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Bill'),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: bills.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(bills[index].name),
                      // subtitle: Text(bills[index].creator),
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
