import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_app/models/user.dart';
import 'package:telegram_app/repositories/user_repository.dart';

part 'user_status_state.dart';

class UserStatusCubit extends Cubit<UserStatusState> {
  final UserRepository userRepository;
  final User user;

  StreamSubscription<User>? _streamUser;

  UserStatusCubit({required this.userRepository, required this.user})
      : super(UpdatedUserStatusState(user: user)) {
    _streamUser = userRepository.user(user.id!).listen(
          (user) => emit(UpdatedUserStatusState(user: user)),
          onError: (_) => emit(ErrorUserStatusState()),
        );
  }

  @override
  Future<void> close() async {
    await _streamUser?.cancel();
    return super.close();
  }
}
