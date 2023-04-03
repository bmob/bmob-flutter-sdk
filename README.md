# bmob-flutter-sdk
Bmob Flutter SDK

Flutter官方咨询QQ群：788254534


# 1、集成

## 1.1、下载源码

克隆Bmob Flutter SDK，下载地址：[下载Bmob Flutter SDK](./data_plugin/)，并把data_plugin文件夹放到和 ```你的项目同一级 ```的位置。

## 1.2、修改配置

修改项目的配置文件 pubspec.yaml文件，在依赖节点 dependencies 中新增项：
```
  data_plugin:
    path: ../data_plugin
```

## 1.3、导入
导入语句：
```
import 'package:data_plugin/data_plugin.dart';
```

## 1.4、平台
目前涉及到特定平台信息处理的方法只适配了Android外，其他方法均兼容Android、iOS。

## 1.5、参考
源码：
```
https://github.com/bmob/bmob-flutter-sdk/tree/master/data_plugin
```
案例：
```
https://github.com/bmob/bmob-flutter-sdk/tree/master/data_demo
```
# 2、使用

1、初始化

在runApp中进行一下初始化操作：
```
/**
 * 非加密方式初始化
 */
Bmob.init("你的备案域名", "appId", "apiKey");
```
```
/**
 * 超级权限非加密方式初始化
 */
Bmob.initMasterKey("你的备案域名", "appId","apiKey","masterKey");
```
```
/**
 * 加密方式初始化
 */
Bmob.initEncryption("你的备案域名", "secretKey", "apiSafe");
```
```
/**
 * 超级权限加密方式初始化
 */
Bmob.initEncryptionMasterKey("你的备案域名","secretKey","apiSafe","masterKey");

```
2、导入源码

Dart要求，在使用具体功能代码的时候需要先导入对应代码的所在源文件。
例如，使用BmobUser前需要导入：
```
import 'package:data_plugin/bmob/table/bmob_user.dart';
```
3、发布库

此SDK插件只用于Bmob数据服务相关的数据操作，与此服务无关的UI以及其他涉及平台功能的操作需要开发者自行编写。Dart允许开发者自己编写相关的UI库以及平台插件，并发布到Dart仓库供所有开发者使用，具体可以参考：

https://zhuanlan.zhihu.com/p/60136574

## 2.1、数据类型

### 2.1.1、基本数据类型
1、基本数据类型 BmobObject

|属性|解释|
|----|----|
|objectId|数据唯一标志|
|createdAt|数据创建时间|
|updatedAt|数据更新时间|
|ACL|数据访问权限|


2、时间类型 BmobDate

|属性|解释|
|----|----|
|iso|时间|

3、文件类型 BmobFile

|属性|解释|
|----|----|
|url|文件地址|
|filename|文件名称|

4、位置类型 BmobGeoPoint

|属性|解释|
|----|----|
|latitude|纬度|
|longitude|经度|

5、用户类型 BmobUser

继承自BmobObject

|属性|解释|
|----|----|
|username|用户名|
|password|密码
|email|邮箱|
|emailVerified|邮箱是否验证|
|mobilePhoneNumber|手机号码|
|mobilePhoneNumberVerified|手机号码是否验证|

6、设备类型 BmobInstallation

|属性|解释|
|----|----|
|installationId|设备ID|

7、角色类型 BmobRole

|属性|解释|
|----|----|
|name|角色名称|
|roles|子角色|
|users|角色用户|

### 2.1.2、自定义数据类型

1、继承BmobObject

2、进行JSON序列化处理
参考：
```
https://zhuanlan.zhihu.com/p/59932453
```
### 2.1.3、错误类型
|属性|解释|
|----|----|
|code|错误代码|
|error|错误信息|

获取错误信息
```
BmobError bmobError = BmobError.convert(e);
```


## 2.2、增删改查一条数据

