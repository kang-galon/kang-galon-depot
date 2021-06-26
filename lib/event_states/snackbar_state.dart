import 'package:equatable/equatable.dart';

abstract class SnackbarState extends Equatable {
  SnackbarState();
}

class SnackbarUninitialized extends SnackbarState {
  @override
  List<Object?> get props => [];
}

class SnackbarUnauthorizedShowing extends SnackbarState {
  final String message = 'Unauthorized';

  @override
  List<Object?> get props => [message];
}

class SnackbarShowing extends SnackbarState {
  final String message;
  final bool isError;

  SnackbarShowing({required this.message, required this.isError});

  @override
  List<Object?> get props => [message];
}
