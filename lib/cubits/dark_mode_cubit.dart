import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_app/providers/shared_preferences_providers.dart';

class DarkModeCubit extends Cubit<bool> {
  final SharedPreferencesProviders sharedPreferencesProviders;
  DarkModeCubit({required this.sharedPreferencesProviders}) : super(false);

  void init() async {
    emit(await sharedPreferencesProviders.darkModeEnable);
  }

  void setDarkModeEnable(bool mode) async {
    await sharedPreferencesProviders.setDarkMode(mode);
    emit(mode);
  }

  void toggleDarkMode(bool mode) => setDarkModeEnable(!state);
}
