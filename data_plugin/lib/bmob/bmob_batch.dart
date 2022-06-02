import 'dart:convert';

import 'package:data_plugin/bmob/bmob.dart';
import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bmob_dio.dart';

class BmobBatch {
  Future<List> insertBatch(List<BmobObject> bmobObjects) async {
    return process("POST", bmobObjects);
  }

  Future<List> deleteBatch(List<BmobObject> bmobObjects) async {
    return process("DELETE", bmobObjects);
  }

  Future<List> updateBatch(List<BmobObject> bmobObjects) async {
    return process("PUT", bmobObjects);
  }

  Future<List> process(String method, List<BmobObject> bmobObjects) async {
    List list = List.empty(growable: true);
    Map params = Map();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.get("user") as String?;
    print(userJson);
    BmobUser? bmobUser;
    if (userJson != null) {
      bmobUser = json.decode(userJson);
    }

    for (BmobObject bmobObject in bmobObjects) {
      if (bmobObject is BmobUser) {
        //过滤BmobUser类型的处理，因为批处理操作不支持对User表的操作
        print("BmobUser does not support batch operations");
      } else {
        Map single = Map();
        single["method"] = method;
        if (method == "PUT" || method == "DELETE") {
          //批量更新和批量删除
          if (userJson != null) {
            single["token"] = bmobUser!.sessionToken;
          }
          single["path"] = Bmob.BMOB_API_CLASSES +
              bmobObject.runtimeType.toString() +
              "/" +
              bmobObject.objectId!;
        } else {
          //批量添加
          single["path"] =
              Bmob.BMOB_API_CLASSES + bmobObject.runtimeType.toString();
        }

        Map body = bmobObject.getParams();
        Map tmp = bmobObject.getParams();
        tmp.forEach((key, value) {
          if (value == null) {
            body.remove(key);
          }
        });
        single["body"] = body;

        body.remove("objectId");
        body.remove("createdAt");
        body.remove("updatedAt");

        list.add(single);
      }
    }
    params["requests"] = list;
    print(params.toString());

    List responseData =
        await BmobDio.getInstance().post(Bmob.BMOB_API_BATCH, data: params);

    print(responseData.toString());

    return list;
  }
}
