import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:kang_galon_depot/constants/url.dart';
import 'package:kang_galon_depot/exceptions/unauthorized_exception.dart';
import 'package:kang_galon_depot/models/models.dart';

class DepotService {
  static Future<bool> isDepotExist(String phoneNumber) async {
    Uri url = getUrl('/depot/check-user');
    var response = await http.post(
      url,
      body: {'phone_number': phoneNumber},
    );

    bool isExist = true;
    if (response.statusCode != 200) isExist = false;

    return isExist;
  }

  static Future<void> depotRegister(DepotRegister depotRegister) async {
    Uri url = getUrl('/depot/register');
    var request = new http.MultipartRequest('POST', url);
    request.fields['phone_number'] = depotRegister.phoneNumber!;
    request.fields['name'] = depotRegister.name!;
    request.fields['location'] =
        '${depotRegister.latitude}, ${depotRegister.longitude}';
    request.fields['address'] = depotRegister.address!;
    request.fields['price'] = depotRegister.price.toString();
    request.files
        .add(await http.MultipartFile.fromPath('image', depotRegister.image!));
    request.fields['uid'] = depotRegister.uid!;
    request.fields['device_id'] = depotRegister.deviceId!;
    request.fields['token'] = depotRegister.token!;

    var response = await request.send();
    var responseStr = await response.stream.bytesToString();
    var json = jsonDecode(responseStr);

    if (!json['success']) {
      throw Exception(json['message']);
    }
  }

  static Future<Depot> getProfile() async {
    Uri url = getUrl('/depot');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String token = await firebaseAuth.currentUser!.getIdToken();

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    dynamic json = jsonDecode(response.body);

    if (json['success']) {
      return Depot.fromJson(json['data']);
    } else {
      if (response.statusCode == 401) {
        throw UnauthorizedException(json['message']);
      }
      throw Exception(json['message']);
    }
  }

  static Future<Depot> updateProfile(Depot depot) async {
    Uri url = getUrl('/depot');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String token = await firebaseAuth.currentUser!.getIdToken();

    var response = await http.patch(url, headers: {
      'Authorization': 'Bearer $token'
    }, body: {
      'name': depot.name!,
      'location': '${depot.latitude}, ${depot.longitude}',
      'address': depot.address!,
      'price': depot.price.toString(),
    });

    dynamic json = jsonDecode(response.body);

    if (json['success']) {
      return Depot.fromJson(json['data']);
    } else {
      throw Exception(json['message']);
    }
  }

  static Future<void> updateStatusOpen() async {
    Uri url = getUrl('/depot/open');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String token = await firebaseAuth.currentUser!.getIdToken();

    var response = await http.patch(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    dynamic json = jsonDecode(response.body);
    if (!json['success']) {
      throw Exception(json['message']);
    }
  }

  static Future<void> updateStatusClose() async {
    Uri url = getUrl('/depot/close');
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String token = await firebaseAuth.currentUser!.getIdToken();

    var response = await http.patch(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    dynamic json = jsonDecode(response.body);
    if (!json['success']) {
      throw Exception(json['message']);
    }
  }
}
