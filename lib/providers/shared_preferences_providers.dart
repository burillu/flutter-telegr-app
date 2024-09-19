import 'package:shared_preferences/shared_preferences.dart';

const String _SHARED_PREFERNCES_DARK_MODE_ENABLE = "DARK_MODE_ENABLE";

class SharedPreferencesProviders {
  final Future<SharedPreferences> sharedPreferences;

  SharedPreferencesProviders({
    required this.sharedPreferences,
  });

  Future<bool> get darkModeEnable async =>
      (await sharedPreferences).getBool(_SHARED_PREFERNCES_DARK_MODE_ENABLE) ??
      false;

  Future<void> setDarkMode(bool mode) async => (await sharedPreferences)
      .setBool(_SHARED_PREFERNCES_DARK_MODE_ENABLE, mode);
}
