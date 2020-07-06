import 'package:shared_preferences/shared_preferences.dart';

class SavePreference {
  //BOOL
  static void saveBool(String key, bool value) {
    SharedPreferences.getInstance().then((prefs) => prefs.setBool(key, value));
  }

  static getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  //INT
  static void saveInt(String key, int value) {
    SharedPreferences.getInstance().then((prefs) => prefs.setInt(key, value));
  }

  static Future<int> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  //STRING
  static void saveString(String key, String value) {
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString(key, value));
  }

  static Future<String> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
