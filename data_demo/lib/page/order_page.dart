import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/utils/dialog_util.dart';
import '../bean/blog.dart';

class OrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OrderPageState();
  }
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("查询"),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  _queryOrder(context);
                },
                child: new Text('排序查询',
                    style: new TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }

  ///数据排序
  _queryOrder(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.setOrder("createdAt");
    query.setLimit(10);
    query.setSkip(10);
    query.queryObjects().then((data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
      Navigator.pushNamed(context, "listRoute");

      for (Blog blog in blogs) {
        if (blog != null) {
          print(blog.objectId);
          print(blog.title);
          print(blog.content);
        }
      }
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  }
}
