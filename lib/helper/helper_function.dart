import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  ///keys
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String isDarkTheme = "ISDARKTHEME";

//save data
//getting data
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences spf = await SharedPreferences.getInstance();

    return spf.getBool(userLoggedInKey);
  }

  static Future<bool> isUserLoggedIn(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserName(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmail(String email) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userEmailKey, email);
  }

  static Future<bool?> getUserThemeChoice() async {
    SharedPreferences spf = await SharedPreferences.getInstance();
    return spf.getBool(isDarkTheme);
  }

  static Future<String?> getUserName() async {
    SharedPreferences spf = await SharedPreferences.getInstance();
    return spf.getString(userNameKey);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences spf = await SharedPreferences.getInstance();
    return spf.getString(userEmailKey);
  }

  static Future<bool> saveUserThemeChoice(bool isDarkMode) async {
    SharedPreferences spf = await SharedPreferences.getInstance();
    return spf.setBool(isDarkTheme, isDarkMode);
  }
}
