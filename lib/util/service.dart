import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import '../components/toast.dart';

String baseUrl = 'http://192.168.3.171:3000';
class Service  {
  final Map<String, String> url = {
    'banner': baseUrl + '/banner', //获取banner图
    'personalized': baseUrl + '/personalized', //获取推荐歌单列表
    'personalizedmv': baseUrl + '/personalized/mv', //获取推荐MV
    'highqulitPlayList':baseUrl + '/top/playlist/highquality', //获取精品歌单
    'topplaylist': '/top/playlist',//歌单 ( 网友精选碟 )
    'toplist':'/toplist', // 获取排行榜
    'toplistDetail':'/toplist/detail',//所有榜单内容摘要
    'search':'/search', //搜索接口

  };

   Future getData(url,[FormData formdata]) async {
    Dio dio = new Dio();
    dio.options.baseUrl = 'http://192.168.1.132:3000';
    dio.options.path = url;

    dio.interceptor.request.onSend = (Options options) async {
      // Do something before request is sent
      // switch (options.path) {
      //   case '/top/playlist/highquality':
      //     break;
      //   default:
      // }
      return options; //continue
      // If you want to resolve the request with some custom data，
      // you can return a `Response` object or return `dio.resolve(data)`.
      // If you want to reject the request with a error message,
      // you can return a `DioError` object or return `dio.reject(errMsg)`
    };

    dio.interceptor.response.onSuccess = (Response response) async {
      // Do something with response data
      // print(response.data);
      Map<String,dynamic> res = response.data;
      if(res['code'] == 200 ) {
        print('请求成功');
      } else {
        print('请求失败');
      }
      return response; // continue
    };

    dio.interceptor.response.onError = (DioError e) {
      // Do something with response error
      // print(e);
      return e; //continue
    };
    try {
      Response response = await dio.get(url,data:formdata);
      return response.data;
    } catch (e) {

    }
  }
}