新增：
```
///保存一条数据
_saveSingle(BuildContext context) {
  BmobUser bmobUser = BmobUser();
  bmobUser.objectId = "7c7fd3afe1";
  Blog blog = Blog();
  blog.title = "博客标题";
  blog.content = "博客内容";
  blog.author = bmobUser;
  blog.like = 77;
  blog.save().then((BmobSaved bmobSaved) {
    String message =
        "创建一条数据成功：${bmobSaved.objectId} - ${bmobSaved.createdAt}";
    currentObjectId = bmobSaved.objectId;
    showSuccess(context, message);
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```

查询：
```
///查询一条数据
_querySingle(BuildContext context) {
  if (currentObjectId != null) {
    BmobQuery<Blog> bmobQuery = BmobQuery();
    bmobQuery.setInclude("author");
    bmobQuery.queryObject(currentObjectId).then((data) {
      Blog blog = Blog.fromJson(data);
      showSuccess(context,
          "查询一条数据成功：${blog.title} - ${blog.content} - ${blog.author.username}");
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  } else {
    showError(context, "请先新增一条数据");
  }
}
```

修改：
```
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
      showError(context, BmobError.convert(e).error);
    });
  } else {
    showError(context, "请先新增一条数据");
  }
}
```

删除：
```
///删除一条数据
_deleteSingle(BuildContext context) {
  if (currentObjectId != null) {
    Blog blog = Blog();
    blog.objectId = currentObjectId;
    blog.delete().then((BmobHandled bmobHandled) {
      currentObjectId = null;
      showSuccess(context, "删除一条数据成功：${bmobHandled.msg}");
    }).catchError((e) {
      showError(context, BmobError.convert(e).error);
    });
  } else {
    showError(context, "请先新增一条数据");
  }
}
```
删除字段值：
```
///删除一个字段的值
_deleteFieldValue(BuildContext context) {
  if (currentObjectId != null) {
    Blog blog = Blog();
    blog.objectId = currentObjectId;
    blog.deleteFieldValue("content").then((BmobUpdated bmobUpdated) {
      showSuccess(context, "删除发布内容成功：${bmobUpdated.updatedAt}");
    }).catchError((e) {
      showError(context, "删除发布内容失败" + BmobError.convert(e).error);
    });
  } else {
    showError(context, "请先新增一条数据");
  }
}
```

## 2.3、查询多条数据

等于：
```
///等于条件查询
void _queryWhereEqual(BuildContext context) {
  BmobQuery<Blog> query = BmobQuery();
  query.addWhereEqualTo("title", "博客标题");
  query.queryObjects().then((data) {
    showSuccess(context, data.toString());
    List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
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
```
不等于：
```
///不等条件查询
void _queryWhereNotEqual(BuildContext context) {
  BmobQuery<Blog> query = BmobQuery();
  query.addWhereNotEqualTo("title", "博客标题");
  query.queryObjects().then((data) {
    showSuccess(context, data.toString());
    List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
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
```
小于：
```
///小于查询
_queryWhereLess(BuildContext context) {
  BmobQuery<Blog> query = BmobQuery();
  query.addWhereLessThan("like", 80);
  query.queryObjects().then((data) {
    showSuccess(context, data.toString());
    List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
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
```
小于等于：
```
///小于等于查询
_queryWhereLessEqual(BuildContext context) {
  BmobQuery<Blog> query = BmobQuery();
  query.addWhereLessThanOrEqualTo("like", 77);
  query.queryObjects().then((data) {
    showSuccess(context, data.toString());
    List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
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
```
大于：
```
///大于查询
_queryWhereLarge(BuildContext context) {
  BmobQuery<Blog> query = BmobQuery();
  query.addWhereGreaterThan("like", 70);
  query.queryObjects().then((data) {
    showSuccess(context, data.toString());
    List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
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
```
大于等于：
```
///大于等于查询
_queryWhereLargeEqual(BuildContext context) {
  BmobQuery<Blog> query = BmobQuery();
  query.addWhereGreaterThanOrEqualTo("like", 77);
  query.queryObjects().then((data) {
    showSuccess(context, data.toString());
    List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
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
```
## 2.4、关联操作

