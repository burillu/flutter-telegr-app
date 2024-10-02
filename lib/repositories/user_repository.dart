import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore firebaseFirestore;

  UserRepository({required this.firebaseFirestore});

  Future<void> create() async {
    await firebaseFirestore.collection('users').doc('').set({
      'first_name': '',
      'last_name': '',
      'last_access': '',
      'created_at': '',
      'updated_at': '',
    });
  }
}
