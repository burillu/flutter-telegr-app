part of 'friend_status_bloc.dart';

sealed class FriendStatusState extends Equatable {
  const FriendStatusState();

  @override
  List<Object> get props => [];
}

final class FetchingFriendStatus extends FriendStatusState {}

class FetchedFriendStatus extends FriendStatusState {
  final bool isFriend;

  const FetchedFriendStatus({required this.isFriend});

  @override
  List<Object> get props => [isFriend];
}

class ErrorFriendsStatus extends FriendStatusState {}