添加：
```
///添加关联关系
_addPointer() {
  Blog blog = Blog();
  User user = User();
  user.objectId = "4760e7a143";
  blog.author = user;
  blog.title = "添加关联关系";
  blog.content = "添加帖子对应的作者";
  blog.save().then((BmobSaved bmobSaved) {
    currentObjectId = bmobSaved.objectId;
    print(bmobSaved.objectId);
    DataPlugin.toast("添加成功：\n${bmobSaved.objectId}\n${bmobSaved.createdAt}");
  }).catchError((e) {
    DataPlugin.toast(BmobError.convert(e).error);
  });
}
```
解除：
```
///解除关联关系
_deletePointer() {
  if (currentObjectId == null) {
    DataPlugin.toast("请先添加关联关系");
    return;
  }
  Blog blog = Blog();
  blog.objectId = currentObjectId;
  blog.deleteFieldValue("author").then((BmobUpdated bmobUpdated) {
    DataPlugin.toast(bmobUpdated.updatedAt);
  }).catchError((e) {
    DataPlugin.toast(BmobError.convert(e).error);
  });
}
```
修改：
```
///修改关联关系
_modifyPointer() {
  if (currentObjectId == null) {
    DataPlugin.toast("请先添加关联关系");
    return;
  }
  Blog blog = Blog();
  blog.objectId = currentObjectId;
  User user = User();
  user.objectId = "358f092cb1";
  blog.author = user;
  blog.update().then((BmobUpdated bmobUpdated) {
    DataPlugin.toast(bmobUpdated.updatedAt);
  }).catchError((e) {
    DataPlugin.toast(BmobError.convert(e).error);
  });
}
```
查询：
```
///查询关联数据
_queryPointer() {
  BmobQuery<Blog> query = BmobQuery();
  query.setInclude("author");
  query.queryObjects().then((data) {
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
  }).catchError((e) {
    DataPlugin.toast(BmobError.convert(e).error);
  });
}
```

## 2.5、位置操作
添加：
```
///添加地理位置信息
_addGeoPoint() {
  Blog blog = Blog();
  BmobGeoPoint bmobGeoPoint = BmobGeoPoint();
  bmobGeoPoint.latitude = 12.4445;
  bmobGeoPoint.longitude = 124.122;
  blog.addr = bmobGeoPoint;
  blog.save().then((BmobSaved bmobSaved) {
    String message =
        "创建一条数据成功：${bmobSaved.objectId} - ${bmobSaved.createdAt}";
    showSuccess(context, message);
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```


## 2.6、时间操作

添加：
```
///添加时间数据
_addDate() {
  DateTime dateTime = DateTime.now();
  BmobDate bmobDate = BmobDate();
  bmobDate.setDate(dateTime);
  Blog blog = Blog();
  blog.time = bmobDate;
  blog.title = "添加时间类型";
  blog.content = "测试时间类型的请求";
  blog.save().then((BmobSaved bmobSaved) {
    showSuccess(context, bmobSaved.objectId);
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```

获取服务器时间：
```
///获取服务器时间
_getServerTime() {
  BmobDateManager.getServerTimestamp().then((ServerTime serverTime) {
    showSuccess(context, "${serverTime.timestamp}\n${serverTime.datetime}");
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```

## 2.7、文件操作

