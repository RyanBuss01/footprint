// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:front_end/screens/map/map_screen.dart';
import 'package:front_end/static/services/map_service.dart';

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
            Offset screenCoords = MapService.coordinateConverter(area[0], area[1]);
            double radius = getRadius();
            path = Path.combine(
                PathOperation.difference,
                path,
                Path()..addOval(Rect.fromCircle(center: screenCoords, radius: radius)),
            );
        }

        // Draw the fog, with holes where the explored areas are
        canvas.drawPath(path, Paint()..color = fogColor);
    }

    @override
    bool shouldRepaint(FogOfWarPainter oldDelegate) => true; 
}

double getRadius() {
  double zoom = mapController.camera.zoom;
  if(zoom>17.5) return 150;
  else if(zoom>17) return 100;
  else if(zoom>16.5) return 75;
  else  if(zoom>16) return 60;
  else if(zoom>15.5) return 50;
  else if(zoom>15) return 40;
  else if(zoom>14) return 30;
  else if(zoom>12.5) return 20;
  else if(zoom>10) return 15;
  else if(zoom > 7) return 10;
  else return 7; 
}
