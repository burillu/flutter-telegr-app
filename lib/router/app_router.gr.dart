// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:firebase_auth/firebase_auth.dart' as _i8;
import 'package:flutter/material.dart' as _i7;
import 'package:telegram_app/models/user.dart' as _i9;
import 'package:telegram_app/pages/chat_page.dart' as _i1;
import 'package:telegram_app/pages/main_page.dart' as _i2;
import 'package:telegram_app/pages/new_message_page.dart' as _i3;
import 'package:telegram_app/pages/sign_in/sign_in_page.dart' as _i4;
import 'package:telegram_app/pages/sign_up/sign_up_page.dart' as _i5;

/// generated route for
/// [_i1.ChatPage]
class ChatRoute extends _i6.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i7.Key? key,
    required _i8.User user,
    required _i9.User other,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          ChatRoute.name,
          args: ChatRouteArgs(
            key: key,
            user: user,
            other: other,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRouteArgs>();
      return _i1.ChatPage(
        key: args.key,
        user: args.user,
        other: args.other,
      );
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.user,
    required this.other,
  });

  final _i7.Key? key;

  final _i8.User user;

  final _i9.User other;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, user: $user, other: $other}';
  }
}

/// generated route for
/// [_i2.MainPage]
class MainRoute extends _i6.PageRouteInfo<void> {
  const MainRoute({List<_i6.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return _i2.MainPage();
    },
  );
}

/// generated route for
/// [_i3.NewMessagePage]
class NewMessageRoute extends _i6.PageRouteInfo<NewMessageRouteArgs> {
  NewMessageRoute({
    _i7.Key? key,
    required _i8.User user,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          NewMessageRoute.name,
          args: NewMessageRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'NewMessageRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NewMessageRouteArgs>();
      return _i6.WrappedRoute(
          child: _i3.NewMessagePage(
        key: args.key,
        user: args.user,
      ));
    },
  );
}

class NewMessageRouteArgs {
  const NewMessageRouteArgs({
    this.key,
    required this.user,
  });

  final _i7.Key? key;

  final _i8.User user;

  @override
  String toString() {
    return 'NewMessageRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i4.SignInPage]
class SignInRoute extends _i6.PageRouteInfo<void> {
  const SignInRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return _i6.WrappedRoute(child: const _i4.SignInPage());
    },
  );
}

/// generated route for
/// [_i5.SignUpPage]
class SignUpRoute extends _i6.PageRouteInfo<void> {
  const SignUpRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return _i6.WrappedRoute(child: _i5.SignUpPage());
    },
  );
}
