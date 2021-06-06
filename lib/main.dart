import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DepotBloc>(create: (_) => DepotBloc()),
      ],
      child: MaterialApp(
        title: 'Kang Galon Depot',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          accentColor: Colors.blue.shade400,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
