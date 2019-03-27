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
            RaisedButton(
              onPressed: () {
                _addGeoPoint();
              },
              color: Colors.blue[400],
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

  void _addGeoPoint() {
    Blog blog = Blog();
    BmobGeoPoint bmobGeoPoint = BmobGeoPoint();
    bmobGeoPoint.latitude = 12.4445;
    bmobGeoPoint.longitude = 124.122;

    blog.addr = bmobGeoPoint;
    blog.save(successListener: (BmobSaved bmobSaved) {
      print(bmobSaved.objectId);
      DataPlugin.toast(bmobSaved.objectId);
    }, errorListener: (BmobError bmobError) {
      print(bmobError.toString());
      DataPlugin.toast(bmobError.toString());
    });
  }
}
