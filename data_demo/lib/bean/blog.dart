import 'package:json_annotation/json_annotation.dart';

import 'package:data_plugin/bmob/table/bmob_object.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';

import 'package:data_plugin/bmob/type/bmob_geo_point.dart';
import 'package:data_plugin/bmob/type/bmob_date.dart';
import 'package:data_plugin/bmob/type/bmob_file.dart';
//此处与类名一致，由指令自动生成代码
part 'blog.g.dart';



@JsonSerializable()
class Blog extends BmobObject{



  //博客标题
  String title;
  //博客内容
  String content;
  //博客作者
  BmobUser author;

  int like;


  BmobGeoPoint addr;


  BmobDate time;



  BmobFile pic;




  Blog();

  //此处与类名一致，由指令自动生成代码
  factory Blog.fromJson(Map<String, dynamic> json) =>
      _$BlogFromJson(json);



  //此处与类名一致，由指令自动生成代码
  Map<String, dynamic> toJson() => _$BlogToJson(this);

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson();
  }







}