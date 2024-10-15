import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_app/cubits/search_cubit.dart';
import 'package:telegram_app/models/user.dart';
import 'package:telegram_app/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final SearchCubit searchCubit;

  StreamSubscription<String?>? _searchStreamSub;
  StreamSubscription<bool>? _toggleStreamSub;

  Timer? _debounce;

  UserBloc(this.userRepository, this.searchCubit) : super(InitialUserState()) {
    _searchStreamSub = searchCubit.searchBinding.stream
        .where((query) => query != null)
        .listen((query) {
      if (_debounce != null && _debounce!.isActive) _debounce?.cancel();
      _debounce =
          Timer(Duration(milliseconds: 250), () => _searchUsers(query: query!));
    });
    on<SearchUserEvent>((event, emit) async {
      emit(SearchingUserState());

      List<User>? users;

      try {
        users = await userRepository.search(event.query);
      } catch (e) {
        Fimber.e("$e Errore nella ricerca degli utenti");
        emit(ErrorUserState());
      }

      if (users != null) {
        emit(users.isNotEmpty ? FetchedUserState(users: users) : NoUserState());
      }
    });

    on<ResetSearchEvent>((event, emit) => emit(InitialUserState()));
  }

  void _searchUsers({required String query}) =>
      add(SearchUserEvent(query: query));

  void _reset() => add(ResetSearchEvent());

  @override
  Future<void> close() async {
    await _searchStreamSub?.cancel();
    await _toggleStreamSub?.cancel();

    return super.close();
  }
}
