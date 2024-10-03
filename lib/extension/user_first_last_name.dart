import 'package:firebase_auth/firebase_auth.dart';

extension UserFirstLastName on User {
  String get firstName {
    if (displayName == null || displayName!.isEmpty) {
      return "";
    }
    final nameList = displayName!.split(" ");

    if (nameList.length < 1) return "";

    return nameList[0];
  }

  String get lastName {
    if (displayName == null || displayName!.isEmpty) {
      return "";
    }
    final nameList = displayName!.split(" ");
    if (nameList.length <= 1) return "";

    return nameList[1];
  }
}
