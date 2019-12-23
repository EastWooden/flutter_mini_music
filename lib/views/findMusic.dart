import 'package:flutter/material.dart';
import '../components/rankinglist.dart';
import '../components/songs.dart';
import '../components/specilCommond.dart';
import '../components/videoTV.dart';
import '../views/searchpage.dart';

class FindMusic extends StatefulWidget {
  _FindMusiceState createState() => _FindMusiceState();
}

class _FindMusiceState extends State<FindMusic> with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    Tab(text: '个性推荐'),
    Tab(text: '歌单'),
    Tab(text: '主播电台'),
    Tab(text: '排行榜')
  ];
  TabController controller;
  var tabViews = [];
  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this,length: 4,initialIndex: 0);
  }
  void initData() {
    tabViews = <Widget>[
      new SpeCommand(),
      new Songs(),
      new VideoTV(),
      new RankList(),
    ];
  }
  @override
  Widget build(BuildContext context) {
    initData();
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Color(0xFFd43b32),
              leading: GestureDetector(
                  onTap: () {
                    print('点击了麦');
                  },
                  child: Icon(
                    Icons.mic,
                    size: 32.0,
                  )),
              title: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SearchPage()
                  ));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 20.0),
                  width: 260.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                      color: Color(0xfffeffff),
                      borderRadius: BorderRadius.all(Radius.circular(36.0))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.search,
                            color: Color(0xFFcccccc), size: 20.0),
                        Text('搜索音乐，歌词，电台',
                            style: TextStyle(
                                color: Color(0xFFcccccc), fontSize: 14.0))
                      ],
                    )),
              ),
              actions: <Widget>[
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.format_align_left, size: 30.0),
                  ),
                  onTap: () {
                    print('点击了波浪图标');
                  },
                )
              ]),
          body: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: TabBar(
                    controller: controller,
                    tabs: tabs,
                    indicatorColor: Color(0xFFd43b32),
                    labelColor: Color(0xFFd43b32),
                    labelPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                    unselectedLabelColor: Color(0xFF555555),
                    indicatorSize: TabBarIndicatorSize.label,
                    ),
              ),
              Expanded(
                child: TabBarView(
                      controller: controller,
                      children: tabViews,
                )
              )
            ],
          )),
    );
  }
}
