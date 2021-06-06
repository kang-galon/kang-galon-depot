import 'package:equatable/equatable.dart';
import 'package:kang_galon_depot/models/models.dart';

abstract class DepotEvent extends Equatable {
  DepotEvent();
}

class DepotRegisterProcessed extends DepotEvent {
  final DepotRegister depotRegister;

  DepotRegisterProcessed({required this.depotRegister});

  @override
  List<Object?> get props => [depotRegister];
}

class DepotRegistered extends DepotEvent {
  final DepotRegister depotRegister;

  DepotRegistered({required this.depotRegister});

  @override
  List<Object?> get props => [depotRegister];
}

class DepotCheckExisted extends DepotEvent {
  final String phoneNumber;

  DepotCheckExisted({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class DepotSentOTP extends DepotEvent {
  final String phoneNumber;

  DepotSentOTP({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class DepotVerifyOTP extends DepotEvent {
  final String otp;
  final String verificationId;

  DepotVerifyOTP({required this.otp, required this.verificationId});

  @override
  List<Object?> get props => [otp, verificationId];
}
