import 'package:chat_room/page/ChatRoomPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPKey {
  static String username = "username";
  static String password = "password";
  static String hasRegister = "hasRegister";
}

class SPUtil {
  SPUtil._();

  static final SPUtil _instance = SPUtil._();

  static SPUtil get instance => _instance;

  late SharedPreferences sp;

  Future<void> initSP() async {
    sp = await SharedPreferences.getInstance();
  }

  String? getString(String key) {
    return sp.getString(key);
  }

  void setString(String key, String value) {
    sp.setString(key, value).then((success) {
      if (success) {
        logger.d("保存sp成功,$key,$value");
      } else {
        logger.d("保存sp失败,$key,$value");
      }
    });
  }

  String getOrSetString(String key, String defaultValue) {
    String? value = getString(key);
    if (value == null) {
      value = defaultValue;
      setString(key, value);
    }
    return value;
  }

  bool? getBool(String key) {
    return sp.getBool(key);
  }

  void setBool(String key, bool value) {
    sp.setBool(key, value).then((success) {
      if (success) {
        logger.d("保存sp成功,$key,$value");
      } else {
        logger.d("保存sp失败,$key,$value");
      }
    });
  }
}
