import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/misc/two_way_binding.dart';
import 'package:telegram_app/blocs/friend_status/friend_status_bloc.dart';
import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/models/chat.dart';
import 'package:telegram_app/repositories/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final FirebaseMapper<Chat> chatMapper;
  final FriendStatusBloc friendStatusBloc;

  final TwoWayBinding messageBinding = TwoWayBinding<String>();

  ChatBloc(
      {required this.chatRepository,
      required this.chatMapper,
      required this.friendStatusBloc})
      : super(FetchingChatState()) {
    on<ChatEvent>((event, emit) {
      emit(FetchingChatState());
    });

    on<FindChatEvent>((event, emit) => _mapFindChatEventToState(event, emit));

    on<SendMessageEvent>(
        (event, emit) => _mapSendMessageEventToState(event, emit));

    on<CreateChatEvent>(
        (event, emit) => _mapCreateChatEventToState(event, emit));
  }

  void _mapSendMessageEventToState(SendMessageEvent event, Emitter emit) async {
    try {
      if (!friendStatusBloc.friends) {
        friendStatusBloc.createFriendship(me: event.me, other: event.other);
      }
      await chatRepository.update(chat: event.chat, message: event.message);
    } catch (e) {
      Fimber.e("$e Errore con l'invio del messaggio");
      emit(ErrorChatState());
    }
  }

  void _mapCreateChatEventToState(CreateChatEvent event, Emitter emit) async {
    Chat? chat;
    try {
      chat = await chatRepository.create(
          me: event.me, other: event.other, message: event.message);
    } catch (e) {
      Fimber.e("$e Errore con la creazione della chat");
      emit(ErrorChatState());
    }

    if (chat != null) {
      add(SendMessageEvent(
          chat: chat.id!,
          message: event.message,
          me: event.me,
          other: event.other));
      emit(ChatAvailableState(chat: chat));
    }
  }

  void _mapFindChatEventToState(FindChatEvent event, Emitter emit) async {
    emit(FetchingChatState());
    List<Chat>? chats;
    try {
      chats = await chatRepository.find(me: event.me, other: event.other);
    } catch (e) {
      Fimber.e("$e Errore nella ricerca delle chat");
      emit(ErrorChatState());
    }
    if (chats != null) {
      if (chats.length == 1) {
        emit(ChatAvailableState(chat: chats.first));
      } else {
        Fimber.e(
            " Errore, sono risultate nr. ${chats.length.toString()} chat ");
        emit(ErrorChatState());
      }
    }
  }

  void findChat({required String me, required String other}) =>
      add(FindChatEvent(me: me, other: other));

  void sendMessage(
      {required String me,
      required String other,
      String? chat,
      String? message}) {
    add((state is ChatAvailableState)
        ? SendMessageEvent(
            chat: chat ?? (state as ChatAvailableState).chat.id!,
            message: message ?? messageBinding.value ?? " ",
            me: me,
            other: other)
        : CreateChatEvent(
            message: message ?? messageBinding.value ?? "",
            me: me,
            other: other));

    messageBinding.value = "";
  }

  @override
  Future<void> close() async {
    await messageBinding.close();
    return super.close();
  }
}
