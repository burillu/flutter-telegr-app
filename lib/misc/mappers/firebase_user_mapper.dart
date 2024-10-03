import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/models/user.dart';

class FirebaseUserMapper extends FirebaseMapper<User> {
  @override
  fromFirebase(Map<String, dynamic> map) {
    User user = User(firstName: map['firstName'], lastName: map['lastName']);
    return user;
  }

  @override
  Map<String, dynamic> toFirebase(User user) {
    return {
      'first_name': user.firstName,
      'last_name': user.lastName,
      'last_access': user.lastAccess?.millisecondsSinceEpoch,
      'created_at': user.createdAt.millisecondsSinceEpoch,
      'updated_at': user.updatedAt?.millisecondsSinceEpoch,
    };
  }
}
