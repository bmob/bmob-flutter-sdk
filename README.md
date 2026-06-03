<p align="center">
  <h1 align="center">Bmob Flutter SDK</h1>
  <p align="center">Bmob 后端即服务（BaaS）平台 Flutter 客户端 SDK</p>
</p>

<p align="center">
  <a href="https://bmob.cn">
    <img src="https://img.shields.io/badge/Platform-Flutter-blue.svg" alt="Platform">
  </a>
  <a href="https://dart.dev">
    <img src="https://img.shields.io/badge/Dart-%3E%3D2.12.0-blue.svg" alt="Dart SDK">
  </a>
  <a href="https://github.com/bmob/bmob-flutter-sdk">
    <img src="https://img.shields.io/badge/SDK%20Version-0.0.19-green.svg" alt="Version">
  </a>
  <a href="https://bmob.cn">
    <img src="https://img.shields.io/badge/License-MIT-orange.svg" alt="License">
  </a>
</p>

---

## 特性

- **数据存储** — 自定义数据模型 CRUD、批量操作、条件查询、统计查询
- **用户系统** — 注册/登录、短信验证码登录、密码重置、邮箱验证
- **文件管理** — 文件上传/下载/删除，支持关联到数据表
- **短信服务** — 验证码发送与校验
- **实时数据** — WebSocket 监听表/行级别的数据变更
- **位置服务** — 地理位置存储与查询
- **ACL 权限** — 基于用户/角色的数据访问控制
- **关联操作** — Pointer 一对一、Relation 一对多
- **设备管理** — 设备注册与查询
- **安全模式** — 支持普通、加密、MasterKey 三种认证方式

## 平台支持

| 平台 | 支持情况 |
| :---: | :---: |
| Android | ✅ |
| iOS | ✅ |

> **注**：`BmobInstallation` 设备管理相关功能目前仅适配 Android 平台，其余功能均兼容 Android 和 iOS。

## 快速开始

### 1. 安装

将 `data_plugin` 目录克隆至与你的 Flutter 项目同级目录下：

```bash
git clone https://github.com/bmob/bmob-flutter-sdk.git
cp -r bmob-flutter-sdk/data_plugin /your_flutter_project/
```

在项目 `pubspec.yaml` 中添加本地依赖：

```yaml
dependencies:
  data_plugin:
    path: ../data_plugin
```

然后执行：

```bash
flutter pub get
```

### 2. 初始化

在 `main.dart` 的 `runApp` 之前完成 SDK 初始化：

```dart
import 'package:data_plugin/bmob/bmob.dart';

void main() {
  // 普通模式
  Bmob.init("你的备案域名", "appId", "apiKey");

  // 超级权限模式
  // Bmob.initMasterKey("你的备案域名", "appId", "apiKey", "masterKey");

  // 加密模式
  // Bmob.initEncryption("你的备案域名", "secretKey", "apiSafe");

  // 超级权限 + 加密模式
  // Bmob.initEncryptionMasterKey("你的备案域名", "secretKey", "apiSafe", "masterKey");

  runApp(MyApp());
}
```

### 3. 导入

根据需要导入对应模块：

```dart
// 数据模型基类
import 'package:data_plugin/bmob/table/bmob_object.dart';

// 用户模型
import 'package:data_plugin/bmob/table/bmob_user.dart';

// 查询引擎
import 'package:data_plugin/bmob/bmob_query.dart';

// 文件管理
import 'package:data_plugin/bmob/bmob_file_manager.dart';

// 短信服务
import 'package:data_plugin/bmob/bmob_sms.dart';

// 实时数据监听
import 'package:data_plugin/bmob/realtime/realtime_data_manager.dart';

// 响应模型
import 'package:data_plugin/bmob/response/bmob_saved.dart';
import 'package:data_plugin/bmob/response/bmob_updated.dart';
import 'package:data_plugin/bmob/response/bmob_handled.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
```

## 使用指南

