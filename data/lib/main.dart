import 'package:flutter/material.dart';
import 'package:data/bmob/bmob.dart';
import 'package:data/page/login_page.dart';
import 'package:data/page/home_page.dart';
import 'package:data/page/register_page.dart';
import 'package:data/page/user_page.dart';
import 'package:data/page/object_page.dart';
import 'package:data/page/sms_page.dart';
import 'package:data/page/installation_page.dart';
import 'package:data/page/list_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Bmob.initMasterKey("12784168944a56ae41c4575686b7b332",
        "9e8ffb8e0945092d1a6b3562741ae564", "0db392c02287a18bf05592d6d5221a6e");

//    Bmob.init(
//        "afd59ebd57409b387ae57663cc7e238d", "d07840ba4f790d0d6b3635788c45eb2b");
    return MaterialApp(
      title: 'Flutter Bmob',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Flutter Bmob'),
      routes: {
        'loginRoute': (BuildContext context) => new LoginPage(),
        'registerRoute': (BuildContext context) => new RegisterPage(),
        'userRoute': (BuildContext context) => new UserPage(title: '用户管理'),
        'installationRoute': (BuildContext context) =>
            new InstallationPage(title: '设备管理'),
        'objectRoute': (BuildContext context) => new ObjectPage(title: '数据操作'),
        'smsRoute': (BuildContext context) => new SmsPage(),
        'listRoute': (BuildContext context) => new ListPage(),
      },
    );
  }
}
