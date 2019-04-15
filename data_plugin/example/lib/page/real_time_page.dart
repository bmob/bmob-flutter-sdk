import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:data_plugin/bmob/realtime/real_time_data_manager.dart';
import 'package:data_plugin/bmob/realtime/client.dart';
import 'package:data_plugin/bmob/realtime/change.dart';
import '../bean/blog.dart';
class RealTimePage extends StatefulWidget {
  @override
  _RealTimeState createState() {
    // TODO: implement createState
    return _RealTimeState();
  }
}

class _RealTimeState extends State<RealTimePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: Text("其他操作"),
      ),
      body: new Container(
        margin: new EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[
            RaisedButton(
                onPressed: () {
                  _listen();
                },
                color: Colors.blue[400],
                child: new Text('开始监听',
                    style: new TextStyle(color: Colors.white))),
            RaisedButton(
                onPressed: () {
                  _change();
                },
                color: Colors.blue[400],
                child: new Text('修改数据',
                    style: new TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }


  ///数据监听
  void _listen() {
    RealTimeDataManager.getInstance().listen(
        onConnected: (Client client) {
          print("监听数据连接成功，开始订阅消息！");
          client.subTableUpdate("Blog");
        },
        onDisconnected: () {
          print("监听数据断开连接");
        },
        onDataChanged: (Change data) {
          Blog blog = Blog.fromJson(data.data);
          print("监听到数据变化："+blog.toJson().toString());
        },
        onError: (error) {
          print("监听数据发送错误："+error.toString());
        });
  }

  void _change() {

  }
}
