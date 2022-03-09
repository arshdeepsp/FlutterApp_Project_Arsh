import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tripd_travel_app/models/raw_coordinates.dart';

class LocationService {
  LocationService._();

  /// Returns an instance of [LocationService].
  factory LocationService() {
    return LocationService._();
  }

  String description = '';

  RawCoordinates rawCoordinates = RawCoordinates(37, 120);

  LocationPermission? permission;

  Position? position;

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.values.last);
  }

  Future<RawCoordinates> getCoordinates() async {
    position = await _getGeoLocationPosition();
    rawCoordinates.lat = position!.latitude;
    rawCoordinates.long = position!.longitude;
    return rawCoordinates;
  }

  Future<String> getDescriptionFromCoordinates(
      RawCoordinates rawCoordinates) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(rawCoordinates.lat, rawCoordinates.long);
    // print('${rawCoordinates.lat}, ${rawCoordinates.long}');
    Placemark place = placemarks[0];
    if (place.locality == '' || place.locality == place.administrativeArea) {
      description = '${place.administrativeArea}, ${place.country}';
    } else {
      description = '${place.locality}, ${place.administrativeArea}';
    }
    return description;
  }
}
