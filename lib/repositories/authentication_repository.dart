import 'package:fimber/fimber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:telegram_app/exceptions/sign_in_canceled_exceptions.dart';
import 'package:telegram_app/exceptions/wrong_credential_exception.dart';

class AuthenticationRepository {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthenticationRepository(
      {required this.firebaseAuth, required this.googleSignIn});

  Future<UserCredential> signIn(
      {required String email, required String password}) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fimber.e('No user found for this email. Error message: ${e.message}');
      } else if (e.code == 'wrong-password') {
        Fimber.e(
            'Wrong password provided for this user. Error message: ${e.message}');
      }
      throw WrongCredentialException();
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await firebaseAuth.signInWithCredential(credentials);
    }
    throw SignInCanceledExceptions();
  }
}
