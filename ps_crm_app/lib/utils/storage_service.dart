import 'package:shared_preferences/shared_preferences.dart';
import 'package:ps_crm_app/models/user.dart';
import 'dart:convert';
import 'constants.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token management
  static Future<void> setToken(String token) async {
    await _prefs.setString(AppConstants.storageKeyToken, token);
  }

  static String? getToken() {
    return _prefs.getString(AppConstants.storageKeyToken);
  }

  static Future<void> clearToken() async {
    await _prefs.remove(AppConstants.storageKeyToken);
  }

  // User management
  static Future<void> setUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(AppConstants.storageKeyUser, userJson);
  }

  static User? getUser() {
    final userJson = _prefs.getString(AppConstants.storageKeyUser);
    if (userJson == null) return null;
    try {
      return User.fromJson(jsonDecode(userJson));
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearUser() async {
    await _prefs.remove(AppConstants.storageKeyUser);
  }

  // Theme
  static Future<void> setTheme(String theme) async {
    await _prefs.setString(AppConstants.storageKeyTheme, theme);
  }

  static String getTheme() {
    return _prefs.getString(AppConstants.storageKeyTheme) ?? 'light';
  }

  // Language
  static Future<void> setLanguage(String language) async {
    await _prefs.setString(AppConstants.storageKeyLanguage, language);
  }

  static String getLanguage() {
    return _prefs.getString(AppConstants.storageKeyLanguage) ?? 'en';
  }

  // Clear all
  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}
