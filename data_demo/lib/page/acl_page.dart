import 'package:flutter/material.dart';
import 'package:data_plugin/bmob/type/bmob_acl.dart';
import '../bean/blog.dart';
import '../bean/user.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/data_plugin.dart';

import 'package:data_plugin/bmob/table/bmob_role.dart';
import 'package:data_plugin/bmob/type/bmob_relation.dart';
class AclPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AclPageState();
  }
}

class _AclPageState extends State<AclPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text("ACL操作"),
      ),
      body: new Container(
        margin: EdgeInsets.all(10.0),
        child: new Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                _saveDataAndPublicAcl();
              },
              color: Colors.blue[400],
              child:
                  Text("添加数据的同时设置所有用户的ACL", style: TextStyle(color: Colors.white)),
            ),



            RaisedButton(
              onPressed: () {
                _saveDataAndUserAcl();
              },
              color: Colors.blue[400],
              child:
              Text("添加数据的同时设置某用户的ACL", style: TextStyle(color: Colors.white)),
            ),

            RaisedButton(
              onPressed: () {
                _saveDataAndRoleAcl();
              },
              color: Colors.blue[400],
              child:
              Text("添加数据的同时设置某角色的ACL", style: TextStyle(color: Colors.white)),
            ),


            RaisedButton(
              onPressed: () {
                _saveRole();
              },
              color: Colors.blue[400],
              child:
              Text("添加角色", style: TextStyle(color: Colors.white)),
            ),

          ],
        ),
      ),
    );
  }

  void _saveDataAndPublicAcl() {
    Blog blog = Blog();
    blog.title = "帖子标题";
    User user = User();
    user.setObjectId("f06590e3c2");
    blog.author = user;
    blog.content = "帖子内容";
    BmobAcl bmobAcl = BmobAcl();
    bmobAcl.setPublicReadAccess(true);
    blog.setAcl(bmobAcl);
    blog.save(successListener: (BmobSaved bmobSaved) {
      print(bmobSaved.objectId);
      DataPlugin.toast(bmobSaved.objectId);
    }, errorListener: (BmobError bmobError) {
      print(bmobError.toString());
      DataPlugin.toast(bmobError.toString());
    });
  }

  void _saveDataAndUserAcl() {
    Blog blog = Blog();
    blog.title = "帖子标题";
    User user = User();
    user.setObjectId("f06590e3c2");
    blog.author = user;
    blog.content = "帖子内容";
    BmobAcl bmobAcl = BmobAcl();
    bmobAcl.addRoleReadAccess(user.getObjectId(),true);
    blog.setAcl(bmobAcl);
    blog.save(successListener: (BmobSaved bmobSaved) {
      print(bmobSaved.objectId);
      DataPlugin.toast(bmobSaved.objectId);
    }, errorListener: (BmobError bmobError) {
      print(bmobError.toString());
      DataPlugin.toast(bmobError.toString());
    });
  }

  void _saveDataAndRoleAcl() {
    Blog blog = Blog();
    blog.title = "帖子标题";
    User user = User();
    user.setObjectId("f06590e3c2");
    blog.author = user;
    blog.content = "帖子内容";
    BmobAcl bmobAcl = BmobAcl();
    bmobAcl.addRoleReadAccess("teacher",true);
    blog.setAcl(bmobAcl);
    blog.save(successListener: (BmobSaved bmobSaved) {
      print(bmobSaved.objectId);
      DataPlugin.toast(bmobSaved.objectId);
    }, errorListener: (BmobError bmobError) {
      print(bmobError.toString());
      DataPlugin.toast(bmobError.toString());
    });
  }

  void _saveRole() {

    BmobRole bmobRole =BmobRole();
    bmobRole.name ="teacher";
    User user = User();
    user.setObjectId("f06590e3c2");
    BmobRelation bmobRelation = BmobRelation();
    bmobRelation.add(user);
    bmobRole.setUsers(bmobRelation);
    bmobRole.save(successListener: (BmobSaved bmobSaved) {
      print(bmobSaved.objectId);
      DataPlugin.toast(bmobSaved.objectId);
    }, errorListener: (BmobError bmobError) {
      print(bmobError.toString());
      DataPlugin.toast(bmobError.toString());
    });
  }


  void _addUserToRole() {

    BmobRole bmobRole =BmobRole();
    bmobRole.name ="teacher";
    User user = User();
    user.setObjectId("f06590e3c2");
    BmobRelation bmobRelation = BmobRelation();
    bmobRelation.add(user);
    bmobRole.setUsers(bmobRelation);
    bmobRole.save(successListener: (BmobSaved bmobSaved) {
      print(bmobSaved.objectId);
      DataPlugin.toast(bmobSaved.objectId);
    }, errorListener: (BmobError bmobError) {
      print(bmobError.toString());
      DataPlugin.toast(bmobError.toString());
    });
  }
}
