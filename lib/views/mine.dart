import 'package:flutter/material.dart';
class Mine extends StatefulWidget {
  _MineState createState() => _MineState();
}

class _MineState extends State<Mine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title:Text('账号')
       ),
       drawer: Drawer(),
    );
  }
}