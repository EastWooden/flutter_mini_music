import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../util/service.dart';
import 'package:dio/dio.dart';
// import 'dart:convert';
import 'package:flutter/cupertino.dart';

Dio dio = new Dio();

class SpeCommand extends StatefulWidget {
  _SpeCommand createState() => _SpeCommand();
}

class _SpeCommand extends State<SpeCommand> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<Map> centerList = [{
      "iconName": 0xe6b1,
      "itemText": '私人FM'
    },{
      "iconName": 0xe657,
      "itemText": '每日歌曲推荐'
    },{
      "iconName": 0xe7bd,
      "itemText": '云音乐热歌榜'
    }];
    return ListView(
      children: <Widget>[
        Container(
          width: width,
          height: 173.0,
          child: Banner(),
        ),
        //banner下面的推荐菜单
        Container(
          padding: EdgeInsets.only(top:20.0,bottom: 20.0),
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFCCCCCC),style: BorderStyle.solid,width: 1.0))
          ),
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: centerList.map((Map item) {
                return Column(
                  children: <Widget>[
                    Container(
                      width: 70.0,
                      height: 70.0,
                      margin: EdgeInsets.only(left:25.0,right: 25.0,bottom: 10.0),
                      decoration: BoxDecoration(borderRadius:BorderRadius.all(Radius.circular(100.0)),border: Border.all(width:1.0,color:Color(0xFFd43b32),style: BorderStyle.solid)),
                      child: Center(child: Icon(IconData(item['iconName'],fontFamily: 'iconfont'),size:36.0,color: Color(0xFFd43b32),),),
                    ),
                    Text(item['itemText'],style:TextStyle(color: Color(0xFF000000)))
                  ],
                );
              }).toList(),
            ),
          ),
          ),
        //推荐区域
          RecommendBlock(blockTitle:'推荐歌单',url:Service().url['personalized']),
          RecommendBlock(blockTitle:'推荐mv',url:Service().url['personalizedmv']),
      ],
    );
  }
}


//下方推荐区域
class RecommendBlock extends StatelessWidget {
  final String blockTitle;
  final String url;
  RecommendBlock({
    this.blockTitle,
    this.url,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
        RecommendTitle(title:this.blockTitle),
        Center(
          child: RecommendSongs(url:this.url),
        )
        ],
      ),
    );
  }
}

//推荐区域title
class RecommendTitle extends StatelessWidget {
  final String title;
  RecommendTitle({
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
          children: <Widget>[
            Container(
              padding:EdgeInsets.only(top:10.0,bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(margin:EdgeInsets.only(right: 10.0) ,width: 3.0,height: 20.0,color: Color(0xFFd43b32)),
                  Text(this.title,style: TextStyle(color: Color(0xFF333333),fontSize: 18.0)),
                  Icon(IconData(0xe6f8,fontFamily: 'iconfont'),color: Color(0xFF333333),)
                ],
              ),
            ),
          ],
        );
  }
}


//上面的banner
class Banner extends StatefulWidget {
  _BannerState createState() => _BannerState();
}

