import 'package:flutter/material.dart';
import 'package:namnam/core/helpers/localization_helper.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _currentLocale = LocalizationHelper.getDefaultLocale();

  Locale get currentLocale => _currentLocale;

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final savedLocale = await LocalizationHelper.getSavedLocale();
    if (savedLocale != null) {
      _currentLocale = savedLocale;
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_currentLocale != locale) {
      _currentLocale = locale;
      await LocalizationHelper.saveLocale(locale);
      notifyListeners();
    }
  }

  bool isRTL() {
    return _currentLocale.languageCode == 'ar';
  }

  TextDirection getTextDirection() {
    return isRTL() ? TextDirection.rtl : TextDirection.ltr;
  }
} 