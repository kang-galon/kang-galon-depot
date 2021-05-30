import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';
import 'package:pinput/pin_put/pin_put.dart';

class VerificationOtpScreen extends StatelessWidget {
  final String phoneNumber;

  const VerificationOtpScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  void _pinSubmitAction(BuildContext context, String pin) {
    FocusScope.of(context).unfocus();

    print(pin);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => InfoRegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                width: 100.0,
                child: Column(
                  children: [
                    Image.asset('assets/images/verification.png'),
                    const SizedBox(height: 10.0),
                    Text(
                      'Verifikasi',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Masukkan OTP yang telah dikirim ke ' + phoneNumber,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 30.0,
                ),
                decoration: Pallette.containerBoxDecoration,
                child: PinPut(
                  fieldsCount: 6,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  submittedFieldDecoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  selectedFieldDecoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurpleAccent),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  followingFieldDecoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.deepPurpleAccent.withOpacity(.5),
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  onSubmit: (pin) => _pinSubmitAction(context, pin),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
