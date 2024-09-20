part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class LoadingAuthenticationState extends AuthState {}

class AuthenticatedUserState extends AuthState {
  final User user;

  const AuthenticatedUserState({required this.user});

  @override
  List<Object?> get props => [user];
}

class NotAuthenticatedState extends AuthState {}