### 数据模型

#### 内置数据类型

| 类型 | 说明 | 核心属性 |
| :--- | :--- | :--- |
| `BmobObject` | 数据基类 | `objectId`, `createdAt`, `updatedAt`, `ACL` |
| `BmobUser` | 用户模型（继承 BmobObject） | `username`, `password`, `email`, `mobilePhoneNumber` |
| `BmobRole` | 角色模型 | `name`, `roles`, `users` |
| `BmobInstallation` | 设备模型 | `installationId` |
| `BmobDate` | 日期类型 | `iso` |
| `BmobFile` | 文件类型 | `url`, `filename` |
| `BmobGeoPoint` | 地理位置 | `latitude`, `longitude` |
| `BmobPointer` | 一对一关联 | — |
| `BmobRelation` | 一对多关联 | — |
| `BmobAcl` | 访问控制 | — |

#### 自定义数据模型

1. 继承 `BmobObject`
2. 实现 `getParams()` 方法返回字段映射
3. 可选：使用 `json_serializable` 生成序列化代码

```dart
import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blog.g.dart';

@JsonSerializable()
class Blog extends BmobObject {
  String? title;
  String? content;
  int? like;

  Blog({this.title, this.content, this.like});

  @override
  Map getParams() => {'title': title, 'content': content, 'like': like};

  factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);
  Map<String, dynamic> toJson() => _$BlogToJson(this);
}
```

修改模型后运行代码生成：

```bash
cd data_plugin && flutter pub run build_runner build
```

### 增删改查

#### 新增

```dart
Blog blog = Blog();
blog.title = "博客标题";
blog.content = "博客内容";
blog.like = 77;

blog.save().then((BmobSaved bmobSaved) {
  print("创建成功：${bmobSaved.objectId} - ${bmobSaved.createdAt}");
}).catchError((e) {
  print("创建失败：${BmobError.convert(e).error}");
});
```

#### 查询单条

```dart
BmobQuery<Blog> query = BmobQuery();
query.setInclude("author");
query.queryObject(objectId).then((data) {
  Blog blog = Blog.fromJson(data);
  print("${blog.title} - ${blog.content}");
}).catchError((e) {
  print("查询失败：${BmobError.convert(e).error}");
});
```

#### 修改

```dart
Blog blog = Blog();
blog.objectId = currentObjectId;
blog.title = "修改后的标题";

blog.update().then((BmobUpdated bmobUpdated) {
  print("修改成功：${bmobUpdated.updatedAt}");
}).catchError((e) {
  print("修改失败：${BmobError.convert(e).error}");
});
```

#### 删除

```dart
Blog blog = Blog();
blog.objectId = currentObjectId;

blog.delete().then((BmobHandled bmobHandled) {
  print("删除成功：${bmobHandled.msg}");
}).catchError((e) {
  print("删除失败：${BmobError.convert(e).error}");
});
```

#### 删除字段值

```dart
Blog blog = Blog();
blog.objectId = currentObjectId;

blog.deleteFieldValue("content").then((BmobUpdated bmobUpdated) {
  print("删除字段成功：${bmobUpdated.updatedAt}");
}).catchError((e) {
  print("删除字段失败：${BmobError.convert(e).error}");
});
```

### 条件查询

```dart
BmobQuery<Blog> query = BmobQuery();

// 等于
query.addWhereEqualTo("title", "博客标题");

// 不等于
// query.addWhereNotEqualTo("title", "博客标题");

// 小于 / 小于等于
// query.addWhereLessThan("like", 80);
// query.addWhereLessThanOrEqualTo("like", 77);

// 大于 / 大于等于
// query.addWhereGreaterThan("like", 70);
// query.addWhereGreaterThanOrEqualTo("like", 77);

query.queryObjects().then((data) {
  List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
  for (Blog blog in blogs) {
    print("${blog.objectId} - ${blog.title}");
  }
}).catchError((e) {
  print("查询失败：${BmobError.convert(e).error}");
});
```

