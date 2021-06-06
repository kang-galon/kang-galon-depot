import 'dart:io';

class Depot {
  String? name;
  String? phoneNumber;
  String? image;
  double? latitude;
  double? longitude;
  String? address;
  int price;
  bool isOpen;

  Depot({
    this.name,
    this.phoneNumber,
    this.image,
    this.latitude,
    this.longitude,
    this.address,
    this.price = 5000,
    this.isOpen = true,
  });

  factory Depot.merge(Depot depot, Depot target) {
    depot.name = target.name ?? depot.name;
    depot.phoneNumber = target.phoneNumber ?? depot.phoneNumber;
    depot.image = target.image ?? depot.image;
    depot.latitude = target.latitude ?? depot.latitude;
    depot.longitude = target.longitude ?? depot.longitude;
    depot.address = target.address ?? depot.address;
    depot.price = target.price;

    return depot;
  }
}

class DepotRegister {
  String? name;
  String? phoneNumber;
  double? latitude;
  double? longitude;
  String? address;
  int price;
  String? image;
  String? uid;
  String? deviceId;
  String? token;

  DepotRegister({
    this.name,
    this.phoneNumber,
    this.image,
    this.latitude,
    this.longitude,
    this.address,
    this.uid,
    this.deviceId,
    this.token,
    this.price = 5000,
  });

  factory DepotRegister.merge(DepotRegister depot, DepotRegister target) {
    depot.name = target.name ?? depot.name;
    depot.phoneNumber = target.phoneNumber ?? depot.phoneNumber;
    depot.image = target.image ?? depot.image;
    depot.latitude = target.latitude ?? depot.latitude;
    depot.longitude = target.longitude ?? depot.longitude;
    depot.address = target.address ?? depot.address;
    depot.price = target.price;
    depot.uid = target.uid ?? depot.uid;
    depot.deviceId = target.deviceId ?? depot.deviceId;
    depot.token = target.token ?? depot.token;

    return depot;
  }

  bool isContainNull() {
    bool result = false;

    if (name == null ||
        phoneNumber == null ||
        image == null ||
        latitude == null ||
        longitude == null ||
        address == null ||
        uid == null ||
        deviceId == null ||
        token == null) result = true;

    return result;
  }
}