上传文件，Android在上传前需先允许文件访问权限，可以使用SDK自带的文件选择器。
```
///上传文件，上传文件涉及到android的文件访问权限，调用此方法前需要开发者们先适配好应用在各个android版本的权限管理。
_uploadFile(String path) {
  if (path == null) {
    DataPlugin.toast("请先选择文件");
    return;
  }
  DataPlugin.toast("上传中，请稍候……");
  File file = new File(path);
  BmobFileManager.upload(file).then((BmobFile bmobFile) {
    _bmobFile = bmobFile;
    _url = bmobFile.url;
    print("${bmobFile.cdn}\n${bmobFile.url}\n${bmobFile.filename}");
    DataPlugin.toast(
        "上传成功：${bmobFile.cdn}\n${bmobFile.url}\n${bmobFile.filename}");
  }).catchError((e) {
    DataPlugin.toast(BmobError.convert(e).error);
  });
}
```
添加已上传文件到表中：
```
///添加文件到表中
_addFile(BmobFile bmobFile) {
  if (bmobFile == null) {
    DataPlugin.toast("请先上传文件");
    return;
  }
  Blog blog = Blog();
  blog.pic = bmobFile;
  blog.save().then((BmobSaved bmobSaved) {
    DataPlugin.toast("添加成功：" + bmobSaved.objectId);
  }).catchError((e) {
    DataPlugin.toast(BmobError.convert(e).error);
  });
}
```
下载已上传文件：
```
///下载文件，直接使用dio下载，下载文件涉及到android的文件访问权限，调用此方法前需要开发者们先适配好应用在各个android版本的权限管理。
_downloadFile(String url, String path) async {
  if (url == null) {
    DataPlugin.toast("请先上传文件");
    return;
  }
  Dio dio = Dio();
  Response<dynamic> response = await dio.download(url, path);
  print(response.toString());
  print(response.data);
  DataPlugin.toast("下载结束");
}
```
删除已上传文件：
```
///删除文件
_deleteFile(String url) {
  if (url == null) {
    DataPlugin.toast("请先上传文件");
    return;
  }
  BmobFileManager.delete(url).then((BmobHandled bmobHandled) {
    DataPlugin.toast("删除成功：" + bmobHandled.msg);
  }).catchError((e) {
    DataPlugin.toast(BmobError.convert(e).error);
  });
}
```
## 2.8、用户操作
登录：
```
///用户名和密码登录
_login(BuildContext context) {
  BmobUser bmobUserRegister = BmobUser();
  bmobUserRegister.username = _email;
  bmobUserRegister.password = _password;
  bmobUserRegister.login().then((BmobUser bmobUser) {
    showSuccess(context, bmobUser.getObjectId() + "\n" + bmobUser.username);
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```
注册：
```
///用户名密码注册
_register() {
  BmobUser bmobUserRegister = BmobUser();
  bmobUserRegister.username = _username;
  bmobUserRegister.password = _password;
  bmobUserRegister.register().then((BmobRegistered data) {
    showSuccess(context, data.objectId);
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```
手机短信验证码登录：
```
///发送短信验证码：需要手机号码
_sendSms(BuildContext context) {
  BmobSms bmobSms = BmobSms();
  bmobSms.template = "";
  bmobSms.mobilePhoneNumber = _phoneNumber;
  bmobSms.sendSms().then((BmobSent bmobSent) {
    showSuccess(context, "发送成功:" + bmobSent.smsId.toString());
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```
```
///手机号码+短信验证码登录
_loginBySms(BuildContext context) {
  BmobUser bmobUserRegister = BmobUser();
  bmobUserRegister.mobilePhoneNumber = _phoneNumber;
  bmobUserRegister.loginBySms(_smsCode).then((BmobUser bmobUser) {
    showSuccess(context, "登录成功："+bmobUser.getObjectId() + "\n" + bmobUser.username);
  }).catchError((e) {
    print(e);
    showError(context, BmobError.convert(e).error);
  });
}
```
手机短信验证码重置密码：
```
///发送短信验证码：需要手机号码
_sendSms(BuildContext context) {
  BmobSms bmobSms = BmobSms();
  bmobSms.template = "";
  bmobSms.mobilePhoneNumber = _phoneNumber;
  bmobSms.sendSms().then((BmobSent bmobSent) {
    showSuccess(context, "发送成功:" + bmobSent.smsId.toString());
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```
```
///手机号码+短信验证码重置密码
_resetBySms(BuildContext context) {
  BmobUser bmobUser = BmobUser();
  bmobUser.mobilePhoneNumber = _phoneNumber;
  bmobUser
      .requestPasswordResetBySmsCode(_smsCode)
      .then((BmobHandled bmobHandled) {})
      .catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```
