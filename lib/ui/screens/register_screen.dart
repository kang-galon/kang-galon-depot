import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/event_states/depot_event.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';
import 'package:kang_galon_depot/models/models.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';
import 'package:kang_galon_depot/ui/widgets/normal_button.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late GlobalKey<FormState> _formKey;
  late DepotBloc _depotBloc;
  late TextEditingController _depotNameController;
  late TextEditingController _phoneController;
  late String? _errorText;

  @override
  void initState() {
    // init bloc
    _depotBloc = BlocProvider.of<DepotBloc>(context);

    // init
    _formKey = GlobalKey();
    _depotNameController = TextEditingController();
    _phoneController = TextEditingController();

    // set
    _errorText = null;

    super.initState();
  }

  @override
  void dispose() {
    _depotNameController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  void _registerAction() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      // check phone number
      String phone = '+62' + _phoneController.text.trim();
      _depotBloc.add(DepotCheckExisted(phoneNumber: phone));
    }
  }

  void _loginAction() {
    Navigator.pop(context);
  }

  void _registerBlocListener(BuildContext context, DepotState state) async {
    if (state is DepotExistence) {
      // if exist already registered
      if (state.isExist) {
        setState(() => _errorText = 'Nomor sudah terdaftar');
      } else {
        String depotName = _depotNameController.text.trim();
        String phone = '+62' + _phoneController.text.trim();

        // add to bloc
        _depotBloc.add(
          DepotRegisterProcessed(
            depotRegister: DepotRegister(name: depotName, phoneNumber: phone),
          ),
        );

        await _depotBloc.sendOtp(
          phone,
          (err) {
            print(err);
          },
          (verificationId, forceResendingToken) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => VerificationOtpScreen(
                    phoneNumber: phone,
                    verificationId: verificationId,
                    isLogin: false,
                  ),
                ));
          },
        );
      }
    }
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

  String? _depotNameValidator(String? value) {
    if (value != null && value.isEmpty) {
      return 'Wajib diisi';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<DepotBloc, DepotState>(
          listener: _registerBlocListener,
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
                        'Daftar dengan nomor ponsel',
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
                          controller: _depotNameController,
                          validator: _depotNameValidator,
                          decoration: Pallette.inputDecoration
                              .copyWith(hintText: 'Nama depot'),
                        ),
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: _phoneController,
                          maxLength: 11,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          validator: _phoneValidator,
                          decoration: Pallette.inputDecoration.copyWith(
                            hintText: '8xxxx',
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
                              label: 'Daftar',
                              onPressed: _registerAction,
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
                    Text('Sudah punya akun ? '),
                    TextButton(
                      onPressed: _loginAction,
                      child: Text('Masuk'),
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
