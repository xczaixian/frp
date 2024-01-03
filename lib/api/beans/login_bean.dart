import 'package:json_annotation/json_annotation.dart';
part 'login_bean.g.dart';

@JsonSerializable()
class LoginBean {
  int id;
  String username;
  String phone;
  bool state;
  String createTime;
  String token;
  int expireDay;
  String tokenHead;

  LoginBean(this.id, this.username, this.phone, this.state, this.createTime,
      this.token, this.expireDay, this.tokenHead);

  factory LoginBean.fromJson(Map<String, dynamic> json) =>
      _$LoginBeanFromJson(json);

  Map<String, dynamic> toJson() => _$LoginBeanToJson(this);
}