邮箱重置密码：
```
///发送重置密码邮件到邮箱，然后在邮件中重置密码，最后在应用中重新登录
_sendEmail(BuildContext context) {
  BmobUser bmobUser = BmobUser();
  bmobUser.email = _email;
  bmobUser
      .requestPasswordResetByEmail()
      .then((BmobHandled bmobHandled) {})
      .catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```
## 2.9、角色操作
添加角色：
```
///添加角色
_saveRole() {
  BmobRole bmobRole = BmobRole();
  bmobRole.name = "teacher";
  User user = User();
  user.setObjectId("f06590e3c2");
  BmobRelation bmobRelation = BmobRelation();
  bmobRelation.add(user);
  bmobRole.setUsers(bmobRelation);
  bmobRole.save().then((BmobSaved bmobSaved) {
    DataPlugin.toast(bmobSaved.objectId);
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```

添加角色并添加某用户到该角色中：
```
///添加某用户到某角色中
_addUserToRole() {
  BmobRole bmobRole = BmobRole();
  bmobRole.name = "student";
  User user = User();
  user.setObjectId("f06590e3c2");
  BmobRelation bmobRelation = BmobRelation();
  bmobRelation.add(user);
  bmobRole.setUsers(bmobRelation);
  bmobRole.save().then((BmobSaved bmobSaved) {
    DataPlugin.toast(bmobSaved.objectId);
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```

添加某用户到已存在的角色中：
```
///添加用户到已存在的角色中
_addUserToSavedRole() {
  if (currentBmobRole == null) {
    showError(context, "请先创造角色");
    return;
  }
  User user = User();
  user.setObjectId("f06590e3c2");
  BmobRelation bmobRelation = BmobRelation();
  bmobRelation.add(user);
  currentBmobRole.setUsers(bmobRelation);
  currentBmobRole.update().then((BmobUpdated bmobUpdated) {
    DataPlugin.toast(bmobUpdated.updatedAt);
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```

## 2.10、数据访问权限操作

设置数据公共访问权限：
```
///设置数据公共访问权限
_saveDataAndPublicAcl() {
  Blog blog = Blog();
  blog.title = "帖子标题";
  User user = User();
  user.setObjectId("f06590e3c2");
  blog.author = user;
  blog.content = "帖子内容";
  BmobAcl bmobAcl = BmobAcl();
  bmobAcl.setPublicReadAccess(true);
  blog.setAcl(bmobAcl);
  blog.save().then((BmobSaved bmobSaved) {
    DataPlugin.toast(bmobSaved.objectId);
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```
设置某用户对该数据的访问权限：
```
///设置某用户对该数据的访问权限
_saveDataAndUserAcl() {
  Blog blog = Blog();
  blog.title = "帖子标题";
  User user = User();
  user.setObjectId("f06590e3c2");
  blog.author = user;
  blog.content = "帖子内容";
  BmobAcl bmobAcl = BmobAcl();
  bmobAcl.addRoleReadAccess(user.getObjectId(), true);
  blog.setAcl(bmobAcl);
  blog.save().then((BmobSaved bmobSaved) {
    DataPlugin.toast(bmobSaved.objectId);
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```
设置某角色对该数据的访问权限：
```
///设置某角色对该数据的访问权限
_saveDataAndRoleAcl() {
  Blog blog = Blog();
  blog.title = "帖子标题";
  User user = User();
  user.setObjectId("f06590e3c2");
  blog.author = user;
  blog.content = "帖子内容";
  BmobAcl bmobAcl = BmobAcl();
  bmobAcl.addRoleReadAccess("teacher", true);
  blog.setAcl(bmobAcl);
  blog.save().then((BmobSaved bmobSaved) {
    DataPlugin.toast(bmobSaved.objectId);
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```

