import 'package:chat_room/common/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../api/api.dart' as Api;
import '../page/login_page.dart';
import '../page/room_list_page.dart';

String _token = '';
int _uid = 0;

String get getToken => _token;
void setToken(String token, {bool isSaveToken = false}) {
  _token = token;
  if (isSaveToken) {
    saveToken(token);
  }
}

void setUid(int id) {
  _uid = id;
}

int getUid() {
  return _uid;
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
    Api.loginWithToken(userName, token).then((value) {
      if (value.isNotEmpty) {
        Fluttertoast.showToast(msg: value);
        toLogin(context);
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const RoomListPage()));
      }
    });
  }
}

void toLogin(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
}
