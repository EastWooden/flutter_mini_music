import 'package:flutter/material.dart';
import '../util/service.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:dio/dio.dart';

// import './toast.dart';

// import 'package:image/image.dart' as gimage;
// import 'dart:typed_data';
// import 'package:flutter/rendering.dart';

class Songs extends StatefulWidget {
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  bool isLoading = true;
  bool isLoadingSonsList = true;
  Map<String, dynamic> firstSong = {}; //顶部大图的歌单信息
  List<Widget> songslist = [];
  ScrollController _scrollController; //控制滚动器
  bool isGetingMore = false;
  List<dynamic> playlists = [];

  getSongs() {
    Service().getData('/top/playlist/highquality').then((res) {
      setState(() {
        isLoading = false;
      });
      // print(res);
      firstSong = res['playlists'][0];
      // print(res.toString());
    });
  }

  // 获取更多数据
  _getMoreSongs(number) {
    FormData formData = FormData.from({
      "limit": number,
      "order": 'hot',
    });
    Service().getData(Service().url['topplaylist'], formData).then((res) {
      // songslist = res['playlists'].sublist(1);  //sublist 同js中 的 slice
      setState(() {
        playlists = res['playlists'];
        isLoadingSonsList = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    int number = 0;
    getSongs();
    _getMoreSongs(10);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        number = number + 10; //如果滚动到底部就再继续请求10条数据
        print('滑动到了最底部');
        setState(() {
          isGetingMore = true;
          _getMoreSongs(number);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int length;
    if (isLoadingSonsList == false) {
      songslist = [];
      length = playlists.length;
      for (int i = 0; i < length; i++) {
        if (playlists[i]['playCount'] is int) {
          if (playlists[i]['playCount'] > 10000) {
            playlists[i]['playCount'] =
                (playlists[i]['playCount'] / 10000).toStringAsFixed(0) + '万';
          }
        }
        songslist.add(Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Image.network('${playlists[i]['coverImgUrl']}',
                        width: (width - 8) / 2, fit: BoxFit.fitWidth),
                    Positioned(
                        top: 5.0,
                        right: 10.0,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.headset, size: 16.0),
                            Text('${playlists[i]['playCount']}'),
                          ],
                        )),
                    Positioned(
                      bottom: 10.0,
                      left: 5.0,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.person_outline, size: 18.0),
                          Text('${playlists[i]['creator']['nickname']}'),
                          playlists[i]['creator']['userType'] == 200
                              ? Icon(Icons.star_border,
                                  size: 18.0, color: Color(0xFFe0a164))
                              : Container()
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Text('${playlists[i]['name']}',
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black)),
            ],
          ),
        ));
      }
    }

    if (isLoading == false && isLoadingSonsList == false) {
      return ListView(
        children: <Widget>[
          FirstSongState(songInfo: firstSong),
          SongsOptions(),
          isLoadingSonsList == true
              ? CupertinoActivityIndicator()
              : Container(
                  width: width,
                  height: ((width - 8) / 2 / 0.8) * (songslist.length / 2) +
                      4.0 * (songslist.length - 1),
                  child: GridView.count(
                    childAspectRatio: 0.8,
                    crossAxisCount: 2,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                    physics: NeverScrollableScrollPhysics(),
                    children: songslist,
                  ),
                ),
          isGetingMore == true ? GetMoreWidget() : Container()
        ],
        controller: _scrollController,
      );

    } else {
       return CupertinoActivityIndicator();
    }
  }
}

class GetMoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        CupertinoActivityIndicator(),
        Text('正在加载...', style: TextStyle(color: Colors.red)),
      ]),
    );
  }
}

class FirstSongState extends StatelessWidget {
  final Map<String, dynamic> songInfo;
  final GlobalKey globalKey = new GlobalKey();

  FirstSongState({this.songInfo});
  // 截图boundary，并且返回图片的二进制数据。
  // Future<Uint8List> _capturePng() async {
  //   RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
  //   // ui.Image image = await boundary.toImage();
  //   // 注意：png是压缩后格式，如果需要图片的原始像素数据，请使用rawRgba
  //   ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   Uint8List pngBytes = byteData.buffer.asUint8List();
  //   return pngBytes;
  // }
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> songInfo = this.songInfo;
    double width = MediaQuery.of(context).size.width;
    // List<String> desArray = songInfo['description'].split('//');
    // String des = desArray[1];
    // print(des);
    return Container(
      width: width,
      height: 150.0,
      //  color: Colors.red,
      decoration: BoxDecoration(),
      child: Stack(
        children: <Widget>[
          Image.network(songInfo['coverImgUrl'],
              width: width, height: 150.0, fit: BoxFit.fitWidth),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 45.0),
            child: new Container(
              color: Colors.black.withOpacity(0.3),
              width: width,
              height: 150.0,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30.0, left: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Image.network(songInfo['coverImgUrl'],
                      width: 100.0, fit: BoxFit.fitWidth),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 5.0),
                          child: Container(
                            alignment: Alignment.center,
                            width: 25.0,
                            height: 25.0,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    style: BorderStyle.solid,
                                    width: 1.0,
                                    color: Color(0xFFc6a973)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                                color: Color(0xFFc6a973).withOpacity(0.3)),
                            child: Icon(
                              IconData(
                                0xe7af,
                                fontFamily: 'iconfont',
                              ),
                              color: Color(0xFFc6a973),
                              size: 18.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text('精品歌单',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w700)),
                        ),
                        Icon(IconData(0xe6f8, fontFamily: 'iconfont'))
                      ],
                    ),
                    Container(
                      width: 240.0,
                      margin: EdgeInsets.only(top: 15.0, bottom: 5.0),
                      child: Text(
                        songInfo['name'],
                        style: TextStyle(fontSize: 16.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      width: 240.0,
                      child: Text(
                        songInfo['copywriter'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 11.0, color: Colors.grey.shade300),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

//歌单选项

class SongsOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0, bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: OutlineButton(
              padding: EdgeInsets.all(0),
              textColor: Color(0xFF555555),
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              shape: StadiumBorder(), //通过这个属性 来绘制按钮的圆角,在这个里面设置属性是没有效果的
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '全部歌单',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  Icon(
                    IconData(0xe6f8, fontFamily: 'iconfont'),
                    size: 16.0,
                  )
                ],
              ),
              onPressed: () {
                print('fdjk');
              },
            ),
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                  child: Text('欧美',
                      style:
                          TextStyle(color: Color(0xFF555555), fontSize: 14.0))),
              Divider(color: Colors.red, height: 2.0, indent: 5.0),
              GestureDetector(
                  child: Text('民谣',
                      style:
                          TextStyle(color: Color(0xFF555555), fontSize: 14.0))),
              Divider(color: Colors.red, height: 2.0, indent: 5.0),
              GestureDetector(
                  child: Text('电子',
                      style:
                          TextStyle(color: Color(0xFF555555), fontSize: 14.0))),
            ],
          )
        ],
      ),
    );
  }
}

