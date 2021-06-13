import 'package:equatable/equatable.dart';
import 'package:kang_galon_depot/models/models.dart';

abstract class TransactionEvent extends Equatable {
  TransactionEvent();
}

class TransactionCurrentFetch extends TransactionEvent {
  @override
  List<Object?> get props => [];
}

class TransactionHistoryFetch extends TransactionEvent {
  @override
  List<Object?> get props => [];
}

class TransactionTake extends TransactionEvent {
  final Transaction transaction;
  final int gallon;
  TransactionTake({required this.transaction, required this.gallon});

  @override
  List<Object?> get props => [transaction, gallon];
}

class TransactionSend extends TransactionEvent {
  final Transaction transaction;
  TransactionSend({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class TransactionComplete extends TransactionEvent {
  final Transaction transaction;
  TransactionComplete({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class TransactionDeny extends TransactionEvent {
  final Transaction transaction;
  TransactionDeny({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}
