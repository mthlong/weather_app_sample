class City {
  final String? name;
  final String? address;
  final double? lat;
  final double? lng;

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
        name: json["name"] as String?,
        address: "${json["name"]}, ${json["country"]}",
        lat: json["latitude"],
        lng: json["longitude"]);
  }

  City(
      {required this.name,
      required this.address,
      required this.lat,
      required this.lng});

  @override
  String toString() {
    return "";
  }
}
