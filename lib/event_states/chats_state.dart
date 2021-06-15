import 'package:equatable/equatable.dart';
import 'package:kang_galon_depot/models/models.dart';

abstract class ChatsState extends Equatable {
  ChatsState();
}

class ChatsUninitialized extends ChatsState {
  @override
  List<Object> get props => [];
}

class ChatsLoading extends ChatsState {
  @override
  List<Object> get props => [];
}

class ChatsError extends ChatsState {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'Ups.. ada yang salah nih';
  }
}

class ChatsSendMessageSuccess extends ChatsState {
  @override
  List<Object> get props => [];
}

class ChatsGetMessageSuccess extends ChatsState {
  final Chats chats;

  ChatsGetMessageSuccess({required this.chats});

  @override
  List<Object> get props => [chats];
}
