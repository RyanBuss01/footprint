import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:front_end/classes/fog_of_war_painter.dart';
import 'package:front_end/screens/map/frame.dart';
import 'package:front_end/static/services/map_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../static/constants/tile_layer_options.dart';
import '../../static/services/geo_locator_service.dart';


MapController mapController = MapController();

class MapScreen extends StatefulWidget {
  final bool isLaunch;
  const MapScreen({super.key, this.isLaunch=false});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng startPosition = LatLng(user.currentPosition.latitude, user.currentPosition.longitude);
  late StreamSubscription<Position> positionStream;
  bool isMapCenter = true, isMapInitialized = false;
  late bool isWidgetBuilt = false;
  MapPosition? positionCamera;
  List<Marker> markers = [];

  late double latitudeOverlay;
  late double longitudeOverlay;

  @override
  void initState() {
    super.initState();
    // initStream();
  }


void initStream() {
  GeoLocationService.initLocationStream(); // Ensure this is idempotent or safely handles being called multiple times
}

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            mapWidget(),
            fogLayer(),
            centerButton(),
            isMapInitialized? myIcon() : const SizedBox()
          ]
        );
  }

  Widget mapWidget() {
    return FlutterMap(
      key: ValueKey(MediaQuery.of(context).orientation),
      mapController: mapController,
      options: MapOptions(
      
      interactionOptions: const InteractionOptions(flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag),
          initialCenter: startPosition,
          initialZoom: 14.0,
          maxZoom: 18,
          minZoom: 4,
          onPositionChanged: (pos, bo) {
            positionCamera = pos;
            if( pos.center != startPosition) {
              setState(() {
                isMapCenter = false;
              });}
          },
          onMapReady: () {
            setState(() {
            isMapInitialized = true;
            });
            // mapController.mapEventStream.listen((MapEvent mapEvent) async {
            //   if (mapEvent is MapEventMoveEnd) {
            //     // await mapMoveEventListener(positionCamera!);
            //   }
            // });

          },
      ),
      children: [
        tileLayerOptions,
        MarkerLayer(
          markers: markers,
        ),
      ],
    );
  }

  Widget fogLayer() {
    return IgnorePointer(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width, // Top-left corner
                child: CustomPaint(painter: FogOfWarPainter([[ 37.785, -122.406], [ 37.786, -122.407], [ 37.785, -122.407], [ 37.786, -122.406]])),
              ),
            );
  }

  Widget centerButton() {
    return Positioned(
        bottom: 20,
        right: 20,
      child: AnimatedOpacity(
        opacity: !isMapCenter ? 1.0 : 0.0, // Fully opaque when isVisible is true, otherwise fully transparent
        duration: const Duration(milliseconds: 500), // Adjust the duration of the fade effect
        child: FloatingActionButton(
          onPressed: () {
            mapController.move(startPosition, 14);
            setState(() =>isMapCenter = true);
          },
          child: const Icon(Icons.gps_fixed),
        ),
      ),
    );
  }

  Widget myIcon() {
  Offset screenCoords = MapService.coordinateConverter(user.currentPosition.latitude, user.currentPosition.longitude);
  return Positioned(
    left: screenCoords.dx - 15,
    top: screenCoords.dy - 15,
    child: Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
        color: Colors.blueAccent,
      ),
    ),
  );
}
}