## 2.11、设备操作
获取设备ID：
```
///获取设备ID
_getInstallationId(BuildContext context) async {
  String installationId = await BmobInstallationManager.getInstallationId();
  showSuccess(context, installationId);
}
```
初始化设备信息：
```
//初始化设备，与原生交互
///初始化设备
_initInstallation(BuildContext context) {
  BmobInstallationManager.init().then((BmobInstallation bmobInstallation) {
    showSuccess(context, bmobInstallation.toJson().toString());
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```


## 2.12、短信操作

发送短信验证码：
```
///发送短信验证码：需要手机号码
_sendSms(BuildContext context) {
  BmobSms bmobSms = BmobSms();
  bmobSms.template = "";
  bmobSms.mobilePhoneNumber = _phoneNumber;
  bmobSms.sendSms().then((BmobSent bmobSent) {
    showSuccess(context, "发送成功:" + bmobSent.smsId.toString());
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```
验证短信验证码：
```
///验证短信验证码：需要手机号码和验证码
_verifySmsCode(BuildContext context) {
  BmobSms bmobSms = BmobSms();
  bmobSms.mobilePhoneNumber = _phoneNumber;
  bmobSms.verifySmsCode(_smsCode).then((BmobHandled bmobHandled) {
    showSuccess(context, "验证成功：" + bmobHandled.msg);
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```

## 2.13、数据监听

```
///数据监听
_listen() {
  RealTimeDataManager.getInstance().listen(onConnected: (Client client) {
    showSuccess(context, "监听数据连接成功，开始订阅消息！");
    client.subTableUpdate("Blog");
  }, onDisconnected: () {
    showError(context, "监听数据断开连接");
  }, onDataChanged: (Change data) {
    ///注意：此处返回的data.data类型与Blog类型不一致，需要使用map来获取具体属性值而不是使用Blog
    Map map = data.data;
    showSuccess(context, "监听到数据变化：" + map.toString());
  }, onError: (error) {
    showError(context, error.toString());
  });
}

///改编数据
_change(context) {
  ///保存一条数据
  BmobUser bmobUser = BmobUser();
  bmobUser.objectId = "7c7fd3afe1";
  Blog blog = Blog();
  blog.title = "博客标题";
  blog.content = "博客内容";
  blog.author = bmobUser;
  blog.like = 77;
  blog.save().then((BmobSaved bmobSaved) {
    String message =
        "创建一条数据成功：${bmobSaved.objectId} - ${bmobSaved.createdAt}";
    showSuccess(context, message);
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```

监听成功后的订阅动作：

|方法|解释|
|---|---|
|subTableUpdate|订阅表更新|
|subTableDelete|订阅表删除|
|subRowUpdate|订阅行更新|
|subRowDelete|订阅行删除|

## 2.14、排序

正序：
setOrder("字段名称");
逆序：
setOrder("-字段名称");

```
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
```

## 2.15、分页

设置返回条数：
setLimit(int value);

设置忽略条数：
setSkip(int value);

```
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
```

## 2.16 统计查询

分组操作，返回某些列的数值：
```
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
```
返回每个分组的总记录：
```
///返回每个分组的总记录
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
```
统计某些列的和：
```
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
```
统计某些列的平均值：
```
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
```
统计某些列的最大值：
```
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
```
统计某些列的最小值：
```
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
```
添加过滤条件：
```
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

```

## 2.1.7、个数查询

```
///查询数据个数
void _queryCount(BuildContext context) {
  BmobQuery<Blog> query = BmobQuery();
  query.queryCount().then((int count) {
    showSuccess(context, "个数： $count");
  }).catchError((e) {
    showError(context, BmobError.convert(e).error);
  });
}
```


