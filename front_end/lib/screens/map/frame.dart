import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    user = userdata!;
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
          return Stack(
            children: [
              MapScreen(isLaunch: true),
              NavBar()
            ],
          );
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


  Widget NavBar() {
  return Positioned(
    bottom: 0,
    child: Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100, // Adjusted height of the bottom black bar
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  icon: Icon(Icons.person, color: Colors.white, size: 40),
                ),
                // The middle container is removed from here
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  icon: Icon(Icons.settings, color: Colors.white, size: 40),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 30, // Adjust this value to control how much the element sticks out
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center, // Center the container within the Positioned widget
            child: Container(
              height: 70, // Height of the sticking out container
              width: 100, // Width of the sticking out container
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(Icons.add, color: Colors.black, size: 50),
            ),
          ),
        ),
      ],
    ),
  );
}

}
