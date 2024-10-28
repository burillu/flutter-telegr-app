import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegram_app/exceptions/chat_repository_exception.dart';
import 'package:telegram_app/extension/fututre_map.dart';
import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/models/chat.dart';
import 'package:telegram_app/models/user.dart';

class ChatRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseMapper<Chat> firebaseChatMapper;
  final FirebaseMapper<User> firebaseUserMapper;

  ChatRepository(
      {required this.firebaseUserMapper,
      required this.firebaseChatMapper,
      required this.firebaseFirestore});

  Stream<List<Chat>> chats(String uid) => firebaseFirestore
      .collection("chats")
      .where('users',
          arrayContainsAny: [firebaseFirestore.collection('users').doc(uid)])
      .snapshots()
      .asyncMap(
        (snapshot) {
          // print(snapshot.docs);
          return snapshot.docs.futureMap<Chat>(
            (chatSnapshot) async {
              final chat = firebaseChatMapper.fromFirebase(chatSnapshot.data());

              final userReference =
                  (chatSnapshot.data()['users'] as List).firstWhere((user) {
                return user.id != uid;
              }, orElse: () => null);
              if (userReference == null) {
                throw ChatRepositoryException();
              }

              final userSnapshot = await userReference.get();
              final user = firebaseUserMapper
                  .fromFirebase(userSnapshot.data())
                  .copyWith(id: userSnapshot.id);

              return chat.copyWith(user: user, id: chatSnapshot.id);
            },
          );
        },
      );

  Future<Chat> create({
    required String me,
    required String other,
    required String message,
  }) async {
    final users = [me, other]..sort();

    final List<DocumentReference> references =
        users.map<DocumentReference>((uid) {
      final userRef = firebaseFirestore.collection("users").doc(uid);
      return userRef;
    }).toList(growable: false);

    final insert = (await firebaseFirestore.collection("chats").add({
      "last_message": message,
      "created_at": DateTime.now().millisecondsSinceEpoch,
      "users": references,
      "update_at": null
    }));

    final chatMapped = await insert.get();
    final chat = firebaseChatMapper.fromFirebase(chatMapped.data() ?? {});

    final userReference =
        ((chatMapped.data() ?? {"users": []})["users"] as List)
            .firstWhere((ref) => ref.id != me, orElse: () => null);

    if (userReference == null) {
      throw ChatRepositoryException();
    }

    final userMapped = userReference.get();
    final user = firebaseUserMapper
        .fromFirebase(userMapped.data ?? {})
        .copyWith(id: userReference.id);
    return chat.copyWith(user: user, id: chatMapped.id);
  }

  Future<List<Chat>> find({
    required String me,
    required String other,
  }) async {
    final users = [me, other]..sort();

    final List<DocumentReference> references =
        users.map<DocumentReference>((uid) {
      final userRef = firebaseFirestore.collection("users").doc(uid);
      return userRef;
    }).toList(growable: false);

    final chatRef = await firebaseFirestore
        .collection("chats")
        .where("users", isEqualTo: references)
        .get();

    return chatRef.docs.futureMap<Chat>((snapshot) async {
      final chat = firebaseChatMapper.fromFirebase(snapshot.data());

      final userReference =
          (snapshot.data()['users'] as List).firstWhere((user) {
        return user.id != me;
      }, orElse: () => null);
      if (userReference == null) {
        throw ChatRepositoryException();
      }

      final userSnapshot = await userReference.get();
      final user = firebaseUserMapper
          .fromFirebase(userSnapshot.data())
          .copyWith(id: userSnapshot.id);

      return chat.copyWith(user: user, id: snapshot.id);
    });
  }
}
