import 'package:flutter/material.dart';

import '../bean/blog.dart';
import '../bean/user.dart';

import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/data_plugin.dart';

class PointerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PointerPageState();
  }
}

class _PointerPageState extends State<PointerPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
          title: Text("关联数据类型操作"),
        ),
        body: new Container(
          margin: new EdgeInsets.all(10.0),
          child: new Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  _addPointer();
                },
                color: Colors.blue[400],
                child: Text(
                  '添加关联关系',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  _queryPointer();
                },
                color: Colors.blue[400],
                child: Text(
                  '查询关联关系',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  _modifyPointer();
                },
                color: Colors.blue[400],
                child: Text(
                  '修改关联关系',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  _deletePointer();
                },
                color: Colors.blue[400],
                child: Text(
                  '解除关联关系',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ));
  }

  var currentObjectId;

  //添加关联关系
  void _addPointer() {
    Blog blog = Blog();
    User user = User();
    user.objectId = "4760e7a143";
    blog.author = user;
    blog.title = "添加关联关系";
    blog.content = "添加帖子对应的作者";
    blog.save(successListener: (BmobSaved bmobSaved) {
      currentObjectId = bmobSaved.objectId;
      print(bmobSaved.objectId);
      DataPlugin.toast("添加成功：\n${bmobSaved.objectId}\n${bmobSaved.createdAt}");
    }, errorListener: (BmobError bmobError) {
      print(bmobError);
      DataPlugin.toast(bmobError.toString());
    });
  }

  //解除关联关系
  void _deletePointer() {
    if (currentObjectId == null) {
      DataPlugin.toast("请先添加关联关系");
      return;
    }
    Blog blog = Blog();
    blog.objectId = currentObjectId;
    blog.deleteFieldValue("author", successListener: (BmobUpdated bmobUpdate) {
      print(bmobUpdate.updatedAt);
      DataPlugin.toast(bmobUpdate.updatedAt);
    }, errorListener: (BmobError bmobError) {
      print(bmobError.toString());
      DataPlugin.toast(bmobError.toString());
    });
  }

  //修改关联关系
  void _modifyPointer() {
    if (currentObjectId == null) {
      DataPlugin.toast("请先添加关联关系");
      return;
    }
    Blog blog = Blog();
    blog.objectId = currentObjectId;
    User user = User();
    user.objectId = "358f092cb1";
    blog.author = user;
    blog.update(successListener: (BmobUpdated bmobUpdated) {
      print(bmobUpdated.updatedAt);
      DataPlugin.toast(bmobUpdated.updatedAt);
    }, errorListener: (BmobError bmobError) {
      print(bmobError.toString());
      DataPlugin.toast(bmobError.toString());
    });
  }

  //查询多条数据
  void _queryPointer() {
    BmobQuery<Blog> query = BmobQuery();
    query.setInclude("author");
    query.queryObjects(successListener: (List<dynamic> data) {
      DataPlugin.toast("查询成功${data.length}");
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
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
      DataPlugin.toast(error.error);
    });
  }


}
