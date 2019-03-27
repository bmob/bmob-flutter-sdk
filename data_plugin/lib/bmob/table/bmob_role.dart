library bmobrole;

import 'package:json_annotation/json_annotation.dart';

import 'package:data_plugin/bmob/table/bmob_object.dart';

import 'package:data_plugin/bmob/type/bmob_relation.dart';

import 'dart:convert';

import 'package:data_plugin/bmob/type/bmob_pointer.dart';

part 'bmob_role.g.dart';

@JsonSerializable()
class BmobRole extends BmobObject {
  factory BmobRole.fromJson(Map<String, dynamic> json) =>
      _$BmobRoleFromJson(json);

  Map<String, dynamic> toJson(BmobRole instance) => _$BmobRoleToJson(instance);

  String name;
  Map<String, dynamic> roles;
  Map<String, dynamic> users;

  BmobRole() {
    roles = Map();
    users = Map();
  }

  @override
  Map getParams() {
    // TODO: implement getParams
    return toJson(this);
  }

  void setRoles(BmobRelation bmobRelation) {
    roles =bmobRelation.toJson();
  }

  void setUsers(BmobRelation bmobRelation) {
    roles =bmobRelation.toJson();
  }
}
