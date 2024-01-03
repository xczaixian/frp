import 'package:json_annotation/json_annotation.dart';
part 'auth_code.g.dart';

@JsonSerializable()
class AuthCodeBean {
  String code;

  AuthCodeBean(this.code);

  factory AuthCodeBean.fromJson(Map<String, dynamic> json) =>
      _$AuthCodeBeanFromJson(json);

  Map<String, dynamic> toJson() => _$AuthCodeBeanToJson(this);
}
