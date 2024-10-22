import 'package:flutter/material.dart';
import 'package:telegram_app/models/user.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactTile extends StatelessWidget {
  final User? user;
  final VoidCallback? onTap;

  const ContactTile({super.key, this.user, this.onTap});

  factory ContactTile.shimmed() => ContactTile(
        user: null,
      );

  @override
  Widget build(BuildContext context) => ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            user != null ? user!.initials : "##",
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(user != null ? user!.displayName : "User Name"),
        trailing: Text(user != null && user?.lastAccess != null
            ? timeago.format(
                locale: AppLocalizations.of(context)?.localeName,
                user!.lastAccess!)
            : AppLocalizations.of(context)?.label_last_access ?? ""),
        onTap: onTap,
      );
}
