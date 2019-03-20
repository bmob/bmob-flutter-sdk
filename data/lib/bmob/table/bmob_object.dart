import 'package:data/bmob/bmob_dio.dart';
import 'dart:convert';
import 'package:data/bmob/bmob.dart';
import 'package:data/bmob/response/bmob_saved.dart';
import 'package:data/bmob/response/bmob_error.dart';
import 'package:data/bmob/response/bmob_handled.dart';
import 'package:data/bmob/response/bmob_updated.dart';

///Bmob对象基本类型
abstract class BmobObject {
  //创建时间
  String createdAt;

  //更新时间
  String updatedAt;

  //唯一标志
  String objectId;

  BmobObject();

  Map getParams();

  ///新增一条数据
  void save({Function successListener, Function errorListener}) async {
    Map<String, dynamic> map = getParams();
    String params = getParamsJsonFromParamsMap(map);
    String tableName = getTableName(this);
    switch (tableName) {
      case "BmobInstallation":
        tableName = "_Installation";
        break;
    }
    BmobDio.getInstance().post(Bmob.BMOB_API_CLASSES + tableName, data: params,
        successCallback: (data) {
      BmobSaved bmobSaved = BmobSaved.fromJson(data);
      successListener(bmobSaved);
    }, errorCallback: (error) {
      errorListener(error);
    });
  }

  ///修改一条数据
  void update({Function successListener, Function errorListener}) async {
    Map<String, dynamic> map = getParams();
    String objectId = map[Bmob.BMOB_PROPERTY_OBJECT_ID];
    if (objectId.isEmpty || objectId == null) {
      BmobError bmobError =
          new BmobError(Bmob.BMOB_ERROR_CODE_LOCAL, Bmob.BMOB_ERROR_OBJECT_ID);
      errorListener(bmobError);
    } else {
      String params = getParamsJsonFromParamsMap(map);
      String tableName = getTableName(this);
      new BmobDio().put(
          Bmob.BMOB_API_CLASSES + tableName + Bmob.BMOB_API_SLASH + objectId,
          data: params, successCallback: (data) {
        BmobUpdated bmobUpdated = BmobUpdated.fromJson(data);
        successListener(bmobUpdated);
      }, errorCallback: (error) {
        errorListener(error);
      });
    }
  }

  ///删除一条数据
  void delete({Function successListener, Function errorListener}) async {
    Map<String, dynamic> map = getParams();
    String objectId = map[Bmob.BMOB_PROPERTY_OBJECT_ID];
    if (objectId.isEmpty || objectId == null) {
      BmobError bmobError =
          new BmobError(Bmob.BMOB_ERROR_CODE_LOCAL, Bmob.BMOB_ERROR_OBJECT_ID);
      errorListener(bmobError);
    } else {
      String tableName = getTableName(this);
      new BmobDio().delete(
          Bmob.BMOB_API_CLASSES + tableName + Bmob.BMOB_API_SLASH + objectId,
          successCallback: (data) {
        BmobHandled bmobHandled = BmobHandled.fromJson(data);
        successListener(bmobHandled);
      }, errorCallback: (error) {
        errorListener(error);
      });
    }
  }

  ///获取请求参数，去掉服务器生成的字段值，将对象类型修改成pointer结构，去掉空值
  String getParamsJsonFromParamsMap(map) {
    Map<String, dynamic> data = new Map();
    //去除由服务器生成的字段值
    map.remove(Bmob.BMOB_PROPERTY_OBJECT_ID);
    map.remove(Bmob.BMOB_PROPERTY_CREATED_AT);
    map.remove(Bmob.BMOB_PROPERTY_UPDATED_AT);
    map.remove(Bmob.BMOB_PROPERTY_SESSION_TOKEN);

    map.forEach((key, value) {
      //去除空值
      if (value != null) {
        if (value is BmobObject) {
          //Pointer类型
          BmobObject bmobObject = value;
          String objectId = bmobObject.objectId;
          if (objectId == null) {
            data.remove(key);
          } else {
            Map pointer = new Map();
            pointer[Bmob.BMOB_PROPERTY_OBJECT_ID] = objectId;
            pointer[Bmob.BMOB_KEY_TYPE] = Bmob.BMOB_TYPE_POINTER;
            pointer[Bmob.BMOB_KEY_CLASS_NAME] = getTableName(value);
            data[key] = pointer;
          }
        } else {
          //非Pointer类型
          data[key] = value;
        }
      }
    });
    //dart:convert，Map转String
    String params = json.encode(data);
    return params;
  }

  ///获取对象的类名
  String getTableName(object) {
    String className = object.runtimeType.toString();
    String tableName;
    if (className == Bmob.BMOB_CLASS_BMOB_USER) {
      //_User
      tableName = Bmob.BMOB_TABLE_USER;
    } else if (tableName == Bmob.BMOB_CLASS_BMOB_INSTALLATION) {
      tableName = Bmob.BMOB_TABLE_INSTALLATION;
    } else {
      tableName = className;
    }
    return tableName;
  }
}
