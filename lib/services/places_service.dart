import 'package:http/http.dart' as http;
import 'package:tripd_travel_app/models/coordinates.dart';
import 'dart:convert' as convert;

import 'package:tripd_travel_app/models/places_search.dart';
import 'package:tripd_travel_app/models/raw_coordinates.dart';

class PlacesService {
  final key = 'AIzaSyDy70F_YwH6ujpGRdaOtjKxzrxiTw_2-oc';
  Future<List<PlacesSearch>> getAutoComplete(String search) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((val) => PlacesSearch.fromJson(val)).toList();
  }

  Future<Coordinates> getCoordinates(String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['result']['geometry']['location'];
    return Coordinates.fromJson(jsonResults);
  }

  Future<RawCoordinates> getRawCoordinates(String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['result']['geometry']['location'];
    // print(jsonResults.toString());
    return RawCoordinates(jsonResults['lat'], jsonResults['lng']);
  }
}
