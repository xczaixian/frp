import 'package:json_annotation/json_annotation.dart';
part 'room_bean.g.dart';

@JsonSerializable()
class RoomBean {
  String channelName;
  String imageUrl;
  int roomType;
  String country;
  String roomPwd;

  RoomBean(this.channelName, this.imageUrl, this.roomPwd, this.country,
      this.roomType);

  factory RoomBean.fromJson(Map<String, dynamic> json) =>
      _$RoomBeanFromJson(json);

  Map<String, dynamic> toJson() => _$RoomBeanToJson(this);
}
