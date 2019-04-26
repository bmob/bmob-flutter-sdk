import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/utils/dialog_util.dart';
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
                  _change(context);
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
  _listen() {
    RealTimeDataManager.getInstance().listen(onConnected: (Client client) {
      showSuccess(context, "监听数据连接成功，开始订阅消息！");
      client.subTableUpdate("Blog");
    }, onDisconnected: () {
      showError(context, "监听数据断开连接");
    }, onDataChanged: (Change data) {
      ///注意：此处返回的data.data类型与Blog类型不一致，需要使用map来获取具体属性值而不是使用Blog
      Map map = data.data;
      showSuccess(context, "监听到数据变化：" + map.toString());
    }, onError: (error) {
      showError(context, error.toString());
    });
  }

  ///改编数据
  _change(context) {
    ///保存一条数据
    BmobUser bmobUser = BmobUser();
    bmobUser.objectId = "7c7fd3afe1";
    Blog blog = Blog();
    blog.title = "博客标题";
    blog.content = "博客内容";
    blog.author = bmobUser;
    blog.like = 77;
    blog.save().then((BmobSaved bmobSaved) {
      String message =
          "创建一条数据成功：${bmobSaved.objectId} - ${bmobSaved.createdAt}";
      showSuccess(context, message);
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  }
}
