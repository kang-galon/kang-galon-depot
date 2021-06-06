import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as httpParser;
import 'package:kang_galon_depot/constants/url.dart';
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
        '${depotRegister.latitude}; ${depotRegister.longitude}';
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
    print(responseStr);

    if (!json['success']) {
      throw Exception(json['message']);
    }
  }
}
