part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class InitialUserState extends UserState {}

class SearchingUserState extends UserState {}

class FetchedUserState extends UserState {
  final List<User> users;

  const FetchedUserState({required this.users});

  @override
  List<Object> get props => [users];
}

class NoUserState extends UserState {}

class ErrorUserState extends UserState {}
