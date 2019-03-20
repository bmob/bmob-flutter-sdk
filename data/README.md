# data

A new Flutter application.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).



# 增删改查一条数据

```dart
      BmobUser bmobUser = BmobUser();
      bmobUser.objectId = "7c7fd3afe1";
      Blog blog = Blog();
      blog.title = "博客标题";
      blog.content = "博客内容";
      blog.author = bmobUser;
      blog.save(successListener: (BmobSaved data) {
        print("创建一条数据成功：" + data.objectId+"-"+data.createdAt);
      }, errorListener: (BmobError bmobError) {
        print("创建一条数据失败：" + bmobError.error);
      });

      BmobUser bmobUserRegister = BmobUser();
      bmobUserRegister.username = DateTime.now().toIso8601String();
      bmobUserRegister.password = "123456";
      bmobUserRegister.register(successListener: (BmobRegistered data) {
        print("用户注册成功：" + data.objectId);
      }, errorListener: (BmobError bmobError) {
        print("用户注册失败：" + bmobError.error);
      });
```