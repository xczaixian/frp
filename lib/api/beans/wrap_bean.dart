// dart不支持泛型。。给每一个请求warper一个外层结构

import 'package:chat_room/api/beans/auth_code.dart';
import 'package:chat_room/api/beans/login_bean.dart';
import 'package:chat_room/api/beans/room_bean.dart';
import 'package:json_annotation/json_annotation.dart';
part 'wrap_bean.g.dart';

@JsonSerializable()
class BaseBean {
  BaseBean(this.code, this.status, this.message, this.success);

  int code;
  int status;
  String message;
  bool success;

  factory BaseBean.fromJson(Map<String, dynamic> json) =>
      _$BaseBeanFromJson(json);
  Map<String, dynamic> toJson() => _$BaseBeanToJson(this);
}

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

@JsonSerializable()
class RoomBeanWrap {
  int code;
  int status;
  String message;
  bool success;
  ListRoomBean data;

  RoomBeanWrap(this.code, this.status, this.message, this.success, this.data);

  factory RoomBeanWrap.fromJson(Map<String, dynamic> json) =>
      _$RoomBeanWrapFromJson(json);

  Map<String, dynamic> toJson() => _$RoomBeanWrapToJson(this);
}

@JsonSerializable()
class ListRoomBean {
  ListRoomBean(this.channels, this.total_size);

  List<ChannelListSimpleBean> channels;
  int total_size;

  factory ListRoomBean.fromJson(Map<String, dynamic> json) =>
      _$ListRoomBeanFromJson(json);

  Map<String, dynamic> toJson() => _$ListRoomBeanToJson(this);
}

@JsonSerializable()
class ChannelListSimpleBean {
  String channel_name;
  int user_count;

  ChannelListSimpleBean(this.channel_name, this.user_count);

  factory ChannelListSimpleBean.fromJson(Map<String, dynamic> json) =>
      _$ChannelListSimpleBeanFromJson(json);

  Map<String, dynamic> toJson() => _$ChannelListSimpleBeanToJson(this);
}

@JsonSerializable()
class AgoraTokenWarpBean {
  int code;
  int status;
  String message;
  bool success;
  AgoraTokenBean data;

  AgoraTokenWarpBean(
      this.code, this.status, this.message, this.success, this.data);
  factory AgoraTokenWarpBean.fromJson(Map<String, dynamic> json) =>
      _$AgoraTokenWarpBeanFromJson(json);

  Map<String, dynamic> toJson() => _$AgoraTokenWarpBeanToJson(this);
}

@JsonSerializable()
class AgoraTokenBean {
  String token;

  AgoraTokenBean(this.token);
  factory AgoraTokenBean.fromJson(Map<String, dynamic> json) =>
      _$AgoraTokenBeanFromJson(json);

  Map<String, dynamic> toJson() => _$AgoraTokenBeanToJson(this);
}
