part of 'friend_bloc.dart';

sealed class FriendEvent extends Equatable {
  const FriendEvent();

  @override
  List<Object> get props => [];
}

class FetchFriendEvent extends FriendEvent {
  final String uid;

  const FetchFriendEvent({required this.uid});
  @override
  List<Object> get props => [uid];
}