## 2.1.8、查询用户

查询单个用户
```
BmobQuery<User> query = BmobQuery();
query.queryUser("8e64dd60d2").then((data) {
  showSuccess(context, User.fromJson(data).username);
}).catchError((e) {
  showError(context, BmobError.convert(e).error);
});

```
查询多个用户
```
BmobQuery<User> query = BmobQuery();
query.queryUsers().then((data) {
  showSuccess(context, data.toString());
  List<User> users =
      data.map((i) => User.fromJson(i)).toList();
  for (User user in users) {
    if (user != null) {
      print(user.objectId);
    }
  }
}).catchError((e) {
  showError(context, BmobError.convert(e).error);
});
```
## 2.1.9、查询设备

查询单个设备
```
BmobQuery<BmobInstallation> query = BmobQuery();
query.queryInstallation("3795adbcad").then((data) {
  showSuccess(context, BmobInstallation.fromJson(data).installationId);
}).catchError((e) {
  showError(context, BmobError.convert(e).error);
});

```
查询多个设备
```
BmobQuery<BmobInstallation> query = BmobQuery();
query.queryInstallations().then((data) {
  showSuccess(context, data.toString());
  List<BmobInstallation> installations =
  data.map((i) => BmobInstallation.fromJson(i)).toList();
  for (BmobInstallation installation in installations) {
    if (installation != null) {
      print(installation.installationId);
      print(installation.objectId);
    }
  }
}).catchError((e) {
  showError(context, BmobError.convert(e).error);
});

```

## 2.1.10、复合查询

### 或查询
```
void _queryOr(BuildContext context){
  BmobQuery<Blog> query1 = BmobQuery();
  query1.addWhereEqualTo("content", "内容");

  BmobQuery<Blog> query2 = BmobQuery();
  query2.addWhereEqualTo("title", "标题");

  BmobQuery<Blog> query = BmobQuery();
  List<BmobQuery<Blog>> list = new List();
  list.add(query1);
  list.add(query2);
  query.or(list);
  query.queryObjects().then((data) {
    showSuccess(context, data.toString());
    List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
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
```



### 与查询


```

void _queryAnd(BuildContext context){
  BmobQuery<Blog> query1 = BmobQuery();
  query1.addWhereEqualTo("content", "内容");

  BmobQuery<Blog> query2 = BmobQuery();
  query2.addWhereEqualTo("title", "标题");

  BmobQuery<Blog> query = BmobQuery();
  List<BmobQuery<Blog>> list = new List();
  list.add(query1);
  list.add(query2);
  query.and(list);
  query.queryObjects().then((data) {
    showSuccess(context, data.toString());
    List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
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
```

## 2.1.11、发送验证邮箱

开启：设置--邮件设置--验证邮箱。
```
BmobUser.requestEmailVerify("邮箱").then((BmobHandled handled){

  showSuccess(context, handled.toJson().toString());
}).catchError((e){

  showError(context, BmobError.convert(e).error);
});

```

# 2.1.12、批量操作

批量添加：

```
void _bmobBatch(BuildContext context) {
  Blog blog1 = Blog();
  blog1.content = "批量1";

  Blog blog2 = Blog();
  blog2.content = "批量2";

  Blog blog3 = Blog();
  blog3.content = "批量3";

  List<BmobObject> bmobObjects = List();
  bmobObjects.add(blog1);
  bmobObjects.add(blog2);
  bmobObjects.add(blog3);

  BmobBatch batch = BmobBatch();
  //deleteBatch
  batch.insertBatch(bmobObjects).then((List list) {
    for (var item in list) {
      print(item);
    }
  }).catchError((e) {
    showError(context, e.toString());
  });
}
```


批量删除：
```
deleteBatch
```

批量修改：
```
updateBatch
```


