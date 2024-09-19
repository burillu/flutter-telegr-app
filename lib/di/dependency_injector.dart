import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_app/cubits/dark_mode_cubit.dart';
import 'package:telegram_app/providers/shared_preferences_providers.dart';

class DependencyInjector extends StatelessWidget {
  final Widget child;

  const DependencyInjector({required this.child});

  @override
  Widget build(BuildContext context) {
    return _providers(child: _blocs(child: child));
  }

  Widget _providers({required Widget child}) => MultiProvider(
        providers: [
          Provider<SharedPreferencesProviders>(
              create: (_) => SharedPreferencesProviders(
                  sharedPreferences: SharedPreferences.getInstance()))
        ],
        child: child,
      );
  Widget _mappers({required Widget child}) => MultiProvider(
        providers: [],
        child: child,
      );
  Widget _repositories({required Widget child}) => MultiRepositoryProvider(
        providers: [],
        child: child,
      );
  Widget _blocs({required Widget child}) => MultiBlocProvider(
        providers: [
          BlocProvider<DarkModeCubit>(
            create: (context) => DarkModeCubit(
              sharedPreferencesProviders: context.read(),
            )..init(),
          ),
        ],
        child: child,
      );
}
