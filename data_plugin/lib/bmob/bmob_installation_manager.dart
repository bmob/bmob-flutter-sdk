import 'package:data_plugin/bmob/bmob_query.dart';
import 'package:data_plugin/bmob/table/bmob_installation.dart';
import 'package:data_plugin/data_plugin.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';
import 'package:data_plugin/bmob/response/bmob_saved.dart';

class BmobInstallationManager {
  //TODO 获取android installationId
  static Future<String> getInstallationId() async {
    var installationId = await DataPlugin.installationId;
    return installationId;
  }

  //TODO 初始化设备信息
  static Future init({Function successCallback, Function errorCallback}) async {
    String installationId = await getInstallationId();
    print("init " + installationId);
    BmobQuery<BmobInstallation> bmobQuery = BmobQuery();
    bmobQuery.addWhereEqualTo("installationId", installationId);
    bmobQuery.queryObjects(successListener: (List<dynamic> data) {
      List<BmobInstallation> installations =
          data.map((i) => BmobInstallation.fromJson(i)).toList();

      if (installations.isNotEmpty) {
        BmobInstallation installation = installations[0];
        print(installation.installationId);
        successCallback(installation);
      } else {
        BmobInstallation bmobInstallation = BmobInstallation();
        bmobInstallation.installationId = installationId;
        bmobInstallation.save(successListener: (BmobSaved data) {
          print(data.toJson());
          successCallback(bmobInstallation);
        }, errorListener: (BmobError error) {
          print(error.toJson());
          errorCallback(error);
        });
      }
    }, errorListener: (BmobError error) {
      print(error.error);
      errorCallback(error);
    });
  }
}
