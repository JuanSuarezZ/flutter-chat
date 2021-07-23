import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../theme/app_theme.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeDataLight = lightTheme;
  ThemeData _themeDataDark = darkTheme;
  ThemeData _themaActual;
  final _storage = new FlutterSecureStorage();

  ThemeNotifier() {
    this._themaActual = _themeDataLight;
  }

  getTheme() => this._themaActual;

  setTheme() async {
    if (this._themaActual == _themeDataDark) {
      guardarTheme("light");
      this._themaActual = _themeDataLight;
    } else {
      guardarTheme("dark");
      this._themaActual = _themeDataDark;
    }
    notifyListeners();
  }

  getStorageTheme() async {
    final theme = await _storage.read(key: 'theme');
    if (theme == "light") {
      this._themaActual = this._themeDataLight;
    } else {
      this._themaActual = this._themeDataDark;
    }
  }

  guardarTheme(String string) {
    _storage.write(key: 'theme', value: string);
  }
}
