import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:front_end/classes/fog_of_war_painter.dart';
import 'package:front_end/screens/map/frame.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../static/constants/tile_layer_options.dart';


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
  late bool isMapCenter;
  late bool isWidgetBuilt = false;
  MapPosition? positionCamera;
  List<Marker> markers = [];
  double zoom = 14;
  Timer? timer;

  late double latitudeOverlay;
  late double longitudeOverlay;
  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            mapWidget(),
            IgnorePointer(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width, // Top-left corner
                child: CustomPaint(painter: FogOfWarPainter([[ 37.785834, -122.406417]])),
              ),
            ),
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
          // swPanBoundary: LatLng(-80, -180), //Here is the issue
          // nePanBoundary: LatLng(80, 180),
          onPositionChanged: (pos, bo) {
            positionCamera = pos;
            if( pos.center != startPosition) {
              setState(() {
                isMapCenter = false;
                zoom = pos.zoom!;
              });}
          },
          onMapReady: () {
            mapController.mapEventStream.listen((MapEvent mapEvent) async {
              if (mapEvent is MapEventMoveEnd) {
                // await mapMoveEventListener(positionCamera!);
              }
            });

            final LatLngBounds startBounds = LatLngBounds(LatLng(user.currentPosition.latitude-0.05, user.currentPosition.longitude-0.03), LatLng(user.currentPosition.latitude+0.05, user.currentPosition.longitude+0.03));
            // mapMoveEventListener(
            //   MapPosition(),
            //   isStatic: true,
            //   bounds: startBounds
            // );
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
}