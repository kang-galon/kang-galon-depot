class Helper {
  static double getLatitude(String location) =>
      double.parse(location.toString().split(',')[0]);

  static double getLongitude(String location) =>
      double.parse(location.toString().split(',')[1]);
}
