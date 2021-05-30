import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kang_galon_depot/ui/configs/pallette.dart';
import 'package:kang_galon_depot/ui/screens/screens.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _depotNameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    // init
    _formKey = GlobalKey();
    _depotNameController = TextEditingController();
    _phoneController = TextEditingController();

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

      String depotName = _depotNameController.text.trim();
      String phone = '+62' + _phoneController.text.trim();

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationOtpScreen(phoneNumber: phone),
          ));
    }
  }

  void _loginAction() {
    Navigator.pop(context);
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
                      ElevatedButton(
                        onPressed: _registerAction,
                        child: Text('Daftar'),
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
    );
  }
}
