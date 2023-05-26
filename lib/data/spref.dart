import 'package:shared_preferences/shared_preferences.dart';

/// Function call data local
class SPref {
  static final SPref instant = SPref._internal();

  SPref._internal();

  late SharedPreferences prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  String? get getToken => prefs.getString(AppKey.xToken);
  String? get getRefreshToken => prefs.getString(AppKey.xTokenRefresh);

  Future setToken(String token) async {
    await prefs.setString(AppKey.xToken, token);
  }

  Future setRefreshToken(String token) async {
    await prefs.setString(AppKey.xTokenRefresh, token);
  }
}

class AppKey {
  static const String xToken = 'x-token';
  static const String xTokenRefresh = 'x-tokenRefresh';
}
