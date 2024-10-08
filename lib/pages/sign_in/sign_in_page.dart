import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:telegram_app/blocs/sign_in/sign_in_bloc.dart';
import 'package:telegram_app/router/app_router.gr.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class SignInPage extends ConnectivityWidget implements AutoRouteWrapper {
  const SignInPage({super.key});

  @override
  Widget wrappedRoute(_) => BlocProvider<SignInBloc>(
        create: (context) => SignInBloc(
          authenticationRepository: context.read(),
          userRepository: context.read(),
          authCubit: context.read(),
        ),
        child: this,
      );

  @override
  Widget connectedBuild(BuildContext context) =>
      BlocConsumer<SignInBloc, SignInState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)?.title_sign_in ?? ""),
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            padding: EdgeInsets.all(16),
            children: [
              _emailField(context, enabled: state is! SigningInState),
              SizedBox(height: 5),
              _passwordField(context, enabled: state is! SigningInState),
              SizedBox(height: 6),
              _signInButton(context, enabled: state is! SigningInState),
              SizedBox(height: 5),
              _googleSignInButton(context, enabled: state is! SigningInState),
              SizedBox(height: 5),
              _divider(context),
              SizedBox(height: 5),
              _signUpButton(
                context,
              ),
              SizedBox(
                height: 20,
              ),
              if (state is SigningInState) _progress(context),
            ],
          ),
        ),
        listener: (context, state) {
          _shouldCloseForSignedIn(context, state: state);
          _shouldShowErrorSignInDialog(context, state: state);
        },
      );

  Widget _emailField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder<String>(
        binding: context.watch<SignInBloc>().emailBinding,
        builder: (
          context,
          controller,
          data,
          onChanged,
          error,
        ) =>
            TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          enabled: enabled,
          onChanged: onChanged,
          // keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.label_email ?? "",
            errorText: error?.localizedString(context),
          ),
        ),
      );

  Widget _passwordField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder<String>(
        binding: context.watch<SignInBloc>().passwordBinding,
        builder: (
          context,
          controller,
          data,
          onChanged,
          error,
        ) =>
            TextField(
          controller: controller,
          enabled: enabled,
          obscureText: true,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.label_password ?? "",
            errorText: error?.localizedString(context),
          ),
        ),
      );
  Widget _signInButton(BuildContext context, {bool enabled = true}) {
    Widget signInButtonEnable(
      BuildContext context, {
      required Widget Function(bool) function,
    }) =>
        StreamBuilder<bool>(
          initialData: false,
          stream: context.watch<SignInBloc>().areValidCredentials,
          builder: (context, snapshot) =>
              function(enabled && snapshot.hasData && snapshot.data!),
        );
    return signInButtonEnable(
      context,
      function: (enabled) => ElevatedButton(
        onPressed:
            enabled ? () => context.read<SignInBloc>().performSignIn() : null,
        child: Text(AppLocalizations.of(context)?.action_login ?? ""),
      ),
    );
  }

  Widget _googleSignInButton(BuildContext context, {bool enabled = true}) =>
      enabled
          ? SignInButton(
              Buttons.Google,
              onPressed: () {},
              // child: Text(AppLocalizations.of(context)?.label_google_sign_in ?? ""),
            )
          : Container();
  Widget _signUpButton(BuildContext context) => ElevatedButton(
      onPressed: () => context.router.push(SignUpRoute()),
      child: Text(AppLocalizations.of(context)?.action_sign_up ?? ""));
  Widget _progress(BuildContext context) => Center(
        child: CircularProgressIndicator(),
      );
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

  void _shouldCloseForSignedIn(BuildContext context,
      {required SignInState state}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state is SuccessSignInState) {
        context.router.popUntilRoot();
      }
    });
  }

  void _shouldShowErrorSignInDialog(BuildContext context,
      {required SignInState state}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state is ErrorSignInState) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                      AppLocalizations.of(context)?.dialog_wrong_login_title ??
                          ""),
                  content: Text(AppLocalizations.of(context)
                          ?.dialog_wrong_login_message ??
                      ""),
                  actions: [
                    TextButton(
                        onPressed: () => context.router.popForced(),
                        child:
                            Text(AppLocalizations.of(context)?.action_ok ?? ""))
                  ],
                ));
      }
    });
  }
}
