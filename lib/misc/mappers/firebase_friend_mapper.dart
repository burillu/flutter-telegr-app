import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/models/friend.dart';

class FirebaseFriendMapper extends FirebaseMapper<Friend> {
  @override
  Friend fromFirebase(Map<String, dynamic> map) => Friend(
        allowed: map['allowed'],
        user: map['friend'],
        createdAt: map['createdAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
            : null,
        updatedAt: map['updatedAt'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
            : null,
      );

  @override
  Map<String, dynamic> toFirebase(Friend object) => {
        'allowed': object.allowed,
        'user': object.user,
      };
}
