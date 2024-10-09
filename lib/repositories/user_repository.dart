import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
// import 'package:telegram_app/misc/mappers/firebase_user_mapper.dart';
import 'package:telegram_app/models/user.dart';

class UserRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseMapper<User> firebaseUserMapper;

  UserRepository(
      {required this.firebaseFirestore, required this.firebaseUserMapper});

  Future<void> create(User user) async {
    await firebaseFirestore
        .collection('users')
        .doc(user.id)
        .set(firebaseUserMapper.toFirebase(user));
  }
}
