// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Blog _$BlogFromJson(Map<String, dynamic> json) {
  return Blog()
    ..createdAt = json['createdAt'] as String?
    ..updatedAt = json['updatedAt'] as String?
    ..objectId = json['objectId'] as String?
    ..ACL = (json['ACL'] as Map<String, dynamic>?) as Map<String, Object>?
    ..title = json['title'] as String?
    ..content = json['content'] as String?
    ..author = json['author'] == null
        ? null
        : BmobUser.fromJson(json['author'] as Map<String, dynamic>)
    ..like = json['like'] as int?
    ..addr = json['addr'] == null
        ? null
        : BmobGeoPoint.fromJson(json['addr'] as Map<String, dynamic>)
    ..time = json['time'] == null
        ? null
        : BmobDate.fromJson(json['time'] as Map<String, dynamic>)
    ..pic = json['pic'] == null
        ? null
        : BmobFile.fromJson(json['pic'] as Map<String, dynamic>);
}

Map<String, dynamic> _$BlogToJson(Blog instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'objectId': instance.objectId,
      'ACL': instance.ACL,
      'title': instance.title,
      'content': instance.content,
      'author': instance.author,
      'like': instance.like,
      'addr': instance.addr,
      'time': instance.time,
      'pic': instance.pic
    };
