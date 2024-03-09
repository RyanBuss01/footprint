import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:front_end/screens/map/map_screen.dart';
import 'package:latlong2/latlong.dart' as latLng2;

class FogOfWarPainter extends CustomPainter {
    final List<List<double>> exploredAreas; 
    final Color fogColor = Colors.red.withOpacity(0.5);

    FogOfWarPainter(this.exploredAreas);

    @override
    void paint(Canvas canvas, Size size) {
        // Draw fog over the entire map
        canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..color = fogColor );
        for (var area in exploredAreas) {
            Offset screenCoords = coordinateConverter(area[0], area[1]);
            double radius = 20.0; // Adjust the radius as needed
            canvas.drawCircle(screenCoords, radius, Paint()..blendMode = BlendMode.clear); 
        }
      }

    coordinateConverter(double latitude, double longitude) {
      var point = mapController.camera.latLngToScreenPoint(latLng2.LatLng(latitude, longitude));
      return Offset(point.x, point.y);
    }

    @override
    bool shouldRepaint(FogOfWarPainter oldDelegate) => true; 
}

