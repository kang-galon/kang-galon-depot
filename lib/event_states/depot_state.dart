import 'package:equatable/equatable.dart';
import 'package:kang_galon_depot/models/models.dart';

abstract class DepotState extends Equatable {
  DepotState();
}

class DepotInitial extends DepotState {
  @override
  List<Object?> get props => [];
}

class DepotError extends DepotState {
  @override
  List<Object?> get props => [];
}

class DepotLoading extends DepotState {
  @override
  List<Object?> get props => [];
}

class DepotRegisterInProcess extends DepotState {
  final DepotRegister depotRegister;

  DepotRegisterInProcess({required this.depotRegister});
  @override
  List<Object?> get props => [depotRegister];
}

class DepotRegisteredSuccess extends DepotState {
  @override
  List<Object?> get props => [];
}

class DepotExistence extends DepotState {
  final bool isExist;

  DepotExistence({required this.isExist});

  @override
  List<Object?> get props => [isExist];
}

class DepotSentOtpSuccess extends DepotState {
  @override
  List<Object?> get props => [];
}

class DepotVerifyOTPSuccess extends DepotState {
  final String token;
  final String uid;
  final String deviceId;

  DepotVerifyOTPSuccess(
      {required this.token, required this.uid, required this.deviceId});

  @override
  List<Object?> get props => [token, uid, deviceId];
}
