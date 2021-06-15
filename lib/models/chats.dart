import 'package:kang_galon_depot/models/models.dart';

class Chats {
  final Depot depot;
  final List<Message> messages;

  Chats({required this.depot, required this.messages});

  factory Chats.fromJson(dynamic json) {
    Depot depot = Depot.fromJson(json['depot']);
    List<Message> messages = Message.fromJsonToList(json['chats']);

    return Chats(depot: depot, messages: messages);
  }
}
