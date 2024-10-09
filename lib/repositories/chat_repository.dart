import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:telegram_app/exceptions/chat_repository_exception.dart';
import 'package:telegram_app/extension/fututre_map.dart';
import 'package:telegram_app/misc/mappers/firebase_chat_mapper.dart';
import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/misc/mappers/firebase_user_mapper.dart';
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

  staticChats(String uid) {
    final chatsList = firebaseFirestore.collection("chats").get().then(
      (querySnapshot) {
        print("Successfully completed");

        final List<Chat> chats = [];
        for (var docSnapshot in querySnapshot.docs) {
          chats.add(firebaseChatMapper.fromFirebase(docSnapshot.data()));
          print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
        return chats;
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  // .where('users',
  //     arrayContainsAny: [firebaseFirestore.collection('users').doc(uid)])
  // .snapshots()
  // .asyncMap(
  //   (snapshot) => snapshot.docs.map<Chat>(
  //     (chatSnapshot) {
  //       final chat = firebaseChatMapper.fromFirebase(chatSnapshot.data());
  //       return chat;
  //     },
  //   ).toList(),
  // );

  Stream<List<Chat>> chats(String uid) => firebaseFirestore
          .collection("chats")
          // .where('users',
          //     arrayContainsAny: [firebaseFirestore.collection('users').doc(uid)])
          .snapshots()
          .asyncMap(
        (snapshot) {
          // print(snapshot.docs);
          return snapshot.docs.futureMap<Chat>(
            (chatSnapshot) async {
              final chat = firebaseChatMapper.fromFirebase(chatSnapshot.data());

              final userReference = (chatSnapshot.data()['users'] as List)
                  .firstWhere((userReference) => userReference.id != uid,
                      orElse: () => null);
              // print("cerco lo snapshot");
              if (userReference == null) {
                //   print("snapshot non Trovato!");
                throw ChatRepositoryException();
              }

              final userSnapshot = await userReference.get();
              // final user = firebaseUserMapper
              //     .fromFirebase(userSnapshot.data())
              // .copyWith(id: userSnapshot.id);
              // if (chat.id == null) throw ChatRepositoryException();

              return chat.copyWith(id: chatSnapshot.id);
            },
          );
        },
      );
}
