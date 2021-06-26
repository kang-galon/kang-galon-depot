import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';

class RegisterInfoScreen extends StatefulWidget {
  @override
  _RegisterInfoScreenState createState() => _RegisterInfoScreenState();
}

class _RegisterInfoScreenState extends State<RegisterInfoScreen> {
  late DepotBloc _depotBloc;
  late String _depotName;

  @override
  void initState() {
    // init bloc
    _depotBloc = BlocProvider.of<DepotBloc>(context);

    // set
    DepotState state = _depotBloc.state;
    if (state is DepotRegisterInProcess) {
      _depotName = state.depotRegister.name!;
    }

    super.initState();
  }

  void _continueAction() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RegisterMapScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Selamat datang di\nKang Galon',
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40.0),
              Text('Berikut data mengenai depot anda'),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(
                    '1. Nama depot ' + _depotName,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(width: 10.0),
                  Icon(Icons.check, color: Colors.green),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(
                    '2. Lokasi depot berada',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(width: 10.0),
                  Icon(Icons.pending_actions, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(
                    '3. Foto dari depot',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(width: 10.0),
                  Icon(Icons.pending_actions, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 20.0),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: _continueAction,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Lanjut'),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
