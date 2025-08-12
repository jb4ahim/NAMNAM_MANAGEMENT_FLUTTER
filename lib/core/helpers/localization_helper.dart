import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationHelper {
  static const String _localeKey = 'selected_locale';
  
  // Get the saved locale from SharedPreferences
  static Future<Locale?> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeString = prefs.getString(_localeKey);
    if (localeString != null) {
      return Locale(localeString);
    }
    return null;
  }
  
  // Save the selected locale to SharedPreferences
  static Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
  
  // Get the default locale (English)
  static Locale getDefaultLocale() {
    return const Locale('en');
  }
  
  // Get supported locales
  static List<Locale> getSupportedLocales() {
    return const [
      Locale('en'),
      Locale('ar'),
    ];
  }
  
  // Get locale display name
  static String getLocaleDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }
} 