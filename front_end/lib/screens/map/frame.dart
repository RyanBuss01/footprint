import 'package:flutter/material.dart';

class Frame extends StatefulWidget {
  final int id;
  const Frame({super.key, required this.id});

  @override
  _FrameState createState() => _FrameState();
}

class _FrameState extends State<Frame> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }

}
