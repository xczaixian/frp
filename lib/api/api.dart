import 'dart:ffi';

import 'package:chat_room/api/beans/room_bean.dart';
import 'package:chat_room/api/beans/wrap_bean.dart';
import 'package:chat_room/common/logger_util.dart';
import 'package:chat_room/common/login_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import '../common/http_util.dart';

// 错误的时候，返回的是通用的数据结构
String getErrorMsg(Map<String, dynamic> json) {
  BaseBean baseBean = BaseBean.fromJson(json);
  if (baseBean.success) {
    return '';
  } else {
    return baseBean.message;
  }
}

// 注册接口
Future<String> register(
    String username, String password, String phone, String code) async {
  final result = await post(
      'sso/register',
      {
        "username": username,
        "password": password,
        "telephone": phone,
        "authCode": code,
      },
      needToken: false);
  String msg = getErrorMsg(result);
  if (msg.isNotEmpty) {
    return msg;
  }
  LoginBeanWrap loginBeanWrap = LoginBeanWrap.fromJson(result);
  if (loginBeanWrap.success) {
    setToken(loginBeanWrap.data.token, isSaveToken: true);
    setUsername(username);
    return '';
  } else {
    return loginBeanWrap.message;
  }
}

// 用户名登录,return error msg
Future<String> loginWithUserName(String username, String pwd) async {
  final result = await post(
      'sso/login', {"username": username, "password": pwd},
      needToken: false);
  String msg = getErrorMsg(result);
  if (msg.isNotEmpty) {
    return msg;
  }
  LoginBeanWrap loginBeanWrap = LoginBeanWrap.fromJson(result);
  if (loginBeanWrap.success) {
    setToken(loginBeanWrap.data.token, isSaveToken: true);
    setUsername(username);
    setUid(loginBeanWrap.data.id);
    return '';
  } else {
    return loginBeanWrap.message;
  }
}

// token登录
Future<String> loginWithToken(String username, String token) async {
  final result = await post(
      'sso/loginByToken', {"username": username, "loginToken": token},
      needToken: false);
  String msg = getErrorMsg(result);
  if (msg.isNotEmpty) {
    return msg;
  }
  LoginBeanWrap loginBeanWrap = LoginBeanWrap.fromJson(result);
  if (loginBeanWrap.success) {
    setToken(loginBeanWrap.data.token, isSaveToken: true);
    setUid(loginBeanWrap.data.id);
    return '';
  } else {
    return loginBeanWrap.message;
  }
}

// 获取验证码
Future<String> getVerificationCode(String phone) async {
  final result =
      await post('sso/getAuthCode', {"telephone": phone}, needToken: false);
  AuthCodeWrap authCodeWrap = AuthCodeWrap.fromJson(result);
  return authCodeWrap.data.code;
}

// 获取声网token
Future<String> getAgoraToken(String channelName, int uid,
    {int role = 0}) async {
  final result = await post('/agoratoken/generate/token',
      {"channelName": channelName, "uid": uid, "role": role},
      needToken: true);
  String msg = getErrorMsg(result);
  if (msg.isNotEmpty) {
    logger.d('请求token失败，msg=$msg');
    return '';
  }
  AgoraTokenWarpBean agoraTokenWarpBean = AgoraTokenWarpBean.fromJson(result);
  return agoraTokenWarpBean.data.token;
}

const default_channel_name = 'test';
const default_image = 'https://tianyahead.png';
const default_country = 'cn';
const default_roomType = 0;
const default_roompwd = '';

// 创建房间
Future<RoomBean?> createRoom(RoomBean roomBean) async {
  final result = await post(
      '/agora/create/channel',
      {
        "channelName": roomBean.channelName,
        "imageUrl": roomBean.imageUrl,
        "roomType": roomBean.roomType,
        "country": roomBean.country,
        "roomPwd": roomBean.roomPwd,
      },
      isPostJson: true,
      needToken: true);
  String msg = getErrorMsg(result);
  if (msg.isNotEmpty) {
    Fluttertoast.showToast(msg: '创建房间失败,$msg');
    return null;
  }
  return roomBean;
}

// 查询通道列表
Future<List<RoomBean>> queryChannelList() async {
  final result = await post('agora/query/channel', {}, needToken: true);
  String msg = getErrorMsg(result);
  if (msg.isNotEmpty) {
    Fluttertoast.showToast(msg: '请求失败,msg=$msg');
    return List.empty();
  }
  RoomBeanWrap roomBeanWrap = RoomBeanWrap.fromJson(result);
  return roomBeanWrap.data.channels;
}
