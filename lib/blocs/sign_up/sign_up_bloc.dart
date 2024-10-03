import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:rxdart/rxdart.dart';
import 'package:telegram_app/cubits/auth/auth_cubit.dart';
import 'package:telegram_app/repositories/authentication_repository.dart';
import 'package:telegram_app/repositories/user_repository.dart';
import 'package:telegram_app/models/user.dart' as model;

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationRepository authenticationRepository;
  final AuthCubit authCubit;
  final UserRepository userRepository;

  final firstNameBinding = TwoWayBinding<String>().bindDataRule(RequiredRule());
  final lastNameBinding = TwoWayBinding<String>().bindDataRule(RequiredRule());
  final emailBinding = TwoWayBinding<String>()
      .bindDataRule(RequiredRule())
      .bindDataRule(EmailRule());
  final passwordBinding = TwoWayBinding<String>().bindDataRule(RequiredRule());
  final confirmEmailBinding = TwoWayBinding<String>()
      .bindDataRule(RequiredRule())
      .bindDataRule(EmailRule());
  final confirmPasswordBinding =
      TwoWayBinding<String>().bindDataRule(RequiredRule());

  SignUpBloc(
      {required this.authenticationRepository,
      required this.authCubit,
      required this.userRepository})
      : super(InitialSignUpState()) {
    confirmEmailBinding.bindDataRule2(emailBinding, SameRule());
    confirmPasswordBinding.bindDataRule2(passwordBinding, SameRule());

    on<SignUpEvent>((event, emit) async {
      if (event is PerformSignUpEvent) {
        emit(SigningUpState());
        final authSubscription = authCubit.stream
            .where((state) => state is AuthenticatedUserState)
            .listen((state) => _updateUserProfile(event,
                state: (state as AuthenticatedUserState)));

        UserCredential? userCredential;

        try {
          userCredential = await authenticationRepository.signUp(
              email: event.email, password: event.password);
        } catch (e) {
          Fimber.e("errore con le credenziali fornite");
          emit(ErrorSignUpState());
        } finally {
          authSubscription.cancel();
        }
        if (userCredential != null) {
          emit(SuccessSignUpState(userCredential: userCredential));
        }
      }
    });
  }

  void _updateUserProfile(PerformSignUpEvent event,
      {required AuthenticatedUserState state}) async {
    final user = state.user;
    final firstName = event.firstName;
    final lastName = event.lastName;
    final displayName = "$firstName $lastName";

    await userRepository.create(model.User(
      id: user.uid,
      firstName: firstName,
      lastName: lastName,
      lastAccess: DateTime.now(),
    ));

    await user.updateDisplayName(displayName);
  }

  Stream<bool> get areValidCredentials => Rx.combineLatest(
          [
            firstNameBinding.stream,
            lastNameBinding.stream,
            emailBinding.stream,
            confirmEmailBinding.stream,
            passwordBinding.stream,
            confirmPasswordBinding.stream,
          ],
          (_) =>
              firstNameBinding.value != null &&
              firstNameBinding.value!.isNotEmpty &&
              lastNameBinding.value != null &&
              lastNameBinding.value!.isNotEmpty &&
              emailBinding.value != null &&
              emailBinding.value!.isNotEmpty &&
              confirmEmailBinding.value != null &&
              confirmEmailBinding.value!.isNotEmpty &&
              passwordBinding.value != null &&
              passwordBinding.value!.isNotEmpty &&
              confirmPasswordBinding.value != null &&
              confirmPasswordBinding.value!.isNotEmpty);
  @override
  Future<void> close() async {
    await firstNameBinding.close();
    await lastNameBinding.close();
    await emailBinding.close();
    await confirmEmailBinding.close();
    await passwordBinding.close();
    await confirmPasswordBinding.close();

    return super.close();
  }

  void performSignUp({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
  }) =>
      add(
        PerformSignUpEvent(
            firstName: firstName ?? firstNameBinding.value ?? '',
            lastName: lastName ?? lastNameBinding.value ?? '',
            email: email ?? emailBinding.value ?? '',
            password: password ?? passwordBinding.value ?? ''),
      );
}
