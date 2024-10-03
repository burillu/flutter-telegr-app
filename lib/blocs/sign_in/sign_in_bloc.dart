import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:telegram_app/cubits/auth/auth_cubit.dart';
import 'package:telegram_app/extension/user_first_last_name.dart';
import 'package:telegram_app/repositories/authentication_repository.dart';
import 'package:telegram_app/repositories/user_repository.dart';
import 'package:telegram_app/models/user.dart' as model;

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;
  final AuthCubit authCubit;

  final emailBinding = TwoWayBinding<String>()
      .bindDataRule(RequiredRule())
      .bindDataRule(EmailRule());
  final passwordBinding = TwoWayBinding<String>().bindDataRule(RequiredRule());

  SignInBloc({
    required this.authenticationRepository,
    required this.userRepository,
    required this.authCubit,
  }) : super(InitialSignInState()) {
    on<SignInEvent>((event, emit) async {
      emit(SigningInState());

      UserCredential? userCredential;
      StreamSubscription? streamSubscription;

      try {
        if (event is PerformSignInEvent) {
          userCredential = await authenticationRepository.signIn(
              email: event.email, password: event.password);
        } else {
          streamSubscription = authCubit.stream
              .where((state) => state is AuthenticatedUserState)
              .listen((state) =>
                  _updateUserProfile(state as AuthenticatedUserState));
          userCredential = await authenticationRepository.signInWithGoogle();
        }
      } catch (err) {
        Fimber.e("Errore nel log in ");
        emit(ErrorSignInState());
      } finally {
        streamSubscription?.cancel();
      }

      if (userCredential != null) {
        emit(SuccessSignInState(userCredential: userCredential));
      }
    });
  }

  Stream<bool> get areValidCredentials => Rx.combineLatest2(
      emailBinding.stream,
      passwordBinding.stream,
      (_, __) =>
          emailBinding.value != null &&
          emailBinding.value!.isNotEmpty &&
          passwordBinding.value != null &&
          passwordBinding.value!.isNotEmpty);

  @override
  Future<void> close() async {
    await emailBinding.close();
    await passwordBinding.close();
    return super.close();
  }

  void performSignIn({
    String? email,
    String? password,
  }) =>
      add(
        PerformSignInEvent(
            email: email ?? emailBinding.value ?? "",
            password: password ?? passwordBinding.value ?? ""),
      );
  void performSignInWithGoogle() => add(PerformSignInWithGoogleEvent());

  _updateUserProfile(AuthenticatedUserState state) async {
    final user = state.user;
    final firstName = user.firstName;
    final lastName = user.lastName;
    final displayName = "$firstName $lastName";

    await userRepository.create(model.User(
      id: user.uid,
      firstName: firstName,
      lastName: lastName,
      lastAccess: DateTime.now(),
    ));

    await user.updateDisplayName(displayName);
  }
}
