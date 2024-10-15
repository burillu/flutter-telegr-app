import 'package:telegram_app/models/model.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'user.g.dart';

@CopyWith()
class User extends Model {
  final String firstName;
  final String lastName;
  final DateTime? lastAccess;

  User(
      {super.id,
      super.createdAt,
      super.updatedAt,
      required this.firstName,
      required this.lastName,
      this.lastAccess});

  @override
  List<Object?> get props => [
        ...super.props,
        firstName,
        lastName,
        lastAccess,
      ];

  String get displayName => "$firstName $lastName";

  String get initials =>
      "${firstName.substring(0, 1).toUpperCase()} ${lastName.substring(0, 1).toUpperCase()}";
  String get firstLetter => firstName.substring(0, 1);
}
