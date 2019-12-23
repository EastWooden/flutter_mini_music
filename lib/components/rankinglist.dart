import 'package:flutter/material.dart';
import '../util/styles.dart';
import '../util/service.dart';
import 'package:flutter/cupertino.dart';

class RankList extends StatefulWidget {
  _RankListState createState() => _RankListState();
}

class _RankListState extends State<RankList> {
  List<dynamic> toplist = [];
  bool isLoading = true;
  //获取排行榜
  getTopList() {
    Service().getData(Service().url['toplistDetail']).then((res) {
      if (res['code'] == 200) {
        setState(() {
            toplist = res['list'];
            isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getTopList();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print(MediaQuery.of(context).devicePixelRatio);
    if (isLoading == false) {
      List<dynamic> toplistTypeList = [];
      for(int i=0;i<toplist.length;i++) {
        if(toplist[i]['ToplistType'] is String) {
          toplistTypeList.add(toplist[i]);
        }
      }
      return ListView(
        children: <Widget>[
          BlockTitle(title: '云音乐官方榜'),
          Column(
            children: toplistTypeList.map((item) {
              List<dynamic> tracks = item['tracks'];
            return Container(
              width: width,
              margin: EdgeInsets.only(bottom: 5.0),
              height: 100.0,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Image.network(item['coverImgUrl'],width: 100.0,),
                      Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin:Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withOpacity(0.2),Colors.white.withOpacity(0.2),Colors.black.withOpacity(0.2)]
                          )
                        ),
                      ),
                      Positioned(
                        bottom: 5.0,
                        left: 2.0,
                        child:Text(item['updateFrequency'],style: TextStyle(fontSize: 11.0),),
                      )
                    ],
                  ),

                  Container(
                    width: width-100.0,
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(style: BorderStyle.solid,width: 0.5,color: Color(0xFFEEEEEE)))
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: tracks.map((tracksItem){
                        return GestureDetector(
                          onTap: (){
                            print(tracks.indexOf(tracksItem));
                          },
                          child: Container(
                          padding:EdgeInsets.only(left:20.0),
                          margin: EdgeInsets.only(top:5.0,bottom: 5.0),
                          child: Text('${tracks.indexOf(tracksItem) + 1}.${tracksItem['first']}-${tracksItem['second']}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            );
          }).toList())
          ,BlockTitle(title: '推荐榜'),
        ],
      );
    }
    return CupertinoActivityIndicator();
  }
}

class BlockTitle extends StatelessWidget {
  final String title;
  BlockTitle({this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            width: 2.0,
            height: 20.0,
            decoration: BoxDecoration(color: Color(Styles().colors['mainRed'])),
          ),
          Text(this.title,
              style: TextStyle(
                color: Color(Styles().colors['titlefontColor']),
                fontSize: Styles().fontSize['titleFontSize'],
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}
