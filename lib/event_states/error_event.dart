import 'package:equatable/equatable.dart';

abstract class ErrorEvent extends Equatable {
  ErrorEvent();
}

class ErrorUnauthorized extends ErrorEvent {
  @override
  List<Object?> get props => [];
}

class ErrorShow extends ErrorEvent {
  final String message;

  ErrorShow({required this.message});

  @override
  List<Object?> get props => [message];
}
