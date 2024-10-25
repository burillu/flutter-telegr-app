import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_app/repositories/friend_repository.dart';

part 'friend_status_event.dart';
part 'friend_status_state.dart';

class FriendStatusBloc extends Bloc<FriendStatusEvent, FriendStatusState> {
  final FriendRepository friendRepository;

  FriendStatusBloc({required this.friendRepository})
      : super(FetchingFriendStatus()) {
    on<FetchFriendStatusEvent>((event, emit) async {
      emit(FetchingFriendStatus());

      bool? isFriend;
      try {
        isFriend =
            await friendRepository.isFriend(me: event.me, user: event.user);
      } catch (e) {
        Fimber.e("${e}Errore con l'ottenimento dello status di amicizia");
        emit(ErrorFriendsStatus());
      }
      if (isFriend != null) emit(FetchedFriendStatus(isFriend: isFriend));
    });

    on<CreateFriendshipEvent>(
      (event, emit) async {
        emit(FetchingFriendStatus());
        try {
          friendRepository.create(me: event.me, other: event.other);
        } catch (e) {
          Fimber.e("$e | Errore con la creazione della nuova amicizia");
          emit(ErrorFriendsStatus());
        }
      },
    );
  }

  void fetchStatus({required String me, required String user}) =>
      add(FetchFriendStatusEvent(me: me, user: user));

  void createFriendship({required String me, required String other}) =>
      add(CreateFriendshipEvent(me: me, other: other));
}
