import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telegram_app/models/user.dart' as models;
import 'package:telegram_app/widgets/connectivity_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

@RoutePage()
class ChatPage extends ConnectivityWidget {
  final User user;
  final models.User other;

  const ChatPage({super.key, required this.user, required this.other});

  @override
  Widget connectedBuild(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: ListTile(
            leading: CircleAvatar(child: Text(other.initials)),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  other.displayName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  timeago.format(
                      other.lastAccess != null
                          ? other.lastAccess!
                          : DateTime.now(),
                      locale: AppLocalizations.of(context)?.localeName),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          actions: [],
        ),
        body: Column(
          children: [
            Center(
              child: Text("Chat Page"),
            ),
          ],
        ),
      );
}