class _BannerState extends State<Banner> {
  List<dynamic> banners = [];
  bool isLoading = true; //是否正在加载
  Future getBanners() async {
    final String url = Service().url['banner'];
    //创建一个httpClient
    try {
     Response response = await dio.get(url);
     Map<String,dynamic> res = response.data;
     banners = res['banners'];
     setState(() {
        isLoading = false;
      });
    //  Map<String,dynamic> resData = json.decode(res);
    //  print('Howdy, ${resData['code']}!');
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState() {
    super.initState();
    getBanners();
  }
  @override
  Widget build(BuildContext context) {
    if(!isLoading) {
    return new Swiper(
      itemCount: banners.length,
      autoplay: true,
      duration: 2000,
      autoplayDelay: 8000,
      itemBuilder: (BuildContext context, int index) {
          return Container(
          child: Image.network(banners[index]['picUrl'],width: MediaQuery.of(context).size.width,fit: BoxFit.fitWidth,),
        );
      },
      // viewportFraction: 0.8,
      // scale: 0.9,
      pagination: new SwiperCustomPagination(
        builder: (BuildContext context, SwiperPluginConfig config) {
          return MyPagination(
            activeColor: Colors.red,
            config: config,
          );
        },
      ),
      // control: new SwiperControl(),
    );
    } else {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
  }
}

class MyPagination extends StatelessWidget {
  final Color activeColor;
  final Color color;
  final double activesize;
  final double size;
  final double space;
  final Key key;
  final SwiperPluginConfig config;
  final Alignment alignment;
  const MyPagination(
      {this.activeColor,
      this.color,
      this.activesize: 10.0,
      this.size: 10.0,
      this.space: 5.0,
      this.key,
      this.config,
      this.alignment});
  @override
  Widget build(BuildContext context) {
    Color activeColor = this.activeColor;
    Color color = this.color;
    SwiperPluginConfig config = this.config;
    if (activeColor == null || color == null) {
      ThemeData themeData = Theme.of(context);
      activeColor = this.activeColor ?? themeData.primaryColor;
      color = this.color ?? themeData.scaffoldBackgroundColor;
    }
    if (config.itemCount > 20) {
      print(
        "The itemCount is too big, we suggest use FractionPaginationBuilder instead of DotSwiperPaginationBuilder in this sitituation");
    }
    Alignment alignment = this.alignment ??
        (config.scrollDirection == Axis.horizontal
            ? Alignment.bottomCenter
            : Alignment.centerRight);
    List<Widget> list = [];
    int itemCount = config.itemCount;
    int activeIndex = config.activeIndex;
    for (int i = 0; i < itemCount; i++) {
      bool active = i == activeIndex;
      list.add(Container(
        key: Key('pagenation_$i'),
        margin: EdgeInsets.all(space),
        child: ClipOval(
          child: Container(
            color: active ? activeColor : color,
            width: active ? activesize : size,
            height: active ? activesize : size,
          ),
        ),
      ));
    }
    if (config.scrollDirection == Axis.vertical) {
      return Align(
        alignment: alignment,
        child: Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: list,
      ),
      );
    } else {
      return Align(
        alignment: alignment,
        child: new Row(
          key: key,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: list,
        ),
      );
    }
  }
}

//推荐歌单列表
class RecommendSongs extends StatefulWidget {
  final url;
  RecommendSongs({this.url});
  _RecommendSongsState createState() => _RecommendSongsState(url:this.url);
}

class _RecommendSongsState extends State<RecommendSongs> {
  final url;
   _RecommendSongsState({
    this.url
  });
  bool isLoading = true;
  List<Widget> list = [];
  List<dynamic> recommendSongs = [];
  Future getRecommendSongs() async {
    String url = this.url;
    try {
      Response response = await dio.get(url);
      Map<String,dynamic> data = response.data;
      if(data['code'] == 200) {
        setState(() {
          isLoading = false;
        });
        recommendSongs = data['result'];
      }
      // print(data.toString());
    } catch (e) {
      print(e);
    }
  }
  @override
  void initState(){
    super.initState();
    getRecommendSongs();
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    if (isLoading == true) {
      return CupertinoActivityIndicator();
    } else {
      int length;
      if(recommendSongs.length > 6) {
        length = 6;
      } else {
        length = 3;
      }
      for(int i=0;i<length;i++) {
        if(recommendSongs[i]['playCount'] is double) {
          recommendSongs[i]['playCount'] = ((recommendSongs[i]['playCount'] / 10000)).toStringAsFixed(0) + '万';
        }
      list.add(
        //单个歌单容器
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Image.network('${recommendSongs[i]['picUrl']}',width: (width - 8)/3, fit: BoxFit.fitWidth),
                    Positioned(
                      top:0,
                      right:0,
                      child: Row(children: <Widget>[
                         Icon(Icons.headset,size: 20.0),
                         Text('${recommendSongs[i]['playCount']}'),
                      ],)
                    )
                  ],
                ),
              ),
              Text('${recommendSongs[i]['name']}',maxLines:2,overflow:TextOverflow.ellipsis,style:TextStyle(color: Colors.black)),
            ],
          ),
        )
      );
    }
      return Container(
        width: width,
        height: ((width - 8) / 3 / 0.7) * (length / 3) + 4.0,
        child: GridView.count(
         childAspectRatio:0.7,  //设置宽高比，默认是1:1 即宽高相等
         mainAxisSpacing: 4.0, //主轴间距 若是竖向滚动 就是竖轴
         crossAxisSpacing: 4.0,  //跨轴间距
         physics: NeverScrollableScrollPhysics(),
         crossAxisCount:3,
         children: list
        ),
      );
    }

  }
}
