/**
 * home page
 */
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: new Container(
        margin: new EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[
            RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "userRoute");
                },
                color: Colors.blue[400],
                child: new Text('用户操作',
                    style: new TextStyle(color: Colors.white))),
            RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "installationRoute");
                },
                color: Colors.blue[400],
                child: new Text('设备操作',
                    style: new TextStyle(color: Colors.white))),
            RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "objectRoute");
                },
                color: Colors.blue[400],
                child: new Text('基本数据类型操作',
                    style: new TextStyle(color: Colors.white))),
            RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "smsRoute");
                },
                color: Colors.blue[400],
                child: new Text('短信操作',
                    style: new TextStyle(color: Colors.white))),
            RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "timeRoute");
                },
                color: Colors.blue[400],
                child: new Text('时间操作',
                    style: new TextStyle(color: Colors.white))),

            RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "geoPointRoute");
                },
                color: Colors.blue[400],
                child: new Text('地理位置类型操作',
                    style: new TextStyle(color: Colors.white))),
            RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "fileRoute");
                },
                color: Colors.blue[400],
                child: new Text('文件操作',
                    style: new TextStyle(color: Colors.white))),
            RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "pointerRoute");
                },
                color: Colors.blue[400],
                child: new Text('数据关联',
                    style: new TextStyle(color: Colors.white))),


            RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "aclRoute");
                },
                color: Colors.blue[400],
                child: new Text('数据访问权限',
                    style: new TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
