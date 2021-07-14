import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:bill_calculator_flutter/services/auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthService auth = AuthService();

  late StreamSubscription<User?>
      subscription; // TODO is using late correct here

  @override
  void initState() {
    super.initState();
    subscription = auth.user.listen(
      (user) {
        if (user != null) {
          Navigator.pushReplacementNamed(context, '/bill', arguments: 'empty');
        }
      },
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const FlutterLogo(
              size: 150,
            ),
            Text(
              'Login to Start',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            LoginButton(
              text: 'Login with Google',
              icon: FontAwesomeIcons.google,
              color: Colors.black,
              loginMethod: auth.googleSignIn,
            ),
            LoginButton(
              text: 'Login as Guest',
              loginMethod: auth.anonLogin,
              icon: Icons.face,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Color? color;
  final Function loginMethod;

  const LoginButton(
      {required this.text, this.icon, this.color, required this.loginMethod});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextButton.icon(
        // padding: EdgeInsets.all(30),
        onPressed: () async {
          final user = await loginMethod();
          if (user != null) {
            Navigator.pushReplacementNamed(context, '/bill',
                arguments: 'empty');
          }
        },
        icon: Icon(icon, color: Colors.white),
        style: TextButton.styleFrom(
            backgroundColor: color, padding: const EdgeInsets.all(30)),
        label: Expanded(
          child: Text(
            text ?? '',
            textAlign: TextAlign.center,
            textScaleFactor: 1.3,
          ),
        ),
      ),
    );
  }
}
