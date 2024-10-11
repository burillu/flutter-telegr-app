part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class FetchingChatState extends ChatState {}

final class FetchedChatState extends ChatState {
  final List<Chat> chats;

  const FetchedChatState({required this.chats});

  @override
  List<Object> get props => [chats];
}

final class NoChatState extends ChatState {}

final class ErrorChatState extends ChatState {}
