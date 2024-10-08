import 'package:telegram_app/misc/mappers/firebase_mapper.dart';
import 'package:telegram_app/models/user.dart';

class FirebaseUserMapper extends FirebaseMapper<User> {
  @override
  fromFirebase(Map<String, dynamic> map) {
    User user = User(
      firstName: map['first_name'],
      lastName: map['last_name'],
      lastAccess: map['last_access'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_access'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['created_at'])
          : null,
    );
    return user;
  }

  @override
  Map<String, dynamic> toFirebase(User object) {
    return {
      'first_name': object.firstName,
      'last_name': object.lastName,
      'last_access': object.lastAccess?.millisecondsSinceEpoch,
      'created_at': object.createdAt.millisecondsSinceEpoch,
      'updated_at': object.updatedAt?.millisecondsSinceEpoch,
    };
  }
}
