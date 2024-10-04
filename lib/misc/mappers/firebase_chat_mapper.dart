import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/models/chat.dart';

class FirebaseChatMapper extends FirebaseMapper<Chat> {
  @override
  Chat fromFirebase(Map<String, dynamic> map) {
    return Chat(
        lastMessage: map['last_message'],
        createdAt: map['created_at'] != null
            ? DateTime.fromMicrosecondsSinceEpoch(map['created_at'])
            : null,
        updatedAt: map['updated_at'] != null
            ? DateTime.fromMicrosecondsSinceEpoch(map['updated_at'])
            : null);
  }

  @override
  Map<String, dynamic> toFirebase(Chat chat) {
    return {
      "last_message": chat.lastMessage,
      "users": chat.user,
      "created_at": chat.createdAt,
      "updated_at": chat.updatedAt,
    };
  }
}
