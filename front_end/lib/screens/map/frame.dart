import 'package:flutter/material.dart';

class Frame extends StatefulWidget {
  final int id;
  const Frame({super.key, required this.id});

  @override
  _FrameState createState() => _FrameState();
}

class _FrameState extends State<Frame> {
  // var futures;
  // MyUser? userdata;
  // Position? _currentPosition;

  // Future<Position?> getCurrentPosition() async => _currentPosition = await GeoLocationService.getLocationPermission();
  // Future<MyUser> getUser() async => userdata = await UserService().getMyUserdata(widget.id, isMe: true, pos: _currentPosition!);
  // Future<List<CameraDescription>> getCameras() async => cameras = await CameraService.getCameraDescriptions();


  // Future getData() async {
  //   await getCurrentPosition();
  //   await getUser();
  //   await getCameras();
  //   return [userdata, _currentPosition, cameras];
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   futures = getData();
  // }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

}
