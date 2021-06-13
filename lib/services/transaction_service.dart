import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kang_galon_depot/constants/url.dart';
import 'package:kang_galon_depot/models/models.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  static Future<List<Transaction>> getCurrent() async {
    Uri url = getUrl('/depot/transaction/current');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String token = await firebaseAuth.currentUser!.getIdToken();

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    dynamic json = jsonDecode(response.body);
    if (!json['success']) throw new Exception(json['message']);

    List<Transaction> transactions = Transaction.fromJsonToList(json['data']);
    return transactions;
  }

  static Future<void> takeTransaction(
      Transaction transaction, int gallon) async {
    Uri url = getUrl('/depot/transaction/${transaction.id}/take-status');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String token = await firebaseAuth.currentUser!.getIdToken();

    var response = await http.patch(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: {'gallon': gallon.toString()},
    );

    dynamic json = jsonDecode(response.body);
    if (!json['success']) throw new Exception(json['message']);
  }

  static Future<void> sendTransaction(Transaction transaction) async {
    Uri url = getUrl('/depot/transaction/${transaction.id}/send-status');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String token = await firebaseAuth.currentUser!.getIdToken();

    var response = await http.patch(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    dynamic json = jsonDecode(response.body);
    if (!json['success']) throw new Exception(json['message']);
  }

  static Future<void> completeTransaction(Transaction transaction) async {
    Uri url = getUrl('/depot/transaction/${transaction.id}/complete-status');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String token = await firebaseAuth.currentUser!.getIdToken();

    var response = await http.patch(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    dynamic json = jsonDecode(response.body);
    if (!json['success']) throw new Exception(json['message']);
  }

  static Future<void> denyTransaction(Transaction transaction) async {
    Uri url = getUrl('/depot/transaction/${transaction.id}/deny-status');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String token = await firebaseAuth.currentUser!.getIdToken();

    var response = await http.patch(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    dynamic json = jsonDecode(response.body);
    if (!json['success']) throw new Exception(json['message']);
  }

  static Future<List<Transaction>> getHistory() async {
    Uri url = getUrl('/depot/transaction');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String token = await firebaseAuth.currentUser!.getIdToken();

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    dynamic json = jsonDecode(response.body);
    if (!json['success']) throw new Exception(json['message']);

    List<Transaction> transactions = Transaction.fromJsonToList(json['data']);
    return transactions;
  }

  static Future<Transaction> getDetail(int id) async {
    Uri url = getUrl('/depot/transaction/$id');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String token = await firebaseAuth.currentUser!.getIdToken();

    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    dynamic json = jsonDecode(response.body);
    if (!json['success']) throw new Exception(json['message']);

    return Transaction.fromJson(json['data']);
  }
}
