import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';
import 'package:kang_galon_depot/ui/widgets/snackbar.dart';

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
    return SafeArea(
      child: Scaffold(
        body: BlocListener<SnackbarBloc, SnackbarState>(
          listener: (context, state) {
            // handle unauthorized user and send back to splash screen
            if (state is SnackbarUnauthorizedShowing) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => SplashScreen()),
                (route) => false,
              );

              showSnackbar(context, state.message, isError: true);
            }

            if (state is SnackbarShowing) {
              showSnackbar(context, state.message, isError: state.isError);
            }
          },
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (!_initialized) {
      return Center(child: Text('Kang Galon Depot'));
    }
    return (_firebaseAuth.currentUser == null) ? LoginScreen() : HomeScreen();
  }
}
