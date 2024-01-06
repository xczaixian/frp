// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomBean _$RoomBeanFromJson(Map<String, dynamic> json) => RoomBean(
      json['channelName'] as String,
      json['imageUrl'] as String,
      json['roomPwd'] as String,
      json['country'] as String,
      json['roomType'] as int,
    );

Map<String, dynamic> _$RoomBeanToJson(RoomBean instance) => <String, dynamic>{
      'channelName': instance.channelName,
      'imageUrl': instance.imageUrl,
      'roomType': instance.roomType,
      'country': instance.country,
      'roomPwd': instance.roomPwd,
    };
