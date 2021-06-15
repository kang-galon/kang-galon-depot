class Message {
  final String message;
  final bool isMe;
  final String createdAt;

  Message({required this.message, required this.isMe, required this.createdAt});

  static List<Message> fromJsonToList(dynamic json) {
    List<Message> messages = [];
    for (var chat in json) {
      messages.add(Message(
        message: chat['message'],
        isMe: chat['is_me'],
        createdAt: chat['created_at'],
      ));
    }

    return messages;
  }
}
