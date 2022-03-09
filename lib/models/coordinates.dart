class Coordinates {
  String lat;
  String long;
  Coordinates(this.lat, this.long);
  factory Coordinates.fromJson(Map<String, dynamic> json) {
    return Coordinates(json['lat'].toString(), json['lng'].toString());
  }
}
