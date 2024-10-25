part of 'friend_status_bloc.dart';

sealed class FriendStatusEvent extends Equatable {
  const FriendStatusEvent();

  @override
  List<Object> get props => [];
}

class FetchFriendStatusEvent extends FriendStatusEvent {
  final String me;
  final String user;

  const FetchFriendStatusEvent({required this.me, required this.user});

  @override
  List<Object> get props => [me, user];
}

class CreateFriendshipEvent extends FriendStatusEvent {
  final String me;
  final String other;

  const CreateFriendshipEvent({required this.me, required this.other});

  @override
  List<Object> get props => [me, other];
}
