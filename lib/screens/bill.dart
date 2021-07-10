import 'package:flutter/material.dart';
import 'package:bill_calculator_flutter/services/auth.dart';

class BillScreen extends StatelessWidget {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill'),
      ),
      body: (Container(
        child: ElevatedButton(
            child: Text('Log out'),
            onPressed: () {
              auth.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            }),
      )),
    );
  }
}
