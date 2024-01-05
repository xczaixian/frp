import 'package:chat_room/common/sp_util.dart';
import 'package:flutter/material.dart';

import '../api/api.dart' as Api;
import '../page/login_page.dart';
import '../page/room_list_page.dart';
import 'package:toast/toast.dart';

String _token = '';

String get getToken => _token;
void setToken(String token, {bool isSaveToken = false}) {
  _token = token;
  if (isSaveToken) {
    saveToken(token);
  }
}

void saveToken(String token) {
  SPUtil.instance.setString(SPKey.token, token);
}

void setUsername(String username) {
  SPUtil.instance.setString(SPKey.loginUserName, username);
}

Future<void> checkLogin(BuildContext context) async {
  String? userName = SPUtil.instance.getString(SPKey.loginUserName);
  String? token = SPUtil.instance.getString(SPKey.token);
  if (token == null || userName == null) {
    toLogin(context);
  } else {
    Api.loginWithToken(userName!, getToken).then((value) {
      if (value.isNotEmpty) {
        Toast.show(value, duration: Toast.lengthLong, gravity: Toast.bottom);
        toLogin(context);
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RoomListPage()));
      }
    });
  }
}

void toLogin(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
}
