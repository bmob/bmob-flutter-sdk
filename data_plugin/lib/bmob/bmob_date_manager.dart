import 'bmob_dio.dart';
import 'bmob.dart';
import 'package:data_plugin/bmob/response/server_time.dart';

class BmobDateManager {
  ///查询服务器时间
  static Future<ServerTime> getServerTimestamp() async {
    Map data = await BmobDio.getInstance()
        .get(Bmob.BMOB_API_VERSION + Bmob.BMOB_API_TIMESTAMP);
    ServerTime serverTime = ServerTime.fromJson(data);
    return serverTime;
  }
}
