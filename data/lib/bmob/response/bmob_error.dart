import 'package:json_annotation/json_annotation.dart';

//此处与类名一致，由指令自动生成代码
part 'bmob_error.g.dart';

@JsonSerializable()
class BmobError extends Error {
  int code;
  String error;

  BmobError(this.code, this.error);

  //此处与类名一致，由指令自动生成代码
  factory BmobError.fromJson(Map<String, dynamic> json) =>
      _$BmobErrorFromJson(json);

  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$BmobErrorToJson(this);

  String toString() => "BmobError [$code]:" + error;
}
