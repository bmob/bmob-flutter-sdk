import 'package:data_plugin/utils/dialog_util.dart';
import 'package:flutter/material.dart';
import 'package:data_plugin/bmob/type/bmob_geo_point.dart';
import '../bean/blog.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/data_plugin.dart';

class GeoPointPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GeoPointPageState();
  }
}

class _GeoPointPageState extends State<GeoPointPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("地理位置"),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _addGeoPoint();
              },
              child: Text(
                "添加地理位置数据",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///添加地理位置信息
  _addGeoPoint() {
    Blog blog = Blog();
    BmobGeoPoint bmobGeoPoint = BmobGeoPoint();
    bmobGeoPoint.latitude = 12.4445;
    bmobGeoPoint.longitude = 124.122;
    blog.addr = bmobGeoPoint;
    blog.save().then((BmobSaved bmobSaved) {
      String message =
          "创建一条数据成功：${bmobSaved.objectId} - ${bmobSaved.createdAt}";
      showSuccess(context, message);
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  }
}
