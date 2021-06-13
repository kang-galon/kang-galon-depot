import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool _initialized;
  late FirebaseAuth _firebaseAuth;

  @override
  void initState() {
    // init
    _initialized = false;

    // init firebase
    _init();
    super.initState();
  }

  void _init() async {
    _firebaseAuth = FirebaseAuth.instance;

    // await for 3 second
    await Future.delayed(Duration(seconds: 3));

    setState(() => _initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: Builder(
              builder: (context) {
                return Text('Kang Galon Depot');
              },
            ),
          ),
        ),
      );
    }

    return (_firebaseAuth.currentUser == null) ? LoginScreen() : HomeScreen();
  }
}