### 排序与分页

```dart
BmobQuery<Blog> query = BmobQuery();

// 排序：正序用字段名，逆序加 "-" 前缀
query.setOrder("-createdAt");

// 分页
query.setLimit(10);  // 返回条数
query.setSkip(10);   // 跳过条数

query.queryObjects().then((data) {
  List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
  // ...
}).catchError((e) {
  print(BmobError.convert(e).error);
});
```

### 统计查询

```dart
BmobQuery<Blog> query = BmobQuery();

// 分组
query.groupByKeys("title,content,like");

// 分组计数
// query.hasGroupCount(true);

// 求和 / 平均值 / 最大值 / 最小值
// query.sumKeys("like");
// query.averageKeys("like");
// query.maxKeys("like");
// query.minKeys("like");

// 分组过滤
// Map<String, dynamic> filter = {};
// filter["title"] = "博客标题";
// query.havingFilter(filter);

query.queryObjects().then((data) {
  // ...
}).catchError((e) {
  print(BmobError.convert(e).error);
});
```

### 个数查询

```dart
BmobQuery<Blog> query = BmobQuery();
query.queryCount().then((int count) {
  print("数据个数：$count");
}).catchError((e) {
  print(BmobError.convert(e).error);
});
```

### 复合查询

```dart
// 或查询
BmobQuery<Blog> query1 = BmobQuery();
query1.addWhereEqualTo("content", "内容");

BmobQuery<Blog> query2 = BmobQuery();
query2.addWhereEqualTo("title", "标题");

BmobQuery<Blog> query = BmobQuery();
query.or([query1, query2]);

// 与查询
// query.and([query1, query2]);

query.queryObjects().then((data) {
  List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
  // ...
}).catchError((e) {
  print(BmobError.convert(e).error);
});
```

### 关联操作（Pointer）

```dart
// 添加关联
Blog blog = Blog();
User user = User();
user.objectId = "4760e7a143";
blog.author = user;
blog.title = "添加关联关系";
blog.save().then((BmobSaved bmobSaved) {
  print("添加成功：${bmobSaved.objectId}");
}).catchError((e) {
  print(BmobError.convert(e).error);
});

// 查询关联（使用 setInclude 展开关联对象）
BmobQuery<Blog> query = BmobQuery();
query.setInclude("author");
query.queryObjects().then((data) {
  List<Blog> blogs = data.map((i) => Blog.fromJson(i)).toList();
  for (Blog blog in blogs) {
    if (blog.author != null) {
      print("${blog.title} - ${blog.author.username}");
    }
  }
}).catchError((e) {
  print(BmobError.convert(e).error);
});

// 解除关联
Blog blog = Blog();
blog.objectId = currentObjectId;
blog.deleteFieldValue("author").then((BmobUpdated bmobUpdated) {
  print("解除关联成功");
}).catchError((e) {
  print(BmobError.convert(e).error);
});

// 修改关联
Blog blog = Blog();
blog.objectId = currentObjectId;
User newUser = User();
newUser.objectId = "358f092cb1";
blog.author = newUser;
blog.update().then((BmobUpdated bmobUpdated) {
  print("修改关联成功");
}).catchError((e) {
  print(BmobError.convert(e).error);
});
```

### 位置操作

```dart
Blog blog = Blog();
BmobGeoPoint geoPoint = BmobGeoPoint();
geoPoint.latitude = 12.4445;
geoPoint.longitude = 124.122;
blog.addr = geoPoint;

blog.save().then((BmobSaved bmobSaved) {
  print("添加位置成功：${bmobSaved.objectId}");
}).catchError((e) {
  print(BmobError.convert(e).error);
});
```

### 时间操作

