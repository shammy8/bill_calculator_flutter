import 'package:bill_calculator_flutter/screens/screens.dart';
import 'package:flutter/material.dart';
// import 'package:bill_calculator_flutter/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/bill':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => BillScreen(billId: args),
          );
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(child: Text('Error')),
      );
    });
  }
}
