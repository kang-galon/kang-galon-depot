import 'package:flutter/material.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kang Galon Depot',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      // home: SplashScreen(),
      home: PhotoRegisterScreen(),
    );
  }
}