```dart
// 添加时间类型
BmobDate bmobDate = BmobDate();
bmobDate.setDate(DateTime.now());
Blog blog = Blog();
blog.time = bmobDate;
blog.save().then((BmobSaved bmobSaved) {
  print("添加时间成功：${bmobSaved.objectId}");
}).catchError((e) {
  print(BmobError.convert(e).error);
});

// 获取服务器时间
BmobDateManager.getServerTimestamp().then((ServerTime serverTime) {
  print("服务器时间：${serverTime.timestamp} - ${serverTime.datetime}");
}).catchError((e) {
  print(BmobError.convert(e).error);
});
```

### 文件操作

```dart
// 上传文件（Android 需先适配文件访问权限）
import 'dart:io';

File file = File(path);
BmobFileManager.upload(file).then((BmobFile bmobFile) {
  print("上传成功：${bmobFile.url} - ${bmobFile.filename}");
}).catchError((e) {
  print("上传失败：${BmobError.convert(e).error}");
});

// 将文件关联到数据表
Blog blog = Blog();
blog.pic = bmobFile;
blog.save().then((BmobSaved bmobSaved) {
  print("关联文件成功：${bmobSaved.objectId}");
}).catchError((e) {
  print(BmobError.convert(e).error);
});

// 删除文件
BmobFileManager.delete(fileUrl).then((BmobHandled bmobHandled) {
  print("删除成功：${bmobHandled.msg}");
}).catchError((e) {
  print(BmobError.convert(e).error);
});
```

### 用户操作

#### 注册与登录

```dart
// 注册
BmobUser user = BmobUser();
user.username = "username";
user.password = "password";
user.register().then((BmobRegistered data) {
  print("注册成功：${data.objectId}");
}).catchError((e) {
  print("注册失败：${BmobError.convert(e).error}");
});

// 用户名密码登录
BmobUser user = BmobUser();
user.username = "username";
user.password = "password";
user.login().then((BmobUser bmobUser) {
  print("登录成功：${bmobUser.objectId} - ${bmobUser.username}");
}).catchError((e) {
  print("登录失败：${BmobError.convert(e).error}");
});
```

#### 短信验证码登录

```dart
// 发送验证码
BmobSms bmobSms = BmobSms();
bmobSms.template = "";
bmobSms.mobilePhoneNumber = phoneNumber;
bmobSms.sendSms().then((BmobSent bmobSent) {
  print("发送成功：${bmobSent.smsId}");
}).catchError((e) {
  print(BmobError.convert(e).error);
});

// 验证码登录
BmobUser user = BmobUser();
user.mobilePhoneNumber = phoneNumber;
user.loginBySms(smsCode).then((BmobUser bmobUser) {
  print("登录成功：${bmobUser.objectId}");
}).catchError((e) {
  print(BmobError.convert(e).error);
});
```

#### 密码重置

```dart
// 短信验证码重置密码
BmobUser user = BmobUser();
user.mobilePhoneNumber = phoneNumber;
user.requestPasswordResetBySmsCode(smsCode).then((BmobHandled handled) {
  print("重置成功");
}).catchError((e) {
  print(BmobError.convert(e).error);
});

// 邮件重置密码
BmobUser user = BmobUser();
user.email = email;
user.requestPasswordResetByEmail().then((BmobHandled handled) {
  print("邮件已发送");
}).catchError((e) {
  print(BmobError.convert(e).error);
});
```

#### 邮箱验证

```dart
BmobUser.requestEmailVerify("email@example.com").then((BmobHandled handled) {
  print("验证邮件已发送");
}).catchError((e) {
  print(BmobError.convert(e).error);
});
```

#### 查询用户

```dart
// 查询单个用户
BmobQuery<User> query = BmobQuery();
query.queryUser(objectId).then((data) {
  User user = User.fromJson(data);
  print(user.username);
}).catchError((e) {
  print(BmobError.convert(e).error);
});

// 查询多个用户
BmobQuery<User> query = BmobQuery();
query.queryUsers().then((data) {
  List<User> users = data.map((i) => User.fromJson(i)).toList();
  // ...
}).catchError((e) {
  print(BmobError.convert(e).error);
});
```

