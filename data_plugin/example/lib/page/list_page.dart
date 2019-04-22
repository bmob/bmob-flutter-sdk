import 'package:flutter/material.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/utils/dialog_util.dart';

import '../bean/blog.dart';

class ListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Page();
  }
}

class Page extends State<ListPage> {
  var _items = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return layout(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    _queryInclude(context);
    super.initState();
  }

  //查询多条数据
  void _queryInclude(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.setInclude("author");
    query.queryObjects(successListener: (List<dynamic> data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();

      setState(() {
        _items = blogs;
      });
      for (Blog blog in blogs) {
        if (blog != null) {
          print(blog.objectId);
          print(blog.title);
          print(blog.content);
          if (blog.author != null) {
            print(blog.author.objectId);
            print(blog.author.username);
          }
        }
      }
    }, errorListener: (BmobError error) {
      print(error.error);
      showError(context, error.error);
    });
  }

  Widget layout(BuildContext context) {
    return new Scaffold(
      appBar: buildAppBar(context),
      body:
          new ListView.builder(itemCount: _items.length, itemBuilder: itemView),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(title: const Text('列表查询'));
  }

  Widget itemView(BuildContext context, int index) {
    Blog model = this._items[index];
    //设置分割线
    if (index.isOdd) return new Divider(height: 2.0);
    return new Container(
        child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Text('${model.title}',
                            style: new TextStyle(fontSize: 15.0)),
                        new Text('(${model.objectId})',
                            style: new TextStyle(fontSize: 15.0)),
                        new Text('(${model.createdAt})',
                            style: new TextStyle(fontSize: 15.0)),
                      ],
                    ),
                    new Center(
                      heightFactor: 6.0,
                      child: new Text("${model.content}",
                          style: new TextStyle(fontSize: 17.0)),
                    )
                  ],
                ))));
  }
}
