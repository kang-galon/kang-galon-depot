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
  final SnackbarBloc _snackbarBloc;
  DepotRegister? _depotRegister;

  DepotBloc(this._snackbarBloc)
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

      if (event is DepotSendOTP) {
        yield DepotLoading();

        await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: event.phoneNumber,
          verificationCompleted: (credential) {},
          codeAutoRetrievalTimeout: (verificationId) {},
          verificationFailed: (err) => throw err,
          codeSent: (verificationId, forceResendingToken) {
            this.add(
              DepotSendOTPSuccessTrigger(
                  phoneNumber: event.phoneNumber,
                  verificationId: verificationId),
            );
          },
        );
      }

      if (event is DepotSendOTPSuccessTrigger) {
        _snackbarBloc
            .add(SnackbarShow(message: 'OTP berhasil dikirm', isError: false));

        yield DepotSentOTPSuccess(
            phoneNumber: event.phoneNumber,
            verificationId: event.verificationId);
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
        _snackbarBloc.add(SnackbarShow(message: 'Kode OTP Salah'));
      } else if (e.code == 'too-many-requests') {
        _snackbarBloc.add(SnackbarShow(
            message: 'OTP gagal dikirim, permintaan terlalu banyak'));
      } else {
        _snackbarBloc.add(SnackbarShow(message: 'OTP gagal dikirim'));
      }

      yield DepotError();
    } on UnauthorizedException {
      await _firebaseAuth.signOut();

      _snackbarBloc.add(SnackbarUnauthorized());
      yield DepotError();
    } catch (e) {
      print('DepotBloc - $e');

      _snackbarBloc.add(SnackbarShow(message: e.toString()));
      yield DepotError();
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
