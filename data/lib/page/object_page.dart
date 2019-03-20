/**
 * home page
 */
import 'package:flutter/material.dart';
import 'package:data/bmob/table/blog.dart';
import 'package:data/bmob/table/bmob_user.dart';
import 'package:data/bmob/response/bmob_error.dart';
import 'package:data/bmob/response/bmob_saved.dart';
import 'package:data/utils/dialog_util.dart';
import 'package:data/bmob/response/bmob_handled.dart';
import 'package:data/bmob/response/bmob_updated.dart';
import 'package:data/bmob/bmob_query.dart';
import 'package:data/page/list_page.dart';

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
                    _queryMulti(context);
                  },
                  color: Colors.blue[400],
                  child: new Text('查询多条数据',
                      style: new TextStyle(color: Colors.white))),
              RaisedButton(
                  onPressed: () {
                    _queryInclude(context);
                  },
                  color: Colors.blue[400],
                  child: new Text('查询关联字段',
                      style: new TextStyle(color: Colors.white))),
              RaisedButton(
                  onPressed: () {
                    _queryWhereEqual(context);
                  },
                  color: Colors.blue[400],
                  child: new Text('等于条件查询',
                      style: new TextStyle(color: Colors.white))),
              RaisedButton(
                  onPressed: () {
                    _queryWhereNotEqual(context);
                  },
                  color: Colors.blue[400],
                  child: new Text('不等条件查询',
                      style: new TextStyle(color: Colors.white))),
              RaisedButton(
                  onPressed: () {
                    _queryWhereLess(context);
                  },
                  color: Colors.blue[400],
                  child: new Text('小于条件查询',
                      style: new TextStyle(color: Colors.white))),
              RaisedButton(
                  onPressed: () {
                    _queryWhereLessEqual(context);
                  },
                  color: Colors.blue[400],
                  child: new Text('小于等于查询',
                      style: new TextStyle(color: Colors.white))),
              RaisedButton(
                  onPressed: () {
                    _queryWhereLarge(context);
                  },
                  color: Colors.blue[400],
                  child: new Text('大于条件查询',
                      style: new TextStyle(color: Colors.white))),
              RaisedButton(
                  onPressed: () {
                    _queryWhereLargeEqual(context);
                  },
                  color: Colors.blue[400],
                  child: new Text('大于等于查询',
                      style: new TextStyle(color: Colors.white))),
              RaisedButton(
                  onPressed: () {
                    _queryWhereArrayContain(context);
                  },
                  color: Colors.blue[400],
                  child: new Text('数组包含查询',
                      style: new TextStyle(color: Colors.white))),
              RaisedButton(
                  onPressed: () {
                    _queryWhereContainIn(context);
                  },
                  color: Colors.blue[400],
                  child: new Text('范围包含查询',
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

  //查询多条数据
  void _queryInclude(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.setInclude("author");
    query.queryObjects(successListener: (List<dynamic> data) {
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
      showError(context, error.error);
    });
  }

  //等于条件查询
  void _queryWhereEqual(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.addWhereEqualTo("title", "博客标题");
    query.queryObjects(successListener: (List<dynamic> data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
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

  //不等条件查询
  void _queryWhereNotEqual(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.addWhereNotEqualTo("title", "博客标题");
    query.queryObjects(successListener: (List<dynamic> data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
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

  void _queryWhereLess(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.addWhereLessThan("like", 80);
    query.queryObjects(successListener: (List<dynamic> data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
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

  void _queryWhereLessEqual(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.addWhereLessThanOrEqualTo("like", 77);
    query.queryObjects(successListener: (List<dynamic> data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
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

  void _queryWhereLarge(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.addWhereGreaterThan("like", 70);
    query.queryObjects(successListener: (List<dynamic> data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
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

  void _queryWhereLargeEqual(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.addWhereGreaterThanOrEqualTo("like", 77);
    query.queryObjects(successListener: (List<dynamic> data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
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

  void _queryWhereArrayContain(BuildContext context) {}

  void _queryWhereContainIn(BuildContext context) {}
}
