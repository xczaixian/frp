//全局的参数存放位置

class UserInfo {
  String? token;
  String userName = '';
  String uid = '';
}

UserInfo? _userInfo;

UserInfo? getInfo() {
  return _userInfo;
}

void setUserInfo(UserInfo userInfo) {
  _userInfo = userInfo;
}
