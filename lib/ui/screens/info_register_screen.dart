import 'package:flutter/material.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';

class InfoRegisterScreen extends StatelessWidget {
  void _continueAction(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MapRegisterScreen()),
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
                    '1. Nama depot xxx',
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
                  onPressed: () => _continueAction(context),
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
