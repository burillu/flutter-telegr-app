import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_app/cubits/auth/auth_cubit.dart';
import 'package:telegram_app/pages/home_page.dart';
import 'package:telegram_app/pages/welcome/welcome_page.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';

class MainPage extends ConnectivityWidget {
  @override
  Widget connectedBuild(BuildContext context) =>
      BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) => state is LoadingAuthenticationState
            ? _progressIndicator()
            : state is AuthenticatedUserState
                ? HomePage(user: state.user)
                : WelcomePage(),
      );

  Widget _progressIndicator() => CircularProgressIndicator();
}
