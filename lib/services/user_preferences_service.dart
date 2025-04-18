import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPreferencesService {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserEmail = 'userEmail';
  static const String _keyUserName = 'userName';
  static const String _keyUserPhotoUrl = 'userPhotoUrl';

  static Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserEmail, user.email ?? '');
    await prefs.setString(_keyUserName, user.displayName ?? '');
    await prefs.setString(_keyUserPhotoUrl, user.photoURL ?? '');
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIsLoggedIn);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserPhotoUrl);
  }

  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  static Future<String?> getUserPhotoUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserPhotoUrl);
  }
}
