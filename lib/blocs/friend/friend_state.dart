part of 'friend_bloc.dart';

sealed class FriendState extends Equatable {
  const FriendState();

  @override
  List<Object> get props => [];
}

final class FetchingFriendsState extends FriendState {}

class FetchedFriendsState extends FriendState {
  final List<Friend> friends;

  const FetchedFriendsState({required this.friends});

  @override
  List<Object> get props => [friends];
}

class NoFriendsState extends FriendState {}

class ErrorFriendState extends FriendState {}
