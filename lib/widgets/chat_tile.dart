import 'package:flutter/material.dart';
import 'package:telegram_app/models/chat.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatTile extends StatelessWidget {
  final String? name;
  final String? dateTime;
  final String? urlImageProfile;
  final Chat? chat;

  const ChatTile(
      {super.key, this.name, this.dateTime, this.urlImageProfile, this.chat});

  factory ChatTile.shimmed() => ChatTile(chat: null);

  @override
  Widget build(BuildContext context) => ListTile(
        title: _name(context),
        leading: _avatar(context),
        subtitle: _lastMessage(context),
        trailing: _time(context),
      );

  Widget _avatar(BuildContext context) => CircleAvatar(
      radius: 40,
      backgroundImage: urlImageProfile != null
          ? NetworkImage(
              urlImageProfile!,
            )
          : null,
      child: urlImageProfile == null
          ? Text(chat != null ? chat!.user?.initials ?? "" : "")
          : Text(""));
  Widget _name(BuildContext context) =>
      Text(chat != null ? chat!.user?.displayName ?? "" : "");

  Widget _lastMessage(BuildContext context) =>
      Text("${chat?.lastMessage.substring(0, 20)}...");

  Widget _time(BuildContext context) => Text(
        chat != null
            ? timeago.format(
                locale: AppLocalizations.of(context)?.localeName,
                chat!.updatedAt ?? chat!.createdAt)
            : "",
      );
}
