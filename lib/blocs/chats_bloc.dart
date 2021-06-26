import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kang_galon_depot/blocs/blocs.dart';
import 'package:kang_galon_depot/event_states/event_states.dart';
import 'package:kang_galon_depot/models/models.dart';
import 'package:kang_galon_depot/services/services.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final SnackbarBloc _snackbarBloc;

  ChatsBloc(this._snackbarBloc) : super(ChatsUninitialized());

  @override
  Stream<ChatsState> mapEventToState(ChatsEvent event) async* {
    try {
      if (event is ChatSendMessage) {
        yield ChatsLoading();

        await ChatsService.sendMessage(event.transactionId, event.message);

        yield ChatsSendMessageSuccess();
      }

      if (event is ChatGetMessage) {
        yield ChatsLoading();

        Chats chats = await ChatsService.getMessage(event.transactionId);

        yield ChatsGetMessageSuccess(chats: chats);
      }
    } catch (e) {
      print('ChatsBloc - $e');
      _snackbarBloc.add(SnackbarShow(message: e.toString()));

      yield ChatsError();
    }
  }
}
