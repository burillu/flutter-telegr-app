import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telegram_app/exceptions/chat_repository_exception.dart';
import 'package:telegram_app/extension/fututre_map.dart';
import 'package:telegram_app/misc/mappers/firebase_chat_mapper.dart';
// import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/misc/mappers/firebase_user_mapper.dart';
import 'package:telegram_app/models/chat.dart';
import 'package:telegram_app/models/user.dart';

class ChatRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseChatMapper firebaseChatMapper;
  final FirebaseUserMapper firebaseUserMapper;

  ChatRepository(
      {required this.firebaseUserMapper,
      required this.firebaseChatMapper,
      required this.firebaseFirestore});

  // List<Chat> staticChats(String uid) => ;

  Stream<List<Chat>> chats(String uid) => firebaseFirestore
      .collection("chats")
      .where('users',
          arrayContainsAny: [firebaseFirestore.collection('users').doc(uid)])
      .snapshots()
      .asyncMap(
          (snapshot) => snapshot.docs.futureMap<Chat>((chatSnapshot) async {
                final chat =
                    firebaseChatMapper.fromFirebase(chatSnapshot.data());
                final userReference = (chatSnapshot.data()['users'] as List)
                    .firstWhere((userReference) => userReference.id != uid,
                        orElse: () => null);
                if (userReference == null) {
                  throw ChatRepositoryException();
                }

                final userSnapshot = await userReference.get();
                final user = firebaseUserMapper
                    .fromFirebase(userSnapshot)
                    .copyWith(id: userSnapshot.id);
                // if (chat.id == null) throw ChatRepositoryException();

                return chat.copyWith(user: user, id: chatSnapshot.id);
              }));
}
