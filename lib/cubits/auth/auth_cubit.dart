import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth firebaseAuth;
  late StreamSubscription<User?> _streamSubscription;

  AuthCubit({required this.firebaseAuth})
      : super(LoadingAuthenticationState()) {
    _streamSubscription = firebaseAuth.userChanges().listen(_onStateChanged);
  }

  void _onStateChanged(User? user) {
    // qualcosa
    if (user == null) {
      emit(NotAuthenticatedState());
      Fimber.d("user not authenticated");
    } else {
      emit(AuthenticatedUserState(user: user));
      Fimber.d("user authenticated as : $user ");
    }
  }

  @override
  Future<void> close() async {
    await _streamSubscription.cancel();
    return super.close();
  }

  void _signOut() => firebaseAuth.signOut();
}
