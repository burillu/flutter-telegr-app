import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension UserDisplayNameInitials on User {
  String get displayNameInitials {
    if (displayName == null || displayName!.isEmpty) {
      final emailSplit = email!.split("@");
      String defaultDisplayName =
          "${emailSplit[0].substring(0, 1).toUpperCase()} ${emailSplit[1].substring(0, 1).toUpperCase()}";
      return defaultDisplayName;
    }
    final nameList = displayName!.split(" ");
    String initialsName = nameList[0].substring(0, 1).toUpperCase();
    if (nameList.length > 1) {
      initialsName += " ${nameList[1].substring(0, 1).toUpperCase()}";
    }
    return initialsName;
  }
}
