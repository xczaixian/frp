// dart不支持泛型。。给每一个请求warper一个外层结构

import 'package:chat_room/api/beans/auth_code.dart';
import 'package:chat_room/api/beans/login_bean.dart';
import 'package:json_annotation/json_annotation.dart';
part 'wrap_bean.g.dart';

@JsonSerializable()
class AuthCodeWrap {
  AuthCodeWrap(this.code, this.status, this.message, this.data, this.success);

  int code;
  int status;
  String message;
  bool success;

  AuthCodeBean data;

  factory AuthCodeWrap.fromJson(Map<String, dynamic> json) =>
      _$AuthCodeWrapFromJson(json);

  Map<String, dynamic> toJson() => _$AuthCodeWrapToJson(this);
}

@JsonSerializable()
class LoginBeanWrap {
  LoginBeanWrap(this.code, this.status, this.message, this.data, this.success);
  int code;
  int status;
  String message;
  bool success;

  LoginBean data;

  factory LoginBeanWrap.fromJson(Map<String, dynamic> json) =>
      _$LoginBeanWrapFromJson(json);

  Map<String, dynamic> toJson() => _$LoginBeanWrapToJson(this);
}
