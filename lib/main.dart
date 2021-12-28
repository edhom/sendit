import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sendit/constants/strings.dart';
import 'package:sendit/presentation/screens/loading_screen.dart';
import 'package:sendit/presentation/screens/navigation_scaffold.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: SendITApp(),
    ),
  );
}

/// The root of the app.
class SendITApp extends StatefulWidget {
  /// Constructs a [SendITApp].
  const SendITApp({Key? key}) : super(key: key);

  @override
  _SendITAppState createState() => _SendITAppState();
}

class _SendITAppState extends State<SendITApp> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await FirebaseAuth.instance.signInAnonymously();
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppTitle,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: _initialized ? const NavigationScaffold() : const LoadingScreen(),
    );
  }
}
