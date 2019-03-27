import 'bmob_dio.dart';
import 'bmob.dart';
import 'package:data_plugin/bmob/response/server_time.dart';

class BmobDateManager {
  ///查询服务器时间
  static void getServerTimestamp(
      {Function successListener, Function errorListener}) async {
    BmobDio.getInstance().get(Bmob.BMOB_API_VERSION + Bmob.BMOB_API_TIMESTAMP,
        successCallback: (data) {
      ServerTime serverTime = ServerTime.fromJson(data);
      successListener(serverTime);
    }, errorCallback: (error) {
      errorListener(error);
    });
  }
}
