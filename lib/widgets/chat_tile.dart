import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String? name;
  final String? dateTime;
  final String? urlImageProfile;

  const ChatTile({super.key, this.name, this.dateTime, this.urlImageProfile});

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
        child: urlImageProfile == null ? Text("P N") : null,
      );
  Widget _name(BuildContext context) => Text("Paquito Navarro");

  Widget _lastMessage(BuildContext context) =>
      Text("Ci saresti per una paritita oggi alle 21?");

  Widget _time(BuildContext context) => Text("12:45");
}
