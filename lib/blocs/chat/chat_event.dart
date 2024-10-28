part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class FindChatEvent extends ChatEvent {
  final String me;
  final String other;

  const FindChatEvent({required this.me, required this.other});
  @override
  List<Object> get props => [me, other];
}

class CreateChatEvent extends FindChatEvent {
  final String message;
  const CreateChatEvent(
      {required this.message, required super.me, required super.other});
  @override
  List<Object> get props => [...super.props, message];
}

class SendMessageEvent extends CreateChatEvent {
  final String chat;
  const SendMessageEvent(
      {required this.chat,
      required super.message,
      required super.me,
      required super.other});

  @override
  List<Object> get props => [...super.props, chat];
}
