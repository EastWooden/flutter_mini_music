import 'package:flutter/material.dart';

class VideoTV extends StatefulWidget {
  _VideoTVState createState() => _VideoTVState();
}

class _VideoTVState extends State<VideoTV> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Text('this is video Tv',style: TextStyle(color: Color(0xFF000000))),
    );
  }
}