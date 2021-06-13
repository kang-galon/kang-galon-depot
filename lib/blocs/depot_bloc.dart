import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';
import 'package:kang_galon_depot/exceptions/unauthorized_exception.dart';
import 'package:kang_galon_depot/models/models.dart';
import 'package:kang_galon_depot/services/services.dart';

class DepotBloc extends Bloc<DepotEvent, DepotState> {
  final FirebaseAuth _firebaseAuth;
  final ErrorBloc _errorBloc;
  DepotRegister? _depotRegister;

  DepotBloc(this._errorBloc)
      : this._firebaseAuth = FirebaseAuth.instance,
        super(DepotInitial());

  @override
  Stream<DepotState> mapEventToState(DepotEvent event) async* {
    try {
      if (event is DepotRegisterProcessed) {
        yield DepotLoading();

        if (_depotRegister == null) {
          _depotRegister = DepotRegister();
        }

        // merge depot object
        _depotRegister =
            DepotRegister.merge(_depotRegister!, event.depotRegister);

        yield DepotRegisterInProcess(depotRegister: _depotRegister!);
      }

      if (event is DepotRegistered) {
        yield DepotLoading();

        DepotRegister depotRegister = event.depotRegister;

        await DepotService.depotRegister(depotRegister);

        yield DepotRegisteredSuccess();
      }

      if (event is DepotGetProfile) {
        yield DepotLoading();

        Depot depot = await DepotService.getProfile();

        yield DepotGetProfileSuccess(depot: depot);
      }

      if (event is DepotUpdateStatus) {
        yield DepotLoading();

        if (event.status) {
          await DepotService.updateStatusOpen();
        } else {
          await DepotService.updateStatusClose();
        }

        Depot depot = await DepotService.getProfile();
        yield DepotGetProfileSuccess(depot: depot);
      }

      if (event is DepotUpdateProfileProcessed) {
        yield DepotLoading();

        yield DepotUpdateProfileInProcess(depot: event.depot);
      }

      if (event is DepotUpdateProfile) {
        yield DepotLoading();

        Depot depot = await DepotService.updateProfile(event.depot);

        yield DepotGetProfileSuccess(depot: depot);
      }

      if (event is DepotCheckExisted) {
        yield DepotLoading();

        bool isExist = await DepotService.isDepotExist(event.phoneNumber);

        yield DepotExistence(isExist: isExist);
      }

      if (event is DepotVerifyOTP) {
        yield DepotLoading();

        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: event.verificationId,
          smsCode: event.otp,
        );

        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        User user = userCredential.user!;
        String jwtToken = await user.getIdToken();
        String uid = user.uid;
        String deviceId = (await FirebaseMessaging.instance.getToken())!;

        yield DepotVerifyOTPSuccess(
            token: jwtToken, uid: uid, deviceId: deviceId);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        _errorBloc.add(ErrorShow(message: 'Kode OTP Salah'));
      }
      yield DepotError();
    } on UnauthorizedException {
      await _firebaseAuth.signOut();

      _errorBloc.add(ErrorUnauthorized());
      yield DepotError();
    } catch (e) {
      print(e);

      _errorBloc.add(ErrorShow(message: e.toString()));
      yield DepotError();
    }
  }

  Future<void> sendOtp(
    String phoneNumber,
    void Function(FirebaseAuthException) verificationFailed,
    void Function(String verificationId, int? forceResendingToken) codeSent,
  ) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationFailed: verificationFailed,
      codeSent: codeSent,
    );
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
