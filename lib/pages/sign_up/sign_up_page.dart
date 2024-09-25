import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class SignUpPage extends ConnectivityWidget {
  @override
  Widget connectedBuild(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)?.title_sign_up ?? "",
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _firstName(context),
              SizedBox(height: 5),
              _lastName(context),
              SizedBox(height: 10),
              _emailField(context),
              SizedBox(height: 5),
              _confirmEmailField(context),
              SizedBox(height: 10),
              _passwordField(context),
              SizedBox(height: 5),
              _confirmPasswordField(context),
              SizedBox(height: 10),
              _signUpButton(context),
              SizedBox(height: 10),
              _progress(context, enabled: false),
            ],
          ),
        ),
      );

  Widget _firstName(BuildContext context, {bool enabled = true}) => TextField(
        enabled: enabled,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)?.label_first_name ?? "",
        ),
      );
  Widget _lastName(BuildContext context, {bool enabled = true}) => TextField(
        enabled: enabled,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)?.label_last_name ?? "",
        ),
      );
  Widget _emailField(BuildContext context, {bool enabled = true}) => TextField(
        enabled: enabled,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)?.label_email ?? "",
        ),
      );
  Widget _confirmEmailField(BuildContext context, {bool enabled = true}) =>
      TextField(
        enabled: enabled,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)?.label_confirm_email ?? "",
        ),
      );
  Widget _passwordField(BuildContext context, {bool enabled = true}) =>
      TextField(
        enabled: enabled,
        obscureText: true,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)?.label_password ?? "",
        ),
      );
  Widget _confirmPasswordField(BuildContext context, {bool enabled = true}) =>
      TextField(
        enabled: enabled,
        obscureText: true,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)?.label_confirm_password ?? "",
        ),
      );
  Widget _signUpButton(BuildContext context, {bool enabled = true}) =>
      ElevatedButton(
        onPressed: () {},
        child: Text(AppLocalizations.of(context)?.action_sign_up ?? ""),
      );
  Widget _progress(BuildContext context, {bool enabled = true}) =>
      enabled ? Center(child: CircularProgressIndicator()) : Container();
}
