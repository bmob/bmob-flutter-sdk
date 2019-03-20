import 'package:flutter/services.dart';

///TODO invokeMethod的返回值：Future<dynamic>；若无需返回值，则调用可不用await，且调用所在的方法可不用async和Future<dynamic>；若需要，则要用await、async和Future<dynamic>。
class BmobPlugin {
  static MethodChannel methodChannel = MethodChannel("bmob.plugin");
  static const String TAG = "BmobPlugin:";

  //TODO 获取android installationId
  static Future<String> getInstallationId() async {
    var installationId = await methodChannel.invokeMethod('getInstallationId');
    print(TAG + installationId);
    return installationId;
  }

  //TODO 弹出toast
  static toast(String msg) {
    print(TAG + msg);
    Map<String, dynamic> args = {
      "msg": msg,
    };
    methodChannel.invokeMethod('showToast', args);
  }
}
