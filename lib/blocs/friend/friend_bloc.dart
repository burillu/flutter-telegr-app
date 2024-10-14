import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_app/models/friend.dart';
import 'package:telegram_app/repositories/friend_repository.dart';

part 'friend_event.dart';
part 'friend_state.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  final FriendRepository friendRepository;

  FriendBloc({required this.friendRepository}) : super(FetchingFriendsState()) {
    on<FetchFriendEvent>((event, emit) async {
      emit(FetchingFriendsState());

      List<Friend>? friends;
      try {
        friends = await friendRepository.friends(event.uid);
      } catch (e) {
        Fimber.e("${e}errore con l'ottenimento della lista degli amici");
        emit(ErrorFriendState());
      } finally {}

      if (friends != null) {
        emit(friends.isNotEmpty
            ? FetchedFriendsState(friends: friends)
            : NoFriendsState());
      }
    });
  }
  void fetchFriends(String uid) => add(FetchFriendEvent(uid: uid));
}
