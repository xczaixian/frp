import 'dart:ffi';

import 'package:chat_room/api/beans/wrap_bean.dart';
import 'package:chat_room/common/login_manager.dart';

import '../common/http_util.dart';

String getErrorMsg(Map<String, dynamic> json) {
  BaseBean baseBean = BaseBean.fromJson(json);
  if (baseBean.success) {
    return '';
  } else {
    return baseBean.message;
  }
}

// 注册接口
Future<bool> register() {
  return Future(() => true);
}

// 用户名登录,return msg
Future<String> loginWithUserName(String username, String pwd) async {
  final result = await post(
      'sso/login', {"username": username, "password": pwd},
      needToken: false);
  String msg = getErrorMsg(result);
  if (msg.isNotEmpty) {
    return Future(() => msg);
  }
  LoginBeanWrap loginBeanWrap = LoginBeanWrap.fromJson(result);
  if (loginBeanWrap.success) {
    setToken(loginBeanWrap.data.token, isSaveToken: true);
    setUsername(username);
    return Future(() => '');
  } else {
    return Future(() => loginBeanWrap.message);
  }
}

// token登录
Future<String> loginWithToken(String username, String token) async {
  final result = await post(
      'sso/loginByToken', {"username": username, "loginToken": token},
      needToken: false);
  LoginBeanWrap loginBeanWrap = LoginBeanWrap.fromJson(result);
  if (loginBeanWrap.success) {
    setToken(loginBeanWrap.data.token, isSaveToken: true);
    return Future(() => '');
  } else {
    return Future(() => loginBeanWrap.message);
  }
}

// 获取验证码
Future<String> getVerificationCode(String phone) async {
  final result =
      await post('sso/getAuthCode', {"telephone": phone}, needToken: false);
  AuthCodeWrap authCodeWrap = AuthCodeWrap.fromJson(result);
  return Future(() => authCodeWrap.data.code);
}

// 获取声网token
Future<String> getAgoraToken() {
  return Future(() => "");
}

// 创建房间
Future<void> createRoome() {
  return Future(() => Void);
}

// 查询通道列表
Future<void> queryChannelList() {
  return Future(() => Void);
}
