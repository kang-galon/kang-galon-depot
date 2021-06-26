import 'package:equatable/equatable.dart';

abstract class SnackbarEvent extends Equatable {
  SnackbarEvent();
}

class SnackbarUnauthorized extends SnackbarEvent {
  @override
  List<Object?> get props => [];
}

class SnackbarShow extends SnackbarEvent {
  final String message;
  final bool isError;

  SnackbarShow({required this.message, this.isError = true});

  @override
  List<Object?> get props => [message];
}
