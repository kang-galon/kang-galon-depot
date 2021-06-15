class Depot {
  String? name;
  String? phoneNumber;
  String? uid;
  double? latitude;
  double? longitude;
  String? address;
  double? rating;
  int price;
  String? priceDesc;
  String? image;
  bool isOpen;

  Depot({
    this.name,
    this.phoneNumber,
    this.uid,
    this.image,
    this.latitude,
    this.longitude,
    this.address,
    this.rating,
    this.price = 5000,
    this.priceDesc,
    this.isOpen = true,
  });

  factory Depot.fromJson(dynamic json) {
    return Depot(
      name: json['name'],
      uid: json['uid'],
      phoneNumber: json['phone_number'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      rating: double.parse(json['rating'].toString()),
      image: json['image'],
      price: json['price'],
      priceDesc: json['price_description'],
      isOpen: json['is_open'] == 1, // if == 1 true
    );
  }
}

class DepotRegister extends Depot {
  String? deviceId;
  String? token;

  DepotRegister({
    String? name,
    String? phoneNumber,
    String? uid,
    String? image,
    double? latitude,
    double? longitude,
    String? address,
    this.deviceId,
    this.token,
  }) : super(
          name: name,
          phoneNumber: phoneNumber,
          uid: uid,
          image: image,
          latitude: latitude,
          longitude: longitude,
          address: address,
        );

  factory DepotRegister.merge(DepotRegister depot, DepotRegister target) {
    depot.name = target.name ?? depot.name;
    depot.phoneNumber = target.phoneNumber ?? depot.phoneNumber;
    depot.latitude = target.latitude ?? depot.latitude;
    depot.longitude = target.longitude ?? depot.longitude;
    depot.address = target.address ?? depot.address;
    depot.price = target.price;
    depot.image = target.image ?? depot.image;
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
