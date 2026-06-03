# AGENTS.md

## Project overview

Bmob Flutter SDK — Bmob 后端即服务（BaaS）平台的 Flutter 客户端 SDK，通过 REST API 封装数据存储、用户管理、文件操作、短信验证、实时数据监听等功能。

- `data_plugin/` — 核心 SDK 插件包（v0.0.19），提供所有 Bmob 数据服务的 Dart 封装
- `data_demo/` — 示例 Flutter 应用（v0.0.11），演示 SDK 各功能模块用法
- Dart SDK: `>=2.12.0 <3.0.0`（null safety）

## Build and test commands

```bash
# 安装依赖
cd data_plugin && flutter pub get
cd ../data_demo && flutter pub get

# 代码生成（修改 json_serializable 模型后必须执行）
cd data_plugin && flutter pub run build_runner build

# 持续监听代码生成
cd data_plugin && flutter pub run build_runner watch

# 运行示例应用
cd data_demo && flutter run

# 运行测试
cd data_demo && flutter test
```

## Code style guidelines

- 语言：Dart，启用 null safety
- 数据模型继承体系：自定义模型继承 `BmobObject`，用户模型继承 `BmobUser`
- 抽象方法：所有 `BmobObject` 子类必须实现 `getParams()` 返回字段 Map
- JSON 序列化：使用 `json_serializable`，需添加 `@JsonSerializable()` 注解和 `part 'filename.g.dart';` 声明
- 代码生成文件（`.g.dart`）不要手动编辑，通过 `build_runner` 生成
- API 路径常量统一定义在 `Bmob` 类（`bmob.dart`）中，前缀 `BMOB_API_`
- 网络请求统一通过 `BmobDio.getInstance()` 单例发起，不要直接使用 Dio

## Project structure

```
data_plugin/lib/
├── data_plugin.dart                       # 插件入口（MethodChannel）
├── bmob/
│   ├── bmob.dart                          # 核心配置（初始化、API 常量）
│   ├── bmob_dio.dart                      # HTTP 封装（Dio 单例）
│   ├── bmob_query.dart                    # 查询引擎
│   ├── bmob_batch.dart                    # 批量操作
│   ├── bmob_file_manager.dart             # 文件上传/删除
│   ├── bmob_sms.dart                      # 短信验证码
│   ├── bmob_date_manager.dart             # 服务器时间
│   ├── bmob_installation_manager.dart     # 设备管理
│   ├── bmob_utils.dart                    # 工具（表名映射）
│   ├── realtime/                          # WebSocket 实时监听
│   ├── table/                             # 数据表模型
│   │   ├── bmob_object.dart               #   抽象基类（CRUD）
│   │   ├── bmob_user.dart                 #   用户模型
│   │   ├── bmob_installation.dart         #   设备模型
│   │   └── bmob_role.dart                 #   角色模型
│   ├── type/                              # 特殊数据类型
│   │   ├── bmob_acl.dart                  #   访问控制
│   │   ├── bmob_date.dart                 #   日期
│   │   ├── bmob_file.dart                 #   文件
│   │   ├── bmob_geo_point.dart            #   地理位置
│   │   ├── bmob_pointer.dart              #   指针关联
│   │   └── bmob_relation.dart             #   关系
│   └── response/                          # API 响应模型
│       ├── bmob_error.dart                #   错误
│       ├── bmob_handled.dart              #   通用操作
│       ├── bmob_saved.dart                #   保存成功
│       ├── bmob_updated.dart              #   更新成功
│       ├── bmob_registered.dart           #   注册成功
│       ├── bmob_results.dart              #   查询结果集
│       └── bmob_sent.dart                 #   短信发送
└── utils/
    ├── dialog_util.dart
    └── file_picker.dart

data_demo/lib/
├── main.dart
├── bean/                                  # 数据模型示例
└── page/                                  # 功能演示页面
    ├── object_page.dart                   #   CRUD
    ├── list_page.dart                     #   列表查询
    ├── file_page.dart                     #   文件操作
    ├── sms_page.dart                      #   短信
    ├── real_time_page.dart                #   实时监听
    ├── acl_page.dart                      #   ACL 权限
    ├── geo_point_page.dart                #   地理位置
    ├── pointer_page.dart                  #   指针关联
    ├── query/                             #   查询演示
    └── user/                              #   用户演示
```

## Dev environment tips

- `data_demo` 通过 `path: ../data_plugin` 本地引用 SDK，修改 SDK 源码直接生效
- 文件上传使用 v2 API（`/2/files`），其他操作使用 v1 API（`/1/`）
- `BmobInstallation` 相关功能目前仅适配 Android 平台
- `BmobUtils.getTableName()` 负责类名到表名映射：`BmobUser`→`_User`，`BmobInstallation`→`_Installation`，`BmobRole`→`_Role`

## Architecture

- **通信层**: `BmobDio`（Dio 单例），支持普通/加密/MasterKey 三种认证方式
- **模型层**: `BmobObject` 抽象基类提供 `save()`/`update()`/`delete()`；子类实现 `getParams()`
- **查询层**: `BmobQuery` 链式条件查询、统计、分页
- **实时层**: `RealTimeDataManager` + WebSocket（`web_socket_channel`）
- **序列化**: `getParamsJsonFromParamsMap()` 自动处理 Pointer/GeoPoint/Date/File/Relation 类型转换，移除服务端生成字段（objectId/createdAt/updatedAt/sessionToken）

## Security considerations

- `Bmob.bmobAppId`、`Bmob.bmobRestApiKey`、`Bmob.bmobMasterKey`、`Bmob.bmobSecretKey` 为敏感信息，不得泄漏或提交至公开仓库
- 加密模式签名算法：`MD5(path + timestamp + apiSafe + noncestr + body + sdkVersion)`
- 用户会话通过 `X-Bmob-Session-Token` Header 传递，登录后自动设置

## How to add new features

### 新增数据模型

1. 在 `data_plugin/lib/bmob/table/` 创建类，继承 `BmobObject`
2. 实现 `getParams()` 返回字段 Map
3. 需 JSON 序列化时：加 `@JsonSerializable()` + `part 'xxx.g.dart';`，运行 `build_runner`

### 新增 API 功能

1. 路径常量加到 `Bmob` 类（`BMOB_API_` 前缀）
2. 在对应 Manager 或 Table 类添加方法
3. 通过 `BmobDio.getInstance()` 发起请求
4. 在 `data_plugin/lib/bmob/response/` 添加响应模型
5. 在 `data_demo/lib/page/` 添加演示页面

### 新增响应类型

1. 在 `data_plugin/lib/bmob/response/` 创建类
2. 实现 `fromJson` 工厂构造函数
3. 使用 `json_serializable` 时运行 `build_runner`
