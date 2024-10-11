import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_app/models/chat.dart';
import 'package:telegram_app/repositories/chat_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  final String uid;

  StreamSubscription<List<Chat>>? _streamSubscription;

  ChatCubit({required this.uid, required this.chatRepository})
      : super(FetchingChatState()) {
    // print(uid);
    _streamSubscription = chatRepository.chats(uid).listen(
      (chats) {
        return emit(
            chats.isEmpty ? NoChatState() : FetchedChatState(chats: chats));
      },
      onError: (err) {
        emit(
          ErrorChatState(),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    return super.close();
  }
}
