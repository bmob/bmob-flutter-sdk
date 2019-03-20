// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Blog _$BlogFromJson(Map<String, dynamic> json) {
  return Blog()
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..objectId = json['objectId'] as String
    ..title = json['title'] as String
    ..content = json['content'] as String
    ..author = json['author'] == null
        ? null
        : BmobUser.fromJson(json['author'] as Map<String, dynamic>)
    ..like = json['like'] as int;
}

Map<String, dynamic> _$BlogToJson(Blog instance) => <String, dynamic>{
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'objectId': instance.objectId,
      'title': instance.title,
      'content': instance.content,
      'author': instance.author,
      'like': instance.like
    };
