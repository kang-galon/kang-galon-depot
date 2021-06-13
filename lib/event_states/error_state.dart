import 'package:equatable/equatable.dart';

abstract class ErrorState extends Equatable {
  ErrorState();
}

class ErrorUninitialized extends ErrorState {
  @override
  List<Object?> get props => [];
}

class ErrorUnauthorizedShowing extends ErrorState {
  final String message = 'Unauthorized';

  @override
  List<Object?> get props => [message];
}

class ErrorShowing extends ErrorState {
  final String message;
  ErrorShowing({required this.message});

  @override
  List<Object?> get props => [message];
}
