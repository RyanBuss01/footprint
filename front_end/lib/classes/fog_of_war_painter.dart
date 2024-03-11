import 'package:flutter/material.dart';
import 'package:front_end/screens/map/map_screen.dart';
import 'package:latlong2/latlong.dart' as latLng2;

class FogOfWarPainter extends CustomPainter {
    final List<List<double>> exploredAreas; 
    final Color fogColor = Colors.red.withOpacity(0.5);

    FogOfWarPainter(this.exploredAreas);

    @override
    void paint(Canvas canvas, Size size) {
        // Create a path that covers the entire map
        Path path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

        // Subtract the explored areas from the path
        for (var area in exploredAreas) {
            Offset screenCoords = coordinateConverter(area[0], area[1]);
            double radius = 20.0; // Adjust the radius as needed
            path = Path.combine(
                PathOperation.difference,
                path,
                Path()..addOval(Rect.fromCircle(center: screenCoords, radius: radius)),
            );
        }

        // Draw the fog, with holes where the explored areas are
        canvas.drawPath(path, Paint()..color = fogColor);
    }

    coordinateConverter(double latitude, double longitude) {
        var point = mapController.camera.latLngToScreenPoint(latLng2.LatLng(latitude, longitude));
        return Offset(point.x, point.y);
    }

    @override
    bool shouldRepaint(FogOfWarPainter oldDelegate) => true; 
}

