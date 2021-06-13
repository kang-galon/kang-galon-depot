import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';
import 'package:kang_galon_depot/models/models.dart';
import 'package:kang_galon_depot/services/services.dart';

class TransactionDetailBloc extends Bloc<TransactionEvent, TransactionState> {
  late Transaction _transaction;
  late TransactionBloc _transactionBloc;

  TransactionDetailBloc(this._transaction, this._transactionBloc)
      : super(TransactionDetailFetchSuccess(transaction: _transaction));

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    try {
      if (event is TransactionTake) {
        yield TransactionLoading();

        await TransactionService.takeTransaction(
            event.transaction, event.gallon);

        _transaction = await TransactionService.getDetail(_transaction.id);
        _transactionBloc.add(TransactionCurrentFetch());
        yield TransactionDetailFetchSuccess(transaction: _transaction);
      }

      if (event is TransactionSend) {
        yield TransactionLoading();

        await TransactionService.sendTransaction(event.transaction);

        _transaction = await TransactionService.getDetail(_transaction.id);
        _transactionBloc.add(TransactionCurrentFetch());
        yield TransactionDetailFetchSuccess(transaction: _transaction);
      }

      if (event is TransactionComplete) {
        yield TransactionLoading();

        await TransactionService.completeTransaction(event.transaction);

        _transaction = await TransactionService.getDetail(_transaction.id);
        _transactionBloc.add(TransactionCurrentFetch());
        yield TransactionDetailFetchSuccess(transaction: _transaction);
      }

      if (event is TransactionDeny) {
        yield TransactionLoading();

        await TransactionService.denyTransaction(event.transaction);

        _transaction = await TransactionService.getDetail(_transaction.id);
        _transactionBloc.add(TransactionCurrentFetch());
        yield TransactionDetailFetchSuccess(transaction: _transaction);
      }
    } catch (e) {
      print(e);
      yield TransactionError();
    }
  }
}
