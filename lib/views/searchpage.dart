import 'package:flutter/material.dart';
import '../util/styles.dart';
import '../util/service.dart';
import 'package:dio/dio.dart';

class SearchPage extends StatefulWidget {
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textController = TextEditingController();
  String inputText = '';
  bool isLoadingSugSinger = true;  //是否正在加载推荐歌手
  bool isLoadingHotSearch = true; //是否正在加载热门搜索
  List<dynamic> artists = [];
  getSugetSinger() {
    FormData singerData = FormData.from({
      'keywords': '歌手',
      'limit': 3,
      'type': 100,
    });
    Service().getData(Service().url['search'], singerData).then((res) {
      print(res);
      if(res['code']== 200) {
        setState(() {
             isLoadingHotSearch = false;
          artists = res['result']['artists'];
          });

      }
    });
  }

  @override
  void initState() {
    super.initState();
    getSugetSinger();
    _textController.addListener(() {
      setState(() {
        inputText = _textController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            // keyboardType: TextInputType.numberWithOptions(signed: true), 改变键盘类型为数字键盘
            controller: _textController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: '搜索音乐、歌词、歌手、用户',
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: 0.5,
                      color: Colors.white,
                      style: BorderStyle.solid)),
            ),
          ),
          backgroundColor: Color(Styles().colors['mainRed']),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 15.0),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          style: BorderStyle.solid,
                          color: Color(0xFFCCCCCC).withOpacity(0.2),
                          width: 1.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(

                      children: <Widget>[
                        Text(
                          '按歌手搜索',
                          style: TextStyle(
                            color: Color(Styles().colors['titlefontColor']),
                            fontWeight: FontWeight.w700,
                            fontSize: Styles().fontSize['titleFontSize'],
                          ),
                        ),
                        Icon(
                          IconData(0xe6f8, fontFamily: 'iconfont'),
                          color: Color(0xFFcccccc),
                        )
                      ],
                    ),
                    Container(
                      child: Row(
                        children: artists.map((item){
                          return Container(
                            width: 30.0,
                            height: 30.0,
                            child: ClipOval(
                              child: Image.network(item['picUrl'],fit:BoxFit.cover),
                            )
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
