import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/models/chat.dart';

class FirebaseChatMapper extends FirebaseMapper<Chat> {
  @override
  Chat fromFirebase(Map<String, dynamic> map) {
    return Chat(
        lastMessage: map['last_message'],
        // users: map['users'],
        createdAt: map['created_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['created_at'])
            : null,
        updatedAt: map['updated_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
            : null);
  }

  @override
  Map<String, dynamic> toFirebase(Chat object) {
    return {
      "last_message": object.lastMessage,
      "users": object.user,
      "created_at": object.createdAt,
      "updated_at": object.updatedAt,
    };
  }
}
