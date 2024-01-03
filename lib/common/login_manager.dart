import 'package:flutter/material.dart';

import '../api/api.dart' as Api;
import '../page/login_page.dart';
import '../page/room_list_page.dart';

String _token = '';

String get getToken => _token;
void setToken(String token) {
  _token = token;
}

Future<void> checkLogin(BuildContext context) async {
  if (getToken.isEmpty) {
    // 跳转到用户登录界面
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  } else {
    String newToken = await Api.loginWithToken(getToken);
    setToken(newToken);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const RoomListPage()));
  }
}
