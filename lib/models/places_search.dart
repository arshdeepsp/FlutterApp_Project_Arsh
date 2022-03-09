class PlacesSearch {
  final String? description;
  final String? placeId;

  PlacesSearch({this.description, this.placeId});

  factory PlacesSearch.fromJson(Map<String, dynamic> json) {
    return PlacesSearch(
        description: json['description'], placeId: json['place_id']);
  }
}
