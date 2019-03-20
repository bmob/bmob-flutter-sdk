import 'package:data/bmob/bmob_dio.dart';
import 'package:data/bmob/bmob.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:data/bmob/response/bmob_handled.dart';
import 'package:data/bmob/response/bmob_sent.dart';

//此处与类名一致，由指令自动生成代码
part 'bmob_sms.g.dart';

@JsonSerializable()
class BmobSms {
  String mobilePhoneNumber;
  String template;

  BmobSms();

  ///查询单条数据
  void sendSms({Function successListener, Function errorListener}) async {
    BmobDio.getInstance().post(Bmob.BMOB_API_SEND_SMS_CODE, data: toJson(),
        successCallback: (data) {
      BmobSent sent = BmobSent.fromJson(data);
      successListener(sent);
    }, errorCallback: (error) {
      errorListener(error);
    });
  }

  ///查询多条数据
  void verifySmsCode(smsCode,
      {Function successListener, Function errorListener}) async {
    Map data = toJson();
    data.remove("template");
    BmobDio.getInstance().post(Bmob.BMOB_API_VERIFY_SMS_CODE + smsCode,
        data: data, successCallback: (data) {
      BmobHandled bmobHandled = BmobHandled.fromJson(data);
      successListener(bmobHandled);
    }, errorCallback: (error) {
      errorListener(error);
    });
  }

  //此处与类名一致，由指令自动生成代码
  factory BmobSms.fromJson(Map<String, dynamic> json) =>
      _$BmobSmsFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$BmobSmsToJson(this);
}