### 角色操作

```dart
// 创建角色并添加用户
BmobRole bmobRole = BmobRole();
bmobRole.name = "teacher";

User user = User();
user.objectId = "f06590e3c2";

BmobRelation relation = BmobRelation();
relation.add(user);
bmobRole.setUsers(relation);

bmobRole.save().then((BmobSaved bmobSaved) {
  print("角色创建成功：${bmobSaved.objectId}");
}).catchError((e) {
  print(BmobError.convert(e).error);
});

// 向已有角色添加用户
BmobRelation newRelation = BmobRelation();
newRelation.add(newUser);
existingBmobRole.setUsers(newRelation);
existingBmobRole.update().then((BmobUpdated bmobUpdated) {
  print("添加用户成功");
}).catchError((e) {
  print(BmobError.convert(e).error);
});
```

### ACL 权限控制

```dart
// 设置公共读权限
Blog blog = Blog();
blog.title = "帖子标题";
blog.content = "帖子内容";

BmobAcl acl = BmobAcl();
acl.setPublicReadAccess(true);
blog.setAcl(acl);

blog.save().then((BmobSaved bmobSaved) {
  print("保存成功：${bmobSaved.objectId}");
}).catchError((e) {
  print(BmobError.convert(e).error);
});

// 设置指定用户权限
BmobAcl userAcl = BmobAcl();
userAcl.addRoleReadAccess(userObjectId, true);
blog.setAcl(userAcl);

// 设置指定角色权限
BmobAcl roleAcl = BmobAcl();
roleAcl.addRoleReadAccess("teacher", true);
blog.setAcl(roleAcl);
```

### 设备操作

```dart
// 获取设备 ID
String installationId = await BmobInstallationManager.getInstallationId();
print("设备ID：$installationId");

// 初始化设备信息
BmobInstallationManager.init().then((BmobInstallation installation) {
  print("初始化成功：${installation.toJson()}");
}).catchError((e) {
  print(BmobError.convert(e).error);
});

// 查询单个设备
BmobQuery<BmobInstallation> query = BmobQuery();
query.queryInstallation(objectId).then((data) {
  BmobInstallation installation = BmobInstallation.fromJson(data);
  print(installation.installationId);
}).catchError((e) {
  print(BmobError.convert(e).error);
});

// 查询多个设备
BmobQuery<BmobInstallation> query = BmobQuery();
query.queryInstallations().then((data) {
  List<BmobInstallation> list = data.map((i) => BmobInstallation.fromJson(i)).toList();
  // ...
}).catchError((e) {
  print(BmobError.convert(e).error);
});
```

### 短信操作

```dart
// 发送验证码
BmobSms bmobSms = BmobSms();
bmobSms.template = "";
bmobSms.mobilePhoneNumber = phoneNumber;
bmobSms.sendSms().then((BmobSent bmobSent) {
  print("发送成功：${bmobSent.smsId}");
}).catchError((e) {
  print(BmobError.convert(e).error);
});

// 验证验证码
BmobSms bmobSms = BmobSms();
bmobSms.mobilePhoneNumber = phoneNumber;
bmobSms.verifySmsCode(smsCode).then((BmobHandled handled) {
  print("验证成功：${handled.msg}");
}).catchError((e) {
  print(BmobError.convert(e).error);
});
```

### 实时数据监听

```dart
RealTimeDataManager.getInstance().listen(
  onConnected: (Client client) {
    print("连接成功，开始订阅消息");
    client.subTableUpdate("Blog");  // 订阅表更新
    // client.subTableDelete("Blog"); // 订阅表删除
    // client.subRowUpdate("Blog", objectId); // 订阅行更新
    // client.subRowDelete("Blog", objectId); // 订阅行删除
  },
  onDisconnected: () {
    print("连接断开");
  },
  onDataChanged: (Change data) {
    Map map = data.data;
    print("数据变化：$map");
  },
  onError: (error) {
    print("连接错误：$error");
  },
);
```

