part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class FetchingChatState extends ChatState {}

class ChatAvailableState extends ChatState {
  final Chat chat;

  const ChatAvailableState({required this.chat});

  @override
  List<Object> get props => [chat];
}

class NoChatAvailableState extends ChatState {}

class ErrorChatState extends ChatState {}
