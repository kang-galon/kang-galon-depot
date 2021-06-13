import 'package:equatable/equatable.dart';
import 'package:kang_galon_depot/models/models.dart';

abstract class TransactionState extends Equatable {
  TransactionState();
}

class TransactionUninitialized extends TransactionState {
  @override
  List<Object?> get props => [];
}

class TransactionLoading extends TransactionState {
  @override
  List<Object?> get props => [];
}

class TransactionError extends TransactionState {
  @override
  List<Object?> get props => [];
}

class TransactionCurrentFetchSuccess extends TransactionState {
  final List<Transaction> transactions;
  TransactionCurrentFetchSuccess({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class TransactionDetailFetchSuccess extends TransactionState {
  final Transaction transaction;
  TransactionDetailFetchSuccess({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}
