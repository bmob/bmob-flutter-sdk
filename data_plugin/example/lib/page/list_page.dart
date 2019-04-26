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
    _queryList(context);
    super.initState();
  }

  ///查询多条数据
  void _queryList(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.setInclude("author");
    query.setLimit(10);
    query.setSkip(10);
    query.queryObjects().then((List<dynamic> data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();

      setState(() {
        _items = blogs;
      });
      int index = 0;
      for (Blog blog in blogs) {
        index++;
        if (blog != null) {
          print(index);
          print(blog.objectId);
          print(blog.title);
          print(blog.content);
          if (blog.author != null) {
            print(blog.author.objectId);
            print(blog.author.username);
          }
        }
      }
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
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
    print("item $index");
    Blog model = this._items[index];
    //设置分割线
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
                      child: new Text("${model.content}\n第$index条数据",
                          style: new TextStyle(fontSize: 17.0)),
                    ),
                    new Divider(height: 2.0),
                  ],
                ))));
  }
}
