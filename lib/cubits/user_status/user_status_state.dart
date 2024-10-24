part of 'user_status_cubit.dart';

sealed class UserStatusState extends Equatable {
  const UserStatusState();

  @override
  List<Object> get props => [];
}

class UpdatedUserStatusState extends UserStatusState {
  final User user;

  const UpdatedUserStatusState({required this.user});

  @override
  List<Object> get props => [user];
}

class ErrorUserStatusState extends UserStatusState {}
