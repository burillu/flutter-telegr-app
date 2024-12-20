import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegram_app/extension/fututre_map.dart';
import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/models/friend.dart';
import 'package:telegram_app/models/user.dart';

class FriendRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseMapper<Friend> friendMapper;
  final FirebaseMapper<User> userMapper;

  FriendRepository(
      {required this.firebaseFirestore,
      required this.friendMapper,
      required this.userMapper});

  Future<List<Friend>> friends(String uid) async => (await firebaseFirestore
              .collection("friends")
              .where("user", isEqualTo: uid)
              .get())
          .docs
          .futureMap<Friend>((friend) async {
        final userReference =
            friend.data()['friend'] as DocumentReference<Map<String, dynamic>>;
        final userSnapshot = await userReference.get();
        final user = userMapper
            .fromFirebase(userSnapshot.data() ?? {})
            .copyWith(id: userReference.id);
        return friendMapper
            .fromFirebase(friend.data())
            .copyWith(id: friend.id)
            .copyWith(user: user);
      });

  Future<bool> isFriend({required String me, required String user}) async {
    final result = await firebaseFirestore
        .collection("friends")
        .where("user", isEqualTo: me)
        .where("friend",
            isEqualTo: firebaseFirestore.collection("users").doc(user))
        .get();
    return result.size > 0;
  }

  void create({required String me, required String other}) async {
    final user = firebaseFirestore.collection("users").doc(other);
    final friend = {
      "allowed": true,
      "user": me,
      "friend": user,
    };
    await firebaseFirestore.collection("friends").add(friend);
  }
}
