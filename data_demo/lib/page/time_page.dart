import 'package:flutter/material.dart';
import 'package:data_plugin/data_plugin.dart';
import 'package:data_plugin/bmob/response/server_time.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/bmob_date_manager.dart';
import '../bean/blog.dart';
import 'package:data_plugin/bmob/type/bmob_date.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/data_plugin.dart';
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
          ],
        ),
      ),
    );
  }

  //获取服务器时间
  void _getServerTime() {
    BmobDateManager.getServerTimestamp(successListener: (ServerTime serverTime) {
      print(serverTime);
      DataPlugin.toast("${serverTime.timestamp}\n${serverTime.datetime}");
    }, errorListener: (BmobError bmobError) {
      print(bmobError);
      DataPlugin.toast(bmobError.toString());
    });
  }

  void _addDate() {


    DateTime dateTime = DateTime.now();
    BmobDate bmobDate = BmobDate();
    bmobDate.setDate(dateTime);
    Blog blog = Blog();
    blog.time = bmobDate;
    blog.title = "添加时间类型";
    blog.content = "测试时间类型的请求";
    print(blog.toJson().toString());
    print(blog.toString());

    blog.save(successListener: (BmobSaved bmobSaved){
      print(bmobSaved.objectId);

      DataPlugin.toast(bmobSaved.objectId);
    },errorListener: (BmobError bmobError){
      print(bmobError.toString());
      DataPlugin.toast(bmobError.toString());
    });

  }
}
