import 'dart:io';
import 'package:dio/dio.dart';
import 'bmob.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';

class BmobDio {
  ///网络请求框架
  Dio dio;

  ///网络请求元素
  Options options;

  ///单例
  static BmobDio instance;

  void setSessionToken(bmobSessionToken) {
    options.headers["X-Bmob-Session-Token"] = bmobSessionToken;
  }

  ///无参构造方法
  BmobDio() {
    options = new Options(
      //基地址
      baseUrl: Bmob.bmobHost,
      //连接服务器的超时时间，单位是毫秒。
      connectTimeout: 10000,
      //响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常。
      receiveTimeout: 3000,
      //请求头部
      headers: {
        "X-Bmob-Application-Id": Bmob.bmobAppId,
        "X-Bmob-REST-API-Key": Bmob.bmobRestApiKey,
        "X-Bmob-Master-Key": Bmob.bmobMasterKey,
        "Content-Type": "application/json",
      },
    );

    dio = new Dio(options);
  }

  ///单例模式
  static BmobDio getInstance() {
    if (instance == null) {
      instance = BmobDio();
    }
    return instance;
  }

  ///GET请求，带后半部分请求路径，带请求参数，带是否取消请求
  void get(path,
      {data,
      cancelToken,
      Function successCallback,
      Function errorCallback}) async {
    var requestUrl = options.baseUrl + path;
    var headers = options.headers.toString();
    print('get请求启动! url：$requestUrl ,body: $data ,headers:$headers');
    try {
      Response response = await dio.get(
        requestUrl,
        data: data,
        cancelToken: cancelToken,
      );
      print(response);
      print('get请求成功!response：${response.data}');
      //成功
      successCallback(response.data);
    } on DioError catch (e) {
      handleError(e, errorCallback);
    }
  }

  ///POST请求，带后半部分请求路径，带请求参数，带是否取消请求
  void post(path,
      {data,
      cancelToken,
      Function successCallback,
      Function errorCallback}) async {
    var requestUrl = options.baseUrl + path;
    var headers = options.headers.toString();
    print('post请求启动! url：$requestUrl ,body: $data ,headers:$headers');
    try {
      Response response = await dio.post(
        requestUrl,
        data: data,
        cancelToken: cancelToken,
      );
      print(response);
      print('post请求成功!response.data：${response.data}');

      //成功
      successCallback(response.data);
    } on DioError catch (e) {
      handleError(e, errorCallback);
    }
  }

  ///delete请求，带后半部分请求路径，带请求参数，带是否取消请求
  void delete(path,
      {data,
      cancelToken,
      Function successCallback,
      Function errorCallback}) async {
    var requestUrl = options.baseUrl + path;
    print('delete请求启动! url：$requestUrl ,body: $data');
    try {
      Response response =
          await dio.delete(requestUrl, data: data, cancelToken: cancelToken);
      print(response);
      print('delete请求成功!response.data：${response.data}');

      //成功

      successCallback(response.data);
    } on DioError catch (e) {
      handleError(e, errorCallback);
    }
  }

  ///put请求，带后半部分请求路径，带请求参数，带是否取消请求
  void put(path,
      {data,
      cancelToken,
      Function successCallback,
      Function errorCallback}) async {
    var requestUrl = options.baseUrl + path;
    print('put请求启动! url：$requestUrl ,body: $data');
    try {
      Response response =
          await dio.put(requestUrl, data: data, cancelToken: cancelToken);
      print(response);
      print('put请求成功!response.data：${response.data}');
      //成功
      successCallback(response.data);
    } on DioError catch (e) {
      handleError(e, errorCallback);
    }
  }

  ///GET请求，带请求路径，带请求参数，带是否取消请求
  void getByUrl(requestUrl,
      {data,
      cancelToken,
      Function successCallback,
      Function errorCallback}) async {
    var headers = options.headers.toString();
    print('get请求启动! url：$requestUrl ,body: $data ,headers:$headers');
    try {
      Response response = await dio.get(
        requestUrl,
        data: data,
        cancelToken: cancelToken,
      );
      print(response);
      print('get请求成功!response：${response.data}');
      //成功
      successCallback(response.data);
    } on DioError catch (e) {
      handleError(e, errorCallback);
    }
  }

  ///处理取消-失败-错误信息
  void handleError(e, Function errorCallback) {
    //取消
    if (CancelToken.isCancel(e)) {
      print('请求取消：' + e.message);
      BmobError bmobError = BmobError(1001, e.message);
      errorCallback(bmobError);
    } else {
      //失败
      if (e.response != null) {
        print('请求失败!e.response.data：${e.response.data.toString()}');
        BmobError bmobError =
            BmobError(e.response.data['code'], e.response.data['error']);
        errorCallback(bmobError);
      } else {
        //出错
        print('请求出错：' + e.message);
        BmobError bmobError = BmobError(1001, e.message);
        errorCallback(bmobError);
      }
    }
  }
}
