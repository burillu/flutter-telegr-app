import 'package:telegram_app/models/model.dart';

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
  // TODO: implement props
  List<Object?> get props => [
        ...super.props,
        firstName,
        lastName,
        lastAccess,
      ];
}
