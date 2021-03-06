import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';
import 'package:kang_galon_depot/ui/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late DepotBloc _depotBloc;
  late GlobalKey<FormState> _formKey;
  late TextEditingController _phoneController;
  late String? _errorText;

  @override
  void initState() {
    // init bloc
    _depotBloc = BlocProvider.of<DepotBloc>(context);

    // init
    _formKey = GlobalKey();
    _phoneController = TextEditingController();

    // set
    _errorText = null;

    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();

    super.dispose();
  }

  void _loginAction() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      String phone = '+62' + _phoneController.text.trim();
      _depotBloc.add(DepotCheckExisted(phoneNumber: phone));
    }
  }

  void _registerAction() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RegisterScreen()),
    );
  }

  String? _phoneValidator(String? value) {
    if (value != null && value.isEmpty) {
      return 'Wajib diisi';
    }

    if (value != null && value.length < 11) {
      return 'Minimal 11 angka';
    }

    return null;
  }

  void _loginBlocListener(BuildContext context, DepotState state) {
    if (state is DepotExistence) {
      // if exist already registered
      if (state.isExist) {
        String phone = '+62' + _phoneController.text.trim();

        // send otp
        _depotBloc.add(DepotSendOTP(phoneNumber: phone));
      } else {
        setState(() => _errorText = 'Nomor belum terdaftar');
      }
    }

    if (state is DepotSentOTPSuccess) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationOtpScreen(
              phoneNumber: state.phoneNumber,
              verificationId: state.verificationId,
              isLogin: true,
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<DepotBloc, DepotState>(
          listener: _loginBlocListener,
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
                      Image.asset('assets/images/phone.png'),
                      const SizedBox(height: 10.0),
                      Text(
                        'Masuk dengan nomor ponsel',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Masukkan nomor ponsel Anda\nkami akan mengirimkan OTP untuk memverifikasi',
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _phoneController,
                          maxLength: 11,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          validator: _phoneValidator,
                          decoration: Pallette.inputDecoration.copyWith(
                            hintText: '8xxxxx',
                            errorText: _errorText,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 15, 5, 15),
                              child: Text(
                                '+62',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        BlocBuilder<DepotBloc, DepotState>(
                          builder: (context, state) {
                            if (state is DepotLoading) {
                              return NormalButton.loading();
                            }

                            return NormalButton(
                              label: 'Masuk',
                              onPressed: _loginAction,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun ? '),
                    TextButton(
                      onPressed: _registerAction,
                      child: Text('Daftar'),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.zero),
                        minimumSize: MaterialStateProperty.all<Size>(Size.zero),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
