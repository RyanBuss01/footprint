import 'package:front_end/static/services/user_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../../screens/map/frame.dart';

class GeoLocationService {
  static Future<Position?> getLocationPermission({bool update = false}) async {
    bool serviceEnabled;
    LocationPermission permission;

   // Test if location services are enabled.
serviceEnabled = await Geolocator.isLocationServiceEnabled();


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
    
    // Update location in database
    if(update) {
    //  await updateServerLocation(position);
    }

    return position;

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