import 'package:dio/dio.dart';

/**
 * home page
 */
import 'package:flutter/material.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/utils/dialog_util.dart';
import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import '../bean/blog.dart';

class ObjectPage extends StatefulWidget {
  ObjectPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ObjectPageState createState() => _ObjectPageState();
}

class _ObjectPageState extends State<ObjectPage> {
  String currentObjectId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Container(
        margin: new EdgeInsets.all(10.0),
        child: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              RaisedButton(
                  onPressed: () {
                    _saveSingle(context);
                  },
                  color: Colors.blue[400],
                  child: new Text('添加一条数据',
                      style: new TextStyle(color: Colors.white))),
              RaisedButton(
                  onPressed: () {
                    _querySingle(context);
                    _querySingleFuture(context);
                  },
                  color: Colors.blue[400],
                  child: new Text('查询一条数据',
                      style: new TextStyle(color: Colors.white))),
              RaisedButton(
                  onPressed: () {
                    _updateSingle(context);
                  },
                  color: Colors.blue[400],
                  child: new Text('修改一条数据',
                      style: new TextStyle(color: Colors.white))),
              RaisedButton(
                  onPressed: () {
                    _deleteSingle(context);
                  },
                  color: Colors.blue[400],
                  child: new Text('删除一条数据',
                      style: new TextStyle(color: Colors.white))),
              RaisedButton(
                  onPressed: () {
                    _deleteFieldValue(context);
                  },
                  color: Colors.blue[400],
                  child: new Text('删除某条数据某个字段的值',
                      style: new TextStyle(color: Colors.white))),
              RaisedButton(
                  onPressed: () {
                    _queryMulti(context);
                  },
                  color: Colors.blue[400],
                  child: new Text('查询多条数据',
                      style: new TextStyle(color: Colors.white))),
              RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'queryRoute');
                  },
                  color: Colors.blue[400],
                  child: new Text('其他查询操作',
                      style: new TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }

  ///保存一条数据
  void _saveSingle(BuildContext context) {
    BmobUser bmobUser = BmobUser();
    bmobUser.objectId = "7c7fd3afe1";
    Blog blog = Blog();
    blog.title = "博客标题";
    blog.content = "博客内容";
    blog.author = bmobUser;
    blog.like = 77;
    blog.save(successListener: (BmobSaved data) {
      String message = "创建一条数据成功：${data.objectId} - ${data.createdAt}";
      currentObjectId = data.objectId;
      print(message);
      showSuccess(context, message);
    }, errorListener: (BmobError bmobError) {
      String message = "创建一条数据失败：${bmobError.error}";
      print(message);
      showError(context, message);
    });
  }

  ///查询一条数据
  void _querySingle(BuildContext context) {
    if (currentObjectId != null) {
      BmobQuery<Blog> bmobQuery = BmobQuery();
      bmobQuery.setInclude("author");
      bmobQuery.queryObject(currentObjectId, successListener: (dynamic data) {
        Blog blog = Blog.fromJson(data);
        print(blog.title);
        showSuccess(context,
            "查询一条数据成功：${blog.title} - ${blog.content} - ${blog.author.username}");
      }, errorListener: (BmobError error) {
        print(error.error);
        showError(context, error.error);
      });
    } else {
      showError(context, "请先新增一条数据");
    }
  }

  void _querySingleFuture(BuildContext context) {
    if (currentObjectId != null) {
      BmobQuery<Blog> bmobQuery = BmobQuery();
      bmobQuery.setInclude("author");
      bmobQuery.queryObjectFuture(currentObjectId).then((dynamic data) {
        Blog blog = Blog.fromJson(data);
        print(blog.title);
        showSuccess(context,
            "查询一条数据成功：${blog.title} - ${blog.content} - ${blog.author.username}");
      }).catchError((e) {

        print(BmobError.convert(e).error);

      }).whenComplete(() {
        print("查询结束");
      });
    } else {
      showError(context, "请先新增一条数据");
    }
  }

  ///删除一条数据
  void _deleteSingle(BuildContext context) {
    if (currentObjectId != null) {
      Blog blog = Blog();
      blog.objectId = currentObjectId;
      blog.delete(successListener: (BmobHandled data) {
        currentObjectId = null;
        print(data.msg);
        showSuccess(context, "删除一条数据成功：${data.msg}");
      }, errorListener: (BmobError error) {
        print(error);
        showError(context, "删除一条数据失败：${error.error}");
      });
    } else {
      showError(context, "请先新增一条数据");
    }
  }

  ///修改一条数据
  void _updateSingle(BuildContext context) {
    if (currentObjectId != null) {
      Blog blog = Blog();
      blog.objectId = currentObjectId;
      blog.title = "修改一条数据";
      blog.content = "修改一条数据";
      blog.update(successListener: (BmobUpdated data) {
        print(data.updatedAt);
        showSuccess(context, "修改一条数据成功：${data.updatedAt}");
      }, errorListener: (BmobError error) {
        print(error);
        showError(context, "修改一条数据失败：${error.error}");
      });
    } else {
      showError(context, "请先新增一条数据");
    }
  }

  ///查询多条数据
  void _queryMulti(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.queryObjects(successListener: (List<dynamic> data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();

      Navigator.pushNamed(context, "listRoute");

      for (Blog blog in blogs) {
        if (blog != null) {
          print(blog.objectId);
          print(blog.title);
          print(blog.content);
        }
      }
    }, errorListener: (BmobError error) {
      print(error.error);
      showError(context, error.error);
    });
  }

  ///删除一个字段的值
  void _deleteFieldValue(BuildContext context) {
    if (currentObjectId != null) {
      Blog blog = Blog();
      blog.objectId = currentObjectId;
      blog.deleteFieldValue("content", successListener: (BmobUpdated data) {
        print(data.updatedAt);
        showSuccess(context, "删除发布内容成功：${data.updatedAt}");
      }, errorListener: (BmobError error) {
        print(error);
        showError(context, "删除发布内容失败：${error.error}");
      });
    } else {
      showError(context, "请先新增一条数据");
    }
  }
}
