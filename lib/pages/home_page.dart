import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_app/cubits/auth/auth_cubit.dart';
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
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _userHeaderDrawer(context),
                ],
              ),
            ),
            Divider(height: 0),
            _logoutButton(context),
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
  Widget _logoutButton(BuildContext context) => ListTile(
        onTap: () => _shouldShowLogoutDialog(context),
        leading: Icon(Icons.logout),
        title: Text(AppLocalizations.of(context)?.action_logout ?? ""),
      );

  _shouldShowLogoutDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
              AppLocalizations.of(context)?.dialog_title_confirm_logout ?? ""),
          content: Text(
              AppLocalizations.of(context)?.dialog_confirm_logout_message ??
                  ""),
          actions: [
            TextButton(
              onPressed: () => _signOut(context),
              child: Text(AppLocalizations.of(context)?.action_ok ?? ""),
            ),
            TextButton(
                onPressed: () => context.router.popForced(),
                child: Text(AppLocalizations.of(context)?.action_no ?? ""))
          ],
        ),
      ),
    );
  }

  void _signOut(BuildContext context) {
    context.read<AuthCubit>().signOut();
    context.router.popUntilRoot();
  }
}
