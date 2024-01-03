// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrap_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
