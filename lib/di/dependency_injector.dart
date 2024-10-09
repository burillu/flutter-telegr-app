import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telegram_app/cubits/auth/auth_cubit.dart';
import 'package:telegram_app/cubits/dark_mode_cubit.dart';
import 'package:telegram_app/misc/mappers/firebase_chat_mapper.dart';
import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/misc/mappers/firebase_user_mapper.dart';
import 'package:telegram_app/models/chat.dart';
import 'package:telegram_app/models/user.dart' as model;
import 'package:telegram_app/providers/shared_preferences_providers.dart';
import 'package:telegram_app/repositories/authentication_repository.dart';
import 'package:telegram_app/repositories/chat_repository.dart';
import 'package:telegram_app/repositories/user_repository.dart';

class DependencyInjector extends StatelessWidget {
  final Widget child;

  const DependencyInjector({required this.child});

  @override
  Widget build(BuildContext context) {
    return _providers(
        child: _mappers(child: _repositories(child: _blocs(child: child))));
  }

  Widget _providers({required Widget child}) => MultiProvider(
        providers: [
          Provider<SharedPreferencesProviders>(
            create: (_) => SharedPreferencesProviders(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
          Provider<FirebaseAuth>(
            create: (_) => FirebaseAuth.instance,
          ),
          Provider<GoogleSignIn>(
            create: (_) => GoogleSignIn(scopes: [
              'email',
              'https://www.googleapis.com/auth/contacts.readonly',
              'https://www.googleapis.com/auth/userinfo.profile',
            ]),
          ),
          Provider<FirebaseFirestore>(
            create: (_) => FirebaseFirestore.instance,
          )
        ],
        child: child,
      );
  Widget _mappers({required Widget child}) => MultiProvider(
        providers: [
          Provider<FirebaseMapper<model.User>>(
              create: (_) => FirebaseUserMapper()),
          Provider<FirebaseMapper<Chat>>(create: (_) => FirebaseChatMapper()),
        ],
        child: child,
      );
  Widget _repositories({required Widget child}) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
              create: (context) => AuthenticationRepository(
                  firebaseAuth: context.read(), googleSignIn: context.read())),
          RepositoryProvider<UserRepository>(
            create: (context) => UserRepository(
              firebaseFirestore: context.read(),
              firebaseUserMapper: context.read(),
            ),
          ),
          RepositoryProvider<ChatRepository>(
            create: (context) => ChatRepository(
              firebaseUserMapper: context.read(),
              firebaseChatMapper: context.read(),
              firebaseFirestore: context.read(),
            ),
          ),
        ],
        child: child,
      );
  Widget _blocs({required Widget child}) => MultiBlocProvider(
        providers: [
          BlocProvider<DarkModeCubit>(
            create: (context) => DarkModeCubit(
              sharedPreferencesProviders: context.read(),
            )..init(),
          ),
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(firebaseAuth: context.read()),
          ),
        ],
        child: child,
      );
}