订阅方法说明：

| 方法 | 说明 |
| :--- | :--- |
| `subTableUpdate` | 订阅表更新 |
| `subTableDelete` | 订阅表删除 |
| `subRowUpdate` | 订阅行更新 |
| `subRowDelete` | 订阅行删除 |

### 批量操作

```dart
Blog blog1 = Blog()..content = "批量1";
Blog blog2 = Blog()..content = "批量2";
Blog blog3 = Blog()..content = "批量3";

List<BmobObject> objects = [blog1, blog2, blog3];

BmobBatch batch = BmobBatch();

// 批量添加
batch.insertBatch(objects).then((List list) {
  for (var item in list) {
    print(item);
  }
}).catchError((e) {
  print(e.toString());
});

// 批量修改：batch.updateBatch(objects)
// 批量删除：batch.deleteBatch(objects)
```

### 错误处理

所有 API 调用均通过 `catchError` 捕获异常，使用 `BmobError` 解析错误信息：

```dart
.catchError((e) {
  BmobError bmobError = BmobError.convert(e);
  print("错误码：${bmobError.code}");
  print("错误信息：${bmobError.error}");
});
```

## 项目结构

```
bmob-flutter-sdk/
├── data_plugin/              # 核心 SDK 插件包
│   └── lib/
│       ├── data_plugin.dart          # 插件入口（MethodChannel）
│       └── bmob/
│           ├── bmob.dart             # 核心配置（初始化、API 常量）
│           ├── bmob_dio.dart         # HTTP 封装（Dio 单例）
│           ├── bmob_query.dart       # 查询引擎
│           ├── bmob_batch.dart       # 批量操作
│           ├── bmob_file_manager.dart # 文件上传/删除
│           ├── bmob_sms.dart         # 短信验证码
│           ├── bmob_date_manager.dart # 服务器时间
│           ├── bmob_installation_manager.dart # 设备管理
│           ├── realtime/             # WebSocket 实时监听
│           ├── table/                # 数据表模型
│           │   ├── bmob_object.dart  #   抽象基类（CRUD）
│           │   ├── bmob_user.dart    #   用户模型
│           │   ├── bmob_installation.dart # 设备模型
│           │   └── bmob_role.dart    #   角色模型
│           ├── type/                 # 特殊数据类型
│           │   ├── bmob_acl.dart     #   访问控制
│           │   ├── bmob_date.dart    #   日期
│           │   ├── bmob_file.dart    #   文件
│           │   ├── bmob_geo_point.dart # 地理位置
│           │   ├── bmob_pointer.dart #   指针关联
│           │   └── bmob_relation.dart #  关系
│           └── response/             # API 响应模型
│               ├── bmob_error.dart   #   错误
│               ├── bmob_handled.dart #   通用操作
│               ├── bmob_saved.dart   #   保存成功
│               ├── bmob_updated.dart #   更新成功
│               ├── bmob_registered.dart # 注册成功
│               ├── bmob_results.dart #   查询结果集
│               └── bmob_sent.dart    #   短信发送
└── data_demo/                # 示例应用
    └── lib/
        ├── main.dart
        ├── bean/             # 数据模型示例
        └── page/             # 功能演示页面
```

## 相关链接

- **SDK 源码**：[GitHub - data_plugin](https://github.com/bmob/bmob-flutter-sdk/tree/master/data_plugin)
- **示例应用**：[GitHub - data_demo](https://github.com/bmob/bmob-flutter-sdk/tree/master/data_demo)
- **Bmob 官网**：[https://bmob.cn](https://bmob.cn)
- **Bmob 官方文档**：[https://bmob.cn/docs](https://bmob.cn/docs)

## 技术支持

- **QQ 交流群**：788254534
- **Issue 反馈**：[GitHub Issues](https://github.com/bmob/bmob-flutter-sdk/issues)

## License

MIT License
