import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';
import 'package:kang_galon_depot/models/models.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';
import 'package:pinput/pin_put/pin_put.dart';

class VerificationOtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const VerificationOtpScreen(
      {Key? key, required this.verificationId, required this.phoneNumber})
      : super(key: key);

  @override
  _VerificationOtpScreenState createState() => _VerificationOtpScreenState();
}

class _VerificationOtpScreenState extends State<VerificationOtpScreen> {
  late DepotBloc _depotBloc;

  @override
  void initState() {
    // init bloc
    _depotBloc = BlocProvider.of<DepotBloc>(context);

    super.initState();
  }

  void _pinSubmitAction(String pin) {
    FocusScope.of(context).unfocus();

    _depotBloc.add(DepotVerifyOTP(
      otp: pin,
      verificationId: widget.verificationId,
    ));
  }

  void _verificationBlocListener(BuildContext context, DepotState state) {
    if (state is DepotVerifyOTPSuccess) {
      // add to bloc
      _depotBloc.add(
        DepotRegisterProcessed(
          depotRegister: DepotRegister(
            token: state.token,
            uid: state.uid,
            deviceId: state.deviceId,
            // phoneNumber: phone,
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RegisterInfoScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<DepotBloc, DepotState>(
          listener: _verificationBlocListener,
          child: Center(
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
                        'Masukkan OTP yang telah dikirim ke ' +
                            widget.phoneNumber,
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
                  child: Column(
                    children: [
                      PinPut(
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
                        onSubmit: _pinSubmitAction,
                      ),
                      BlocBuilder<DepotBloc, DepotState>(
                        builder: (context, state) {
                          if (state is DepotLoading) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: CircularProgressIndicator(),
                            );
                          }

                          return SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
