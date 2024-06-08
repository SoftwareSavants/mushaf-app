import 'package:shared_preferences/shared_preferences.dart';

enum PreferencesKey {
  theme,
  locale,
  lastRole,
  articlesFontSize,
  dailyDoze,
  isJuz,
  completedPages,
  completedWirds,
  custom
}

class Preferences {
  static late SharedPreferences preferences;

  static Future<void> initialize() async =>
      preferences = await SharedPreferences.getInstance();

  static String? getString(PreferencesKey key) =>
      preferences.getString(key.name);
  static Future<bool> setString(PreferencesKey key, String value) =>
      preferences.setString(key.name, value);

  static int? getInt(PreferencesKey key) => preferences.getInt(key.name);
  static Future<bool> setInt(PreferencesKey key, int value) =>
      preferences.setInt(key.name, value);

  static bool? getBool(PreferencesKey key, {String? customKey}) =>
      preferences.getBool(key == PreferencesKey.custom ? customKey! : key.name);

  static Future<bool> setBool(
    PreferencesKey key,
    bool value, {
    String? customKey,
  }) =>
      preferences.setBool(
        key == PreferencesKey.custom ? customKey! : key.name,
        value,
      );

  static Future<bool> remove(PreferencesKey key, {String? customKey}) =>
      preferences.remove(key == PreferencesKey.custom ? customKey! : key.name);
}
