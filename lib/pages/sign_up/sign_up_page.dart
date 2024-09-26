import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:telegram_app/blocs/sign_up/sign_up_bloc.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class SignUpPage extends ConnectivityWidget implements AutoRouteWrapper {
  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider<SignUpBloc>(
        create: (context) => SignUpBloc(
          authenticationRepository: context.read(),
          authCubit: context.read(),
        ),
        child: this,
      );

  @override
  Widget connectedBuild(BuildContext context) =>
      BlocConsumer<SignUpBloc, SignUpState>(
          builder: (context, state) => Scaffold(
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
                      _firstName(context, enabled: state is! SigningUpState),
                      SizedBox(height: 5),
                      _lastName(context, enabled: state is! SigningUpState),
                      SizedBox(height: 10),
                      _emailField(context, enabled: state is! SigningUpState),
                      SizedBox(height: 5),
                      _confirmEmailField(context,
                          enabled: state is! SigningUpState),
                      SizedBox(height: 10),
                      _passwordField(context,
                          enabled: state is! SigningUpState),
                      SizedBox(height: 5),
                      _confirmPasswordField(context,
                          enabled: state is! SigningUpState),
                      SizedBox(height: 10),
                      _signUpButton(context, enabled: state is! SigningUpState),
                      SizedBox(height: 10),
                      if (state is SigningUpState) _progress(context),
                    ],
                  ),
                ),
              ),
          listener: (context, state) {
            _shouldCloseForSignedUp(context, state: state);
            _shouldShowErrorForSignUpDialog(context, state: state);
          });

  Widget _firstName(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder(
        binding: context.watch<SignUpBloc>().firstNameBinding,
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
          keyboardType: TextInputType.name,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.label_first_name ?? "",
            errorText: error?.localizedString(context),
          ),
        ),
      );
  Widget _lastName(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder(
        binding: context.watch<SignUpBloc>().lastNameBinding,
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
          keyboardType: TextInputType.name,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.label_last_name ?? "",
            errorText: error?.localizedString(context),
          ),
        ),
      );
  Widget _emailField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder(
        binding: context.watch<SignUpBloc>().emailBinding,
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
          onChanged: onChanged,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.label_email ?? "",
            errorText: error?.localizedString(context),
          ),
        ),
      );
  Widget _confirmEmailField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder(
        binding: context.watch<SignUpBloc>().confirmEmailBinding,
        builder: (
          context,
          controller,
          data,
          onChanged,
          error,
        ) =>
            TextField(
          controller: controller,
          onChanged: onChanged,
          enabled: enabled,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.label_confirm_email ?? "",
            errorText: error?.localizedString(context),
          ),
        ),
      );
  Widget _passwordField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder(
        binding: context.watch<SignUpBloc>().passwordBinding,
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
          onChanged: onChanged,
          obscureText: true,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)?.label_password ?? "",
            errorText: error?.localizedString(context),
          ),
        ),
      );
  Widget _confirmPasswordField(BuildContext context, {bool enabled = true}) =>
      TwoWayBindingBuilder(
        binding: context.watch<SignUpBloc>().confirmPasswordBinding,
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
          onChanged: onChanged,
          obscureText: true,
          decoration: InputDecoration(
            hintText:
                AppLocalizations.of(context)?.label_confirm_password ?? "",
            errorText: error?.localizedString(context),
          ),
        ),
      );
  Widget _signUpButton(BuildContext context, {bool enabled = true}) {
    Widget signUpButtonEnable(
      BuildContext context, {
      required Widget Function(bool) function,
    }) =>
        StreamBuilder<bool>(
          initialData: false,
          stream: context.watch<SignUpBloc>().areValidCredentials,
          builder: (context, snapshot) =>
              function(enabled && snapshot.hasData && snapshot.data!),
        );

    return signUpButtonEnable(context,
        function: (enabled) => ElevatedButton(
              onPressed: enabled
                  ? () => context.read<SignUpBloc>().performSignUp()
                  : null,
              child: Text(AppLocalizations.of(context)?.action_sign_up ?? ""),
            ));
  }

  Widget _progress(BuildContext context, {bool enabled = true}) =>
      enabled ? Center(child: CircularProgressIndicator()) : Container();

  void _shouldCloseForSignedUp(BuildContext context,
      {required SignUpState state}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state is SuccessSignUpState) {
        context.router.popUntilRoot();
      }
    });
  }

  void _shouldShowErrorForSignUpDialog(BuildContext context,
      {required SignUpState state}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state is ErrorSignUpState) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)
                          ?.dialog_wrong_sign_up_title ??
                      ''),
                  content: Text(AppLocalizations.of(context)
                          ?.dialog_wrong_sign_up_message ??
                      ''),
                  actions: [
                    TextButton(
                      onPressed: () => context.router.popForced(),
                      child:
                          Text(AppLocalizations.of(context)?.action_ok ?? ''),
                    ),
                  ],
                ));
      }
    });
  }
}
