// ignore_for_file: non_constant_identifier_names
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefProvider with ChangeNotifier {
  final SharedPreferences _prefs;

  PrefProvider(this._prefs) {}
  void clearAllPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("All SharedPreferences cleared.");
  }

  bool isLoggedIn() {
    return _prefs.getBool('isLoggedIn') ?? false;
  }

  void login() {
    _prefs.setBool("isLoggedIn", true);
  }

  void logout() {
    _prefs.setBool('isLoggedIn', false);
    _prefs.remove('userEmail'); // Clear email on logout
    _prefs.remove('accessToken'); // Clear token on logout
    _prefs.remove('userId'); // Clear user ID on logout
  }

  void setUserEmail(String email) {
    _prefs.setString('userEmail', email);
  }

  String getUserEmail() {
    return _prefs.getString('userEmail') ?? '';
  }

  void setAccessToken(String token) {
    _prefs.setString('accessToken', token);
  }

  String getAccessToken() {
    return _prefs.getString('accessToken') ?? '';
  }

  void setuserId(int userId) {
    _prefs.setInt('userId', userId);
    print("oklelk$userId");
  }

  int getuserId() {
    return _prefs.getInt('userId') ?? 0;
  }

  void setSelectedLanguage(String language) {
    _prefs.setString("language", language);
  }

  String getSeletctedLanguage() {
    return _prefs.getString("language") ?? "en";
  }
}
