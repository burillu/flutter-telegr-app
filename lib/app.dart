import 'package:flutter/material.dart';
import 'package:telegram_app/di/dependency_injector.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => DependencyInjector(
          child: MaterialApp(
        title: "Telegram",
        theme: _theme(context),
        darkTheme: _themeDark(context),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(child: Text("Hello telegram")),
        ),
      ));

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
