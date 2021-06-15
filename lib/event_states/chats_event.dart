import 'package:equatable/equatable.dart';

abstract class ChatsEvent extends Equatable {
  ChatsEvent();
}

class ChatGetMessage extends ChatsEvent {
  final int transactionId;
  ChatGetMessage({required this.transactionId});

  @override
  List<Object> get props => [transactionId];
}

class ChatSendMessage extends ChatsEvent {
  final int transactionId;
  final String message;

  ChatSendMessage({
    required this.transactionId,
    required this.message,
  });

  @override
  List<Object> get props => [transactionId, message];
}
