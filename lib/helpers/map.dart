import 'package:geocoding/geocoding.dart';

class MapHelper {
  static Future<String> getAddressLocation(
      double latitude, double longitude) async {
    String address = '';

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      Placemark placemark = placemarks.first;
      address =
          '${placemark.street}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.postalCode}';
    } catch (e) {
      print(e);
    }

    return address;
  }
}
