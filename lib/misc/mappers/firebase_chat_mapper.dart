import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/models/chat.dart';

class FirebaseChatMapper extends FirebaseMapper<Chat> {
  @override
  Chat fromFirebase(Map<String, dynamic> map) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toFirebase(Chat chat) {
    return {
      "last_message": chat.lastMessage,
      "users": chat.user,
      "createdAt": chat.createdAt,
      "updatedAt": chat.updatedAt,
    };
  }
}
