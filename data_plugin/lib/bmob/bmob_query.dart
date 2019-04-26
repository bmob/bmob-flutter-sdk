import 'package:data_plugin/bmob/bmob_dio.dart';
import 'package:data_plugin/bmob/response/bmob_results.dart';
import 'package:dio/dio.dart';

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:data_plugin/bmob/bmob.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:data_plugin/bmob/type/bmob_pointer.dart';

//此处与类名一致，由指令自动生成代码
part 'bmob_query.g.dart';

///查询数据，包括单条数据查询和多条数据查询
@JsonSerializable()
class BmobQuery<T> {
  String include;
  int limit;
  int skip;
  String order;

  Map<String, dynamic> where;

  BmobQuery() {
    where = Map();
  }

  //添加等于条件查询
  BmobQuery addWhereEqualTo(String key, Object value) {
    addCondition(key, null, value);
    return this;
  }

  //添加不等于查询
  BmobQuery addWhereNotEqualTo(String key, Object value) {
    addCondition(key, "\$ne", value);
    return this;
  }

  //添加小于查询
  BmobQuery addWhereLessThan(String key, Object value) {
    addCondition(key, "\$lt", value);
    return this;
  }

  //添加小于等于查询
  BmobQuery addWhereLessThanOrEqualTo(String key, Object value) {
    addCondition(key, "\$lte", value);
    return this;
  }

  //添加大于查询
  BmobQuery addWhereGreaterThan(String key, Object value) {
    addCondition(key, "\$gt", value);
    return this;
  }

  //添加大于等于查询
  BmobQuery addWhereGreaterThanOrEqualTo(String key, Object value) {
    addCondition(key, "\$gte", value);
    return this;
  }

  void addCondition(String key, String condition, Object value) {
    if (condition == null) {
      if (value is BmobUser) {
        BmobUser bmobUser = value;
        Map<String, dynamic> map = new Map();
        map["__type"] = "Pointer";
        map["objectId"] = bmobUser.objectId;
        map["className"] = "_User";
        where[key] = map;
      } else if (value is BmobObject) {
        BmobObject bmobObject = value;
        Map<String, dynamic> map = new Map();
        map["__type"] = "Pointer";
        map["objectId"] = bmobObject.objectId;
        map["className"] = value.runtimeType.toString();
        where[key] = map;
      } else if (value is BmobPointer) {
        Map<String, dynamic> map = new Map();
        map["object"] = value;
        where[key] = map;
      } else {
        where[key] = value;
      }
    } else {
      if (value is BmobUser) {
        BmobUser bmobUser = value;
        Map<String, dynamic> map = new Map();
        map["__type"] = "Pointer";
        map["objectId"] = bmobUser.objectId;
        map["className"] = "_User";

        Map<String, dynamic> map1 = new Map();
        map1[condition] = map;
        where[key] = map1;
      } else if (value is BmobObject) {
        BmobObject bmobObject = value;
        Map<String, dynamic> map = new Map();
        map["__type"] = "Pointer";
        map["objectId"] = bmobObject.objectId;
        map["className"] = value.runtimeType.toString();

        Map<String, dynamic> map1 = new Map();
        map1[condition] = map;
        where[key] = map1;
      } else {
        Map<String, dynamic> map = new Map();
        map[condition] = value;
        where[key] = map;
      }
    }
  }

  //查询关联字段
  BmobQuery setInclude(String value) {
    include = value;
    return this;
  }

  //按字段排序
  BmobQuery setOrder(String value) {
    order = value;
    return this;
  }

  //返回条数
  BmobQuery setLimit(int value) {
    limit = value;
    return this;
  }

  //忽略条数
  BmobQuery setSkip(int value) {
    skip = value;
    return this;
  }

  ///查询单条数据
  Future<dynamic> queryObject(objectId) async {
    String tableName = T.toString();
    switch (tableName) {
      case "BmobInstallation":
        tableName = "_Installation";
        break;
    }
    return BmobDio.getInstance().get(
        Bmob.BMOB_API_CLASSES + tableName + Bmob.BMOB_API_SLASH + objectId,
        data: getParams());
  }

  ///查询多条数据
  Future<List<dynamic>> queryObjects() async {
    String tableName = T.toString();
    switch (tableName) {
      case "BmobInstallation":
        tableName = "_Installation";
        break;
    }
    String url = Bmob.BMOB_API_CLASSES + tableName;
    if (where.isNotEmpty) {
      url = url + "?where=" + json.encode(where);
    }
    Map map = await BmobDio.getInstance().get(url, data: getParams());
    BmobResults bmobResults = BmobResults.fromJson(map);
    print(bmobResults.results);
    return bmobResults.results;
  }

  ///此处与类名一致，由指令自动生成代码
  factory BmobQuery.fromJson(Map<String, dynamic> json) =>
      _$BmobQueryFromJson(json);

  ///此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$BmobQueryToJson(this);

  ///获取请求参数
  Map getParams() {
    Map map = toJson();
    Map params = toJson();
    map.forEach((k, v) {
      if (v == null) {
        params.remove(k);
      }
    });
    return params;
  }
}
