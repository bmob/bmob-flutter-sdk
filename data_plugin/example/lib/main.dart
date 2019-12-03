import 'package:flutter/material.dart';
import 'package:data_plugin/bmob/bmob.dart';
import 'page/home_page.dart';
import 'page/object_page.dart';
import 'page/query/query_page.dart';
import 'page/query/query_statistics_page.dart';
import 'page/sms_page.dart';
import 'page/installation_page.dart';
import 'page/list_page.dart';
import 'page/file_page.dart';
import 'page/time_page.dart';
import 'page/pointer_page.dart';
import 'page/acl_page.dart';
import 'page/geo_point_page.dart';
import 'page/real_time_page.dart';
import 'page/order_page.dart';
import 'page/user/login_by_sms_page.dart';
import 'page/user/login_page.dart';
import 'page/user/register_page.dart';
import 'page/user/reset_by_email_page.dart';
import 'page/user/reset_by_sms_page.dart';
import 'page/user/user_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Bmob.initMasterKey("https://api2.bmob.cn","12784168944a56ae41c4575686b7b332",
        "9e8ffb8e0945092d1a6b3562741ae564", "0db392c02287a18bf05592d6d5221a6e");


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
        'fileRoute':(BuildContext context)=>new FilePage(),
        'timeRoute':(BuildContext context)=>new TimePage(),
        'queryRoute':(BuildContext context)=>new QueryPage(),
        'pointerRoute':(BuildContext context)=>new PointerPage(),
        'aclRoute':(BuildContext context)=>new AclPage(),
        'geoPointRoute':(BuildContext context)=> new GeoPointPage(),
        'realtimeRoute':(BuildContext context)=> new RealTimePage(),
        'orderRoute':(BuildContext context)=> new OrderPage(),
        'smsLoginRoute':(BuildContext context)=> new SmsLoginPage(),
        'smsResetRoute':(BuildContext context)=> new SmsResetPage(),
        'emailResetRoute':(BuildContext context)=> new EmailResetPage(),
        'statisticsQQueryRoute':(BuildContext context)=> new QueryStatisticsPage(),
      },
    );
  }
}
