import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';
import 'package:kang_galon_depot/models/models.dart';
import 'package:kang_galon_depot/services/services.dart';

class TransactionHistoryBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionHistoryBloc() : super(TransactionUninitialized()) {
    this.add(TransactionHistoryFetch());
  }

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    try {
      if (event is TransactionHistoryFetch) {
        yield TransactionLoading();

        List<Transaction> transactions = await TransactionService.getHistory();

        yield TransactionHistoryFetchSuccess(transactions: transactions);
      }
    } catch (e) {
      print('TransactionHistoryBloc - $e');

      yield TransactionError();
    }
  }
}
