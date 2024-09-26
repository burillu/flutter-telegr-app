import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_app/extension/user_display_name_initials.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends ConnectivityWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget connectedBuild(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.app_name ?? ""),
        ),
        drawer: _drawer(context),
        body: Center(
          child: Text("Home page"),
        ),
      );

  Widget _drawer(BuildContext context) => Drawer(
        child: ListView(
          children: [
            _userHeaderDrawer(context),
          ],
        ),
      );
  Widget _userHeaderDrawer(BuildContext context) => UserAccountsDrawerHeader(
      currentAccountPicture: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey.shade300,
        child: Text(
          user.displayNameInitials,
          style: TextStyle(color: Colors.black54),
        ),
      ),
      accountName: user.displayName != null
          ? Text(user.displayName!)
          : Text(AppLocalizations.of(context)?.label_user_name ?? ""),
      accountEmail: Text(user.email!));
}
