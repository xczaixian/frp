// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrap_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseBean _$BaseBeanFromJson(Map<String, dynamic> json) => BaseBean(
      json['code'] as int,
      json['status'] as int,
      json['message'] as String,
      json['success'] as bool,
    );

Map<String, dynamic> _$BaseBeanToJson(BaseBean instance) => <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'message': instance.message,
      'success': instance.success,
    };

AuthCodeWrap _$AuthCodeWrapFromJson(Map<String, dynamic> json) => AuthCodeWrap(
      json['code'] as int,
      json['status'] as int,
      json['message'] as String,
      AuthCodeBean.fromJson(json['data'] as Map<String, dynamic>),
      json['success'] as bool,
    );

Map<String, dynamic> _$AuthCodeWrapToJson(AuthCodeWrap instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };

LoginBeanWrap _$LoginBeanWrapFromJson(Map<String, dynamic> json) =>
    LoginBeanWrap(
      json['code'] as int,
      json['status'] as int,
      json['message'] as String,
      LoginBean.fromJson(json['data'] as Map<String, dynamic>),
      json['success'] as bool,
    );

Map<String, dynamic> _$LoginBeanWrapToJson(LoginBeanWrap instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };

RoomBeanWrap _$RoomBeanWrapFromJson(Map<String, dynamic> json) => RoomBeanWrap(
      json['code'] as int,
      json['status'] as int,
      json['message'] as String,
      json['success'] as bool,
      ListRoomBean.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RoomBeanWrapToJson(RoomBeanWrap instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };

ListRoomBean _$ListRoomBeanFromJson(Map<String, dynamic> json) => ListRoomBean(
      (json['channels'] as List<dynamic>)
          .map((e) => RoomBean.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['total_size'] as int,
    );

Map<String, dynamic> _$ListRoomBeanToJson(ListRoomBean instance) =>
    <String, dynamic>{
      'channels': instance.channels,
      'total_size': instance.total_size,
    };

AgoraTokenWarpBean _$AgoraTokenWarpBeanFromJson(Map<String, dynamic> json) =>
    AgoraTokenWarpBean(
      json['code'] as int,
      json['status'] as int,
      json['message'] as String,
      json['success'] as bool,
      AgoraTokenBean.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AgoraTokenWarpBeanToJson(AgoraTokenWarpBean instance) =>
    <String, dynamic>{
      'code': instance.code,
      'status': instance.status,
      'message': instance.message,
      'success': instance.success,
      'data': instance.data,
    };

AgoraTokenBean _$AgoraTokenBeanFromJson(Map<String, dynamic> json) =>
    AgoraTokenBean(
      json['token'] as String,
    );

Map<String, dynamic> _$AgoraTokenBeanToJson(AgoraTokenBean instance) =>
    <String, dynamic>{
      'token': instance.token,
    };
