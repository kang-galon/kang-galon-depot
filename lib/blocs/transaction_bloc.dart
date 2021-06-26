import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';
import 'package:kang_galon_depot/exceptions/unauthorized_exception.dart';
import 'package:kang_galon_depot/models/models.dart';
import 'package:kang_galon_depot/services/services.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final SnackbarBloc _snackbarBloc;
  TransactionBloc(this._snackbarBloc) : super(TransactionUninitialized());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    try {
      if (event is TransactionCurrentFetch) {
        yield TransactionLoading();

        List<Transaction> transactions = await TransactionService.getCurrent();

        yield TransactionCurrentFetchSuccess(transactions: transactions);
      }

      if (event is TransactionTake) {
        yield TransactionLoading();

        await TransactionService.takeTransaction(
            event.transaction, event.gallon);

        List<Transaction> transactions = await TransactionService.getCurrent();
        yield TransactionCurrentFetchSuccess(transactions: transactions);
      }

      if (event is TransactionSend) {
        yield TransactionLoading();

        await TransactionService.sendTransaction(event.transaction);

        List<Transaction> transactions = await TransactionService.getCurrent();
        yield TransactionCurrentFetchSuccess(transactions: transactions);
      }

      if (event is TransactionComplete) {
        yield TransactionLoading();

        await TransactionService.completeTransaction(event.transaction);

        List<Transaction> transactions = await TransactionService.getCurrent();
        yield TransactionCurrentFetchSuccess(transactions: transactions);
      }

      if (event is TransactionDeny) {
        yield TransactionLoading();

        await TransactionService.denyTransaction(event.transaction);

        List<Transaction> transactions = await TransactionService.getCurrent();
        yield TransactionCurrentFetchSuccess(transactions: transactions);
      }
    } on UnauthorizedException {
      _snackbarBloc.add(SnackbarUnauthorized());

      yield TransactionError();
    } catch (e) {
      print('TransactionBloc - $e');
      _snackbarBloc.add(SnackbarShow(message: e.toString()));

      yield TransactionError();
    }
  }
}
