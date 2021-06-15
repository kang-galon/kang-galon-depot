import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:kang_galon_depot/constants/url.dart';
import 'package:kang_galon_depot/models/models.dart';

class ChatsService {
  static Future<Chats> getMessage(int transactionId) async {
    Uri uri = getUrl('/depot/chats/$transactionId');
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();

    var response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    var json = jsonDecode(response.body);
    if (json['success']) {
      return Chats.fromJson(json['data']);
    } else {
      throw Exception(json['message']);
    }
  }

  static Future<void> sendMessage(int transactionId, String message) async {
    Uri uri = getUrl('/depot/chats/send');
    String token = await FirebaseAuth.instance.currentUser!.getIdToken();

    var response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {'transaction_id': transactionId.toString(), 'message': message},
    );

    var json = jsonDecode(response.body);
    if (!json['success']) {
      throw Exception(json['message']);
    }
  }
}
