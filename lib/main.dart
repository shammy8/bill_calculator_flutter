import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/screens.dart';
import 'services/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print(e);
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    // print('error $_error');
    // print('init $_initialized');

    if (_error) {
      return MaterialApp(
        home: Scaffold(
          body: Text('Something went wrong'),
        ),
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return MaterialApp(
        home: Scaffold(
          body: Text('Loading'),
        ),
      );
    }

    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
            value: AuthService().user, initialData: null)
      ],
      child: MaterialApp(
        routes: {
          '/': (context) => LoginScreen(),
          '/bill': (context) => BillScreen(),
        },
        theme: ThemeData(brightness: Brightness.dark),
      ),
    );
  }
}
