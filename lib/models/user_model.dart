import 'package:telegram_app/models/model.dart';

class UserModel extends Model {
  final String firstName;
  final String lastName;
  final DateTime lastAccess;

  UserModel(
      {String? id,
      DateTime? createdAt,
      DateTime? updatedAt,
      required this.firstName,
      required this.lastName,
      required this.lastAccess})
      : super(id: id, createdAt: createdAt, updatedAt: updatedAt);
}
