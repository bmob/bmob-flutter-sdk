import 'package:data_plugin/utils/dialog_util.dart';
import 'package:flutter/material.dart';
import 'package:data_plugin/data_plugin.dart';
import 'package:data_plugin/bmob/response/server_time.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/bmob_date_manager.dart';
import '../bean/blog.dart';
import 'package:data_plugin/bmob/type/bmob_date.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';

class TimePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OtherState();
  }
}

class _OtherState extends State<TimePage> {
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
                  _getServerTime();
                },
                color: Colors.blue[400],
                child: new Text('获取服务器时间',
                    style: new TextStyle(color: Colors.white))),
            RaisedButton(
                onPressed: () {
                  _addDate();
                },
                color: Colors.blue[400],
                child: new Text('添加时间类型',
                    style: new TextStyle(color: Colors.white))),
            RaisedButton(
                onPressed: () {
                  _queryDate();
                },
                color: Colors.blue[400],
                child: new Text('查询某个时间段数据',
                    style: new TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }

  ///获取服务器时间
  _getServerTime() {
    BmobDateManager.getServerTimestamp().then((ServerTime serverTime) {
      showSuccess(context, "${serverTime.timestamp}\n${serverTime.datetime}");
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  }

  ///添加时间数据
  _addDate() {
    DateTime dateTime = DateTime.now();
    BmobDate bmobDate = BmobDate();
    bmobDate.setDate(dateTime);
    Blog blog = Blog();
    blog.time = bmobDate;
    blog.title = "添加时间类型";
    blog.content = "测试时间类型的请求";
    blog.save().then((BmobSaved bmobSaved) {
      showSuccess(context, bmobSaved.objectId);
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  }

  void _queryDate() {

  }
}
