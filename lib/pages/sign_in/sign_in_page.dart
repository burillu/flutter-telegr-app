import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class SignInPage extends ConnectivityWidget {
  const SignInPage({super.key});

  @override
  Widget connectedBuild(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.title_sign_in ?? ""),
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _emailField(context),
            // _nameField(context),
            _passwordField(context),
            _signInButton(context),
            _googleSignInButton(context),
            _divider(context),
            _signUpButton(context)
          ],
        ),
      );

  Widget _emailField(BuildContext context) => TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.label_email ?? ""),
      );

  Widget _passwordField(BuildContext context) => TextField(
        obscureText: true,
        decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.label_password ?? ""),
      );
  Widget _signInButton(BuildContext context) => ElevatedButton(
      onPressed: () {},
      child: Text(AppLocalizations.of(context)?.action_login ?? ""));
  Widget _googleSignInButton(BuildContext context) => SignInButton(
        Buttons.Google,
        onPressed: () {},
        // child: Text(AppLocalizations.of(context)?.label_google_sign_in ?? ""),
      );
  Widget _signUpButton(BuildContext context) => ElevatedButton(
      onPressed: () {},
      child: Text(AppLocalizations.of(context)?.action_sign_up ?? ""));
  Widget _divider(BuildContext context) {
    final divider = Expanded(
        child: Divider(
      height: 0,
    ));
    return Row(
      children: [
        divider,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            AppLocalizations.of(context)?.label_or ?? "",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        divider,
      ],
    );
  }
}
