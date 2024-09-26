part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

final class InitialSignUpState extends SignUpState {}

class SigningUpState extends SignUpState {}

class SuccessSignUpState extends SignUpState {
  final UserCredential userCredential;

  const SuccessSignUpState({required this.userCredential});

  @override
  List<Object> get props => [userCredential];
}

class ErrorSignUpState extends SignUpState {}
