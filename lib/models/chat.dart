import 'package:telegram_app/models/model.dart';
import 'package:telegram_app/models/user.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'chat.g.dart';

@CopyWith()
class Chat extends Model {
  final String lastMessage;
  final User? user;

  Chat(
      {super.id,
      super.createdAt,
      super.updatedAt,
      required this.lastMessage,
      required this.user});

  @override
  List<Object?> get props => [
        ...super.props,
        lastMessage,
        user,
      ];
}
