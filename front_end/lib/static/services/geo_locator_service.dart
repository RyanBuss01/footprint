import 'dart:async';

import 'package:front_end/static/services/user_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../../screens/map/frame.dart';

StreamSubscription<Position>? _positionStreamSubscription;


class GeoLocationService {

  static Future<Position?> getLocationPermission({bool update = false}) async {
    // bool serviceEnabled;
    LocationPermission permission;


permission = await Geolocator.checkPermission();
if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // initLocationStream();

    return position;

  }


// Function to initialize location updates streaming
static Future<void> initLocationStream({LocationAccuracy accuracy = LocationAccuracy.high, int distanceFilter = 10, bool update = false}) async {
  LocationPermission permission = await Geolocator.checkPermission();
  
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }
  
  // Cancel existing stream subscription if it exists
  await _positionStreamSubscription?.cancel();
  
  // Initialize and listen to the position stream
  _positionStreamSubscription = Geolocator.getPositionStream(
    locationSettings: LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilter,
    ),
  ).listen(
    (Position position) {
      // user.currentPosition = position;
      updateFog();
    },
    onError: (e) {
      // Handle the error
      print(e);
    },
  );
}

static Future<void> updateFog() async {
  
}



  static Future updateServerLocation(Position position) async {
    var res = await http.post(
        Uri.http(url, '/updateUserLocation'),
        body: {
          'userId': user.id.toString(),
          'longitude': position.longitude.toString(),
          'latitude': position.latitude.toString(),
        }
    );
    return res;
  }
}