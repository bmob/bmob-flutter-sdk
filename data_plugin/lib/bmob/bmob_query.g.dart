// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bmob_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BmobQuery<T> _$BmobQueryFromJson<T>(Map<String, dynamic> json) {
  return BmobQuery<T>()
    ..include = json['include'] as String
    ..limit = json['limit'] as int
    ..skip = json['skip'] as int
    ..order = json['order'] as String
    ..where = json['where'] as Map<String, dynamic>;
}

Map<String, dynamic> _$BmobQueryToJson<T>(BmobQuery<T> instance) =>
    <String, dynamic>{
      'include': instance.include,
      'limit': instance.limit,
      'skip': instance.skip,
      'order': instance.order,
      'where': instance.where
    };
