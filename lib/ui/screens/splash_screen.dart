import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';
import 'package:kang_galon_depot/ui/widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool _initialized;
  late bool _error;

  @override
  void initState() {
    // init
    _initialized = false;
    _error = false;

    // init firebase
    _initializedFlutterFire();
    super.initState();
  }

  void _initializedFlutterFire() async {
    try {
      await Firebase.initializeApp();

      // await for 3 second
      await Future.delayed(Duration(seconds: 3));

      setState(() => _initialized = true);
    } catch (e) {
      print(e);
      setState(() => _error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: Builder(
              builder: (context) {
                if (_error) {
                  showSnackbar(context, 'Ops... something went wrong');
                }

                return Text('Kang Galon Depot');
              },
            ),
          ),
        ),
      );
    }

    return LoginScreen();
  }
}
