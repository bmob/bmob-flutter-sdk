import 'package:flutter/material.dart';
import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/utils/dialog_util.dart';
import '../../bean/blog.dart';

class QueryStatisticsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QueryStatisticsPageState();
  }
}

class _QueryStatisticsPageState extends State<QueryStatisticsPage> {
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
            RaisedButton(
                onPressed: () {
                  _queryGroupBy(context);
                },
                color: Colors.blue[400],
                child: new Text('分组操作',
                    style: new TextStyle(color: Colors.white))),
            RaisedButton(
                onPressed: () {
                  _queryGroupCount(context);

                },
                color: Colors.blue[400],
                child: new Text('返回每个分组的总记录',
                    style: new TextStyle(color: Colors.white))),
            RaisedButton(
                onPressed: () {
                  _querySum(context);
                },
                color: Colors.blue[400],
                child: new Text('计算总和',
                    style: new TextStyle(color: Colors.white))),
            RaisedButton(
                onPressed: () {
                  _queryAverage(context);
                },
                color: Colors.blue[400],
                child: new Text('计算平均值',
                    style: new TextStyle(color: Colors.white))),
            RaisedButton(
                onPressed: () {

                  _queryMax(context);
                },
                color: Colors.blue[400],
                child: new Text('计算最大值',
                    style: new TextStyle(color: Colors.white))),
            RaisedButton(
                onPressed: () {

                  _queryMin(context);
                },
                color: Colors.blue[400],
                child: new Text('计算最小值',
                    style: new TextStyle(color: Colors.white))),
            RaisedButton(
                onPressed: () {

                  _queryHaving(context);
                },
                color: Colors.blue[400],
                child: new Text('分组中的过滤条件',
                    style: new TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }



  ///分组操作，返回某些列的数值
  void _queryGroupBy(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.groupByKeys("title,content,like");
    query.queryObjects().then((data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
      showSuccess(context, data.toString());
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
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  }

  ///是否返回每个分组的总记录
  void _queryGroupCount(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.hasGroupCount(true);
    query.groupByKeys("title,content,like");
    query.queryObjects().then((data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
      showSuccess(context, data.toString());
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
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  }

  ///统计某些列的和
  void _querySum(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.sumKeys("like");
    query.queryObjects().then((data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
      showSuccess(context, data.toString());
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
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  }

  ///统计某些列的平均值
  void _queryAverage(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.averageKeys("like");
    query.queryObjects().then((data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
      showSuccess(context, data.toString());
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
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  }


  ///统计某些列的最大值
  void _queryMax(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.maxKeys("like");
    query.queryObjects().then((data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
      showSuccess(context, data.toString());
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
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  }

  ///统计某些列的最小值
  void _queryMin(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    query.minKeys("like");
    query.queryObjects().then((data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
      showSuccess(context, data.toString());
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
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  }


  ///添加过滤条件
  void _queryHaving(BuildContext context) {
    BmobQuery<Blog> query = BmobQuery();
    Map<String,dynamic> filter = Map();
    filter["title"]="博客标题";
    query.havingFilter(filter);
    query.queryObjects().then((data) {
      List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
      showSuccess(context, data.toString());
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
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  }
}
