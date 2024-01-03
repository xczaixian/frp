// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginBean _$LoginBeanFromJson(Map<String, dynamic> json) => LoginBean(
      json['id'] as int,
      json['username'] as String,
      json['phone'] as String,
      json['state'] as bool,
      json['createTime'] as String,
      json['token'] as String,
      json['expireDay'] as int,
      json['tokenHead'] as String,
    );

Map<String, dynamic> _$LoginBeanToJson(LoginBean instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'phone': instance.phone,
      'state': instance.state,
      'createTime': instance.createTime,
      'token': instance.token,
      'expireDay': instance.expireDay,
      'tokenHead': instance.tokenHead,
    };
