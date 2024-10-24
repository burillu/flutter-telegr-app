import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
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

  Stream<User> user(String uid) => firebaseFirestore
      .collection("users")
      .doc(uid)
      .snapshots()
      .where((snapshot) => snapshot.exists)
      .asyncMap((userStream) =>
          firebaseUserMapper.fromFirebase(userStream.data() ?? {}));

  Future<List<User>> search(String query) async => (await firebaseFirestore
          .collection("users")
          .where("last_name", isEqualTo: query)
          .get())
      .docs
      .map((snapshot) => firebaseUserMapper
          .fromFirebase(snapshot.data())
          .copyWith(id: snapshot.id))
      .toList(growable: false);
}
