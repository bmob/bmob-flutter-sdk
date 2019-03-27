import 'dart:io';
import 'bmob_dio.dart';
import 'bmob.dart';
import 'package:data_plugin/bmob/response/bmob_handled.dart';

import 'package:data_plugin/bmob/type/bmob_file.dart';
import 'package:data_plugin/bmob/response/bmob_error.dart';

class BmobFileManager {
  ///method:POST
  ///body:文本或者二进制流
  ///Content-Type:不同类型文件使用不同的值
  static void upload(File file, {successListener, errorListener}) async {
    String allPath = file.path;
    int indexSlash = allPath.lastIndexOf("/");
    if (file == null) {
      errorListener(BmobError(9016, "The file is null."));
      return;
    }
    if (indexSlash == -1) {
      errorListener(BmobError(9016, "The file's path is available."));
      return;
    }
    String fileName = allPath.substring(indexSlash, allPath.length);
    int indexPoint = fileName.indexOf(".");
    bool one = indexPoint < fileName.length - 1;
    bool two = fileName.contains(".");
    bool hasSuffix = one && two;
    if (!hasSuffix) {
      errorListener(BmobError(9016, "The file has no suffix."));
      return;
    }

    String path = "${Bmob.BMOB_API_FILE_VERSION}${Bmob.BMOB_API_FILE}$fileName";

    //获取所上传文件的二进制流
    List<int> bytes = await file.readAsBytes();

    BmobDio.getInstance().post(path, data: bytes, successCallback: (data) {
      BmobFile bmobFile = BmobFile.fromJson(data);
      successListener(bmobFile);
    }, errorCallback: (error) {
      errorListener(error);
    });
  }

  ///method:delete
  ///http://bmob-cdn-18925.b0.upaiyun.com/2019/03/25/f425482f73e646a6a425d746764c3b6c.jpg
  static void delete(String url,
      {Function successListener, Function errorListener}) {
    if (url == null || url.isEmpty) {
      errorListener("The url is null or empty.");
      return;
    }

    String domain = "upaiyun.com";
    int indexDomain = url.indexOf(domain);
    print(indexDomain);
    if (indexDomain == -1) {
      errorListener("The url is not a upaiyun's url.");
      return;
    }
    int indexHead = indexDomain + domain.length;
    int indexTail = url.length;
    String fileUrl = url.substring(indexHead, indexTail);
    String path =
        "${Bmob.BMOB_API_FILE_VERSION}${Bmob.BMOB_API_FILE}/upyun$fileUrl";

    BmobDio.getInstance().delete(path, successCallback: (data) {
      BmobHandled bmobHandled = BmobHandled.fromJson(data);
      successListener(bmobHandled);
    }, errorCallback: (BmobError error) {
      errorListener(error);
    });
  }
}
