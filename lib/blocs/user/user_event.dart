part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class ResetSearchEvent extends UserEvent {}

class SearchUserEvent extends UserEvent {
  final String query;

  const SearchUserEvent({required this.query});

  @override
  List<Object> get props => [query];
}
