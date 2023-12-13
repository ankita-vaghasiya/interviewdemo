import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legolend/utils/app_preferences.dart';

class LanguageChangeProvider with ChangeNotifier {
  static Locale _currentLocal = const Locale("en");

  static Locale get currentLocal => _currentLocal;

  LanguageChangeProvider() {
    _currentLocal = Locale(AppPreference.getLang());
  }

  static void changeLanguage(Locale type) async {
    print("1233");
    if (_currentLocal == type) {
      return;
    }
    print("----");
    _currentLocal = type;
    await AppPreference.setLang(_currentLocal.languageCode);
    Get.updateLocale(_currentLocal);
  }
}
