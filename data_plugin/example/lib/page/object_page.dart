import 'dart:math';

import 'package:flutter/material.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/utils/dialog_util.dart';
import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import '../bean/blog.dart';
import 'package:data_plugin/bmob/bmob_batch.dart';

import 'package:data_plugin/bmob/table/bmob_object.dart';

class ObjectPage extends StatefulWidget {
  ObjectPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ObjectPageState createState() => _ObjectPageState();
}

class _ObjectPageState extends State<ObjectPage> {
  String? currentObjectId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: new Container(
        margin: new EdgeInsets.all(10.0),
        child: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    _saveSingle(context);
                  },
                  child: new Text('添加一条数据',
                      style: new TextStyle(color: Colors.white))),
              ElevatedButton(
                  onPressed: () {
                    _querySingle(context);
                  },
                  child: new Text('查询一条数据',
                      style: new TextStyle(color: Colors.white))),
              ElevatedButton(
                  onPressed: () {
                    _updateSingle(context);
                  },
                  child: new Text('修改一条数据',
                      style: new TextStyle(color: Colors.white))),
              ElevatedButton(
                  onPressed: () {
                    _deleteSingle(context);
                  },
                  child: new Text('删除一条数据',
                      style: new TextStyle(color: Colors.white))),
              ElevatedButton(
                  onPressed: () {
                    _deleteFieldValue(context);
                  },
                  child: new Text('删除某条数据某个字段的值',
                      style: new TextStyle(color: Colors.white))),
              ElevatedButton(
                  onPressed: () {
                    _queryMulti(context);
                  },
                  child: new Text('查询多条数据',
                      style: new TextStyle(color: Colors.white))),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'queryRoute');
                  },
                  child: new Text('其他查询操作',
                      style: new TextStyle(color: Colors.white))),
              ElevatedButton(
                  onPressed: () {
                    _bmobBatch(context);
                  },
                  child: new Text('批量操作',
                      style: new TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }

  ///保存一条数据
  _saveSingle(BuildContext context) {
    BmobUser bmobUser = BmobUser();
    bmobUser.objectId = "7c7fd3afe1";
    Blog blog = Blog();
    blog.title = "blogtitle";
    blog.content = "blogcontent";
    blog.author = bmobUser;
    blog.like = 77;
    blog.save().then((BmobSaved bmobSaved) {
      String message =
          "创建一条数据成功：${bmobSaved.objectId} - ${bmobSaved.createdAt}";
      currentObjectId = bmobSaved.objectId;
      showSuccess(context, message);
    }).catchError((e) {
      showError(context, BmobError.convert(e)!.error!);
    });
  }

  ///查询一条数据
  _querySingle(BuildContext context) {
    if (currentObjectId != null) {
      BmobQuery<Blog> bmobQuery = BmobQuery();
      bmobQuery.setInclude("author");
      bmobQuery.queryObject(currentObjectId).then((data) {
        Blog blog = Blog.fromJson(data);
        showSuccess(context,
            "查询一条数据成功：${blog.title} - ${blog.content} - ${blog.author!.username}");
      }).catchError((e) {
        showError(context, BmobError.convert(e)!.error!);
      });
    } else {
      showError(context, "请先新增一条数据");
    }
  }

  ///查询多条数据
//  _queryMulti(BuildContext context) {
//    BmobQuery<Blog> query = BmobQuery();
//    query.setLimit(5);
//    query.queryObjects().then((List<dynamic> data) {
//      print(data);
//      showSuccess(context, data.toString());
//      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
//      for (Blog blog in blogs) {
//        if (blog != null) {
//          print(blog.objectId);
//          print(blog.title);
//          print(blog.content);
//        }
//      }
//    }).catchError((e) {
//      showError(context, BmobError.convert(e).error);
//    });
//  }

  _queryMulti(BuildContext context) {
    BmobQuery<BmobUser> query = BmobQuery();
    query.setLimit(5);
    query.queryUsers().then((List<dynamic>? data) {
      print(data);
      showSuccess(context, data.toString());
      List<BmobUser> blogs = data!.map((i) => BmobUser.fromJson(i)).toList();
      for (BmobUser blog in blogs) {
        if (blog != null) {
          print(blog.objectId);
        }
      }
    }).catchError((e) {
      showError(context, BmobError.convert(e)!.error!);
    });
  }

  ///删除一条数据
  _deleteSingle(BuildContext context) {
    if (currentObjectId != null) {
      Blog blog = Blog();
      blog.objectId = currentObjectId;
      blog.delete().then((BmobHandled bmobHandled) {
        currentObjectId = null;
        showSuccess(context, "删除一条数据成功：${bmobHandled.msg}");
      }).catchError((e) {
        showError(context, BmobError.convert(e)!.error!);
      });
    } else {
      showError(context, "请先新增一条数据");
    }
  }

  ///修改一条数据
  _updateSingle(BuildContext context) {
    if (currentObjectId != null) {
      Blog blog = Blog();
      blog.objectId = currentObjectId;
      blog.title = "修改一条数据";
      blog.content = "修改一条数据";
      blog.update().then((BmobUpdated bmobUpdated) {
        showSuccess(context, "修改一条数据成功：${bmobUpdated.updatedAt}");
      }).catchError((e) {
        showError(context, BmobError.convert(e)!.error!);
      });
    } else {
      showError(context, "请先新增一条数据");
    }
  }

  ///删除一个字段的值
  _deleteFieldValue(BuildContext context) {
    if (currentObjectId != null) {
      Blog blog = Blog();
      blog.objectId = currentObjectId;
      blog.deleteFieldValue("content").then((BmobUpdated bmobUpdated) {
        showSuccess(context, "删除发布内容成功：${bmobUpdated.updatedAt}");
      }).catchError((e) {
        showError(context, "删除发布内容失败" + BmobError.convert(e)!.error!);
      });
    } else {
      showError(context, "请先新增一条数据");
    }
  }

  void _bmobBatch(BuildContext context) {
    Blog blog1 = Blog();
    blog1.content = "批量1";

    Blog blog2 = Blog();
    blog2.content = "批量2";

    Blog blog3 = Blog();
    blog3.content = "批量3";

    List<BmobObject> bmobObjects = <BmobObject>[];
    bmobObjects.add(blog1);
    bmobObjects.add(blog2);
    bmobObjects.add(blog3);

    BmobBatch batch = BmobBatch();
    batch.insertBatch(bmobObjects).then((List list) {
      for (var item in list) {
        print(item);
      }
    }).catchError((e) {
      showError(context, e.toString());
    });
  }
}
