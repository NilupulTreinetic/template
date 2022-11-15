// ignore_for_file: non_constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';
import 'app_logger.dart';


class LocalStorage {
  static final LocalStorage _singleton = LocalStorage._internal();

  factory LocalStorage() {
    return _singleton;
  }

  LocalStorage._internal();

  static String get USER_TOKEN_KEY => "com.getin.app.user_token";
  static String get IS_SESSION_EXPIRED => "com.getin.app.is_session_expired";
  

  Future<String?> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(USER_TOKEN_KEY);
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setString(USER_TOKEN_KEY, token);
    Log.info("$token save in local");
  }

}
