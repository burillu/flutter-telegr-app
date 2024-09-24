part of 'sign_in_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class InitialSignInState extends SignInState {}

class SigningInState extends SignInState {}

class SuccessSignInState extends SignInState {
  final UserCredential userCredential;

  const SuccessSignInState({required this.userCredential});

  @override
  List<Object> get props => [userCredential];
}

class ErrorSignInState extends SignInState {}
