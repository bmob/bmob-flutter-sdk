import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/utils/dialog_util.dart';

/**
 * home page
 */
import 'package:flutter/material.dart';
import 'package:data_plugin/bmob/bmob_installation_manager.dart';
import 'package:data_plugin/bmob/table/bmob_installation.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';

class InstallationPage extends StatefulWidget {
  InstallationPage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _InstallationPageState createState() => _InstallationPageState();
}

class _InstallationPageState extends State<InstallationPage> {
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
        // Here we take the value from the MyInstallationPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title!),
      ),
      body: new Container(
        margin: new EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  _getInstallationId(context);
                },
                child: new Text('获取设备ID',
                    style: new TextStyle(color: Colors.white))),
            ElevatedButton(
                onPressed: () {
                  _initInstallation(context);
                },
                child: new Text('初始化设备',
                    style: new TextStyle(color: Colors.white))),
            ElevatedButton(
                onPressed: () {
                  BmobQuery<BmobInstallation> query = BmobQuery();
                  query.queryInstallations().then((data) {
                    showSuccess(context, data.toString());
                    List<BmobInstallation> installations =
                    data.map((i) => BmobInstallation.fromJson(i)).toList();
                    for (BmobInstallation installation in installations) {
                      if (installation != null) {
                        print(installation.installationId);
                        print(installation.objectId);
                      }
                    }
                  }).catchError((e) {
                    showError(context, BmobError.convert(e)!.error!);
                  });
                },
                child: new Text('查询多个设备',
                    style: new TextStyle(color: Colors.white))),
            ElevatedButton(
                onPressed: () {
                  BmobQuery<BmobInstallation> query = BmobQuery();
                  query.queryInstallation("3795adbcad").then((data) {
                    showSuccess(context, BmobInstallation.fromJson(data).installationId!);
                  }).catchError((e) {
                    showError(context, BmobError.convert(e)!.error!);
                  });
                },
                child: new Text('查询单个设备',
                    style: new TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }

  ///获取设备ID
  _getInstallationId(BuildContext context) async {
    String installationId = await BmobInstallationManager.getInstallationId() ?? DateTime.now().toString();
    showSuccess(context, installationId);
  }

  ///初始化设备
  _initInstallation(BuildContext context) {
    BmobInstallationManager.init().then((BmobInstallation bmobInstallation) {
      showSuccess(context, bmobInstallation.toJson().toString());
    }).catchError((e) {
      showError(context, BmobError.convert(e)!.error!);
    });
  }
}
