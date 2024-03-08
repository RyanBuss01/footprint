import 'package:flutter/material.dart';
import 'package:front_end/classes/my_user.dart';
import 'package:front_end/screens/map/map_screen.dart';
import 'package:front_end/static/widgets/logo_loading_widget.dart';
import 'package:geolocator/geolocator.dart';

import '../../static/services/geo_locator_service.dart';
import '../../static/services/user_service.dart';

late MyUser user;


class Frame extends StatefulWidget {
  final int id;
  const Frame({super.key, required this.id});

  @override
  _FrameState createState() => _FrameState();
}

class _FrameState extends State<Frame> {
   var futures;
  MyUser? userdata;
  Position? _currentPosition;

  Future<Position?> getCurrentPosition() async => _currentPosition = await GeoLocationService.getLocationPermission();
  Future<MyUser> getUser() async => userdata = await UserService().getMyUserdata(widget.id, isMe: true, pos: _currentPosition!);


  Future getData() async {
    await getCurrentPosition();
    await getUser();
    userdata!.currentPosition = _currentPosition!;
    return [userdata, _currentPosition];
  }

  @override
  void initState() {
    super.initState();
    futures = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: futures,
        builder: (context, snap) {
        if(snap.connectionState == ConnectionState.done && userdata != null) {
          user = userdata!;
          return MapScreen(isLaunch: true);
        }
        else if(snap.connectionState == ConnectionState.waiting) {
          return logoLoadingWidget();
        } else {
        // Create error screen
          return Center(
            child: Container(
              child: Text('Error', style: TextStyle(color: Colors.red))
            ),
          );
        }
      },),
    );
  }

}
