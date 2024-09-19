import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_app/cubits/dark_mode_cubit.dart';
import 'package:telegram_app/di/dependency_injector.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telegram_app/pages/home_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DependencyInjector(
        child: _themeSelector(
          (context, mode) => MaterialApp(
              title: "Telegram",
              theme: _theme(context),
              darkTheme: _themeDark(context),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              themeMode: mode,
              home: HomePage()),
        ),
      );
  Widget _themeSelector(
          Widget Function(BuildContext context, ThemeMode mode) widget) =>
      BlocBuilder<DarkModeCubit, bool>(
        builder: (context, darkModeEnable) =>
            widget(context, darkModeEnable ? ThemeMode.dark : ThemeMode.light),
      );

  ThemeData _theme(BuildContext context) => ThemeData(
        primaryColor: Colors.lightBlue,
        primaryColorDark: Colors.blue,
        colorScheme:
            Theme.of(context).colorScheme.copyWith(secondary: Colors.lightBlue),
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          centerTitle: true,
        ),
      );
  ThemeData _themeDark(BuildContext context) => ThemeData.dark().copyWith(
        colorScheme:
            Theme.of(context).colorScheme.copyWith(secondary: Colors.lightBlue),
        appBarTheme: AppBarTheme(centerTitle: true),
      );
}
