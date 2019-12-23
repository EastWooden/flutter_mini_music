import 'package:flutter/material.dart';
import './findMusic.dart';
import './friends.dart';
import './mine.dart';
import './myMusic.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _tabIndex = 0;
  List<String> appBarTitles = ['发现音乐', '我的音乐', '朋友', '账号'];
  var _bodys;
  TabController controller;
  void initData() {
    _bodys = [new FindMusic(), new MyMusic(), new Friends(), new Mine()];
  }
  @override
  Widget build(BuildContext context) {
    initData();
    return new Scaffold(
      body:_bodys[_tabIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        currentIndex: _tabIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            title: Text(appBarTitles[0]),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            title: Text(appBarTitles[1]),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text(appBarTitles[2]),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text(appBarTitles[3]),
          )
        ],
      onTap:(index){
        setState(() {
                  _tabIndex = index;
                });
      }
      ),

    );
  }
}
