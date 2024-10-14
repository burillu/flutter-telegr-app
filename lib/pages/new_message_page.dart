import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telegram_app/widgets/contact_tile.dart';
import 'package:telegram_app/widgets/side_header.dart';

@RoutePage()
class NewMessagePage extends ConnectivityWidget {
  final User user;

  const NewMessagePage({super.key, required this.user});
  @override
  Widget connectedBuild(BuildContext context) => Scaffold(
        appBar: _appBar(context),
        body: _body(context),
      );

  AppBar _appBar(BuildContext context, {bool isSearching = false}) => AppBar(
        title: Text(AppLocalizations.of(context)?.title_new_message ?? ""),
        actions: [
          !isSearching
              ? IconButton(
                  onPressed: () {
                    isSearching = !isSearching;
                  },
                  icon: Icon(Icons.search))
              : Container(),
        ],
      );

  Widget _body(BuildContext context) {
    final friends = <String>[
      "Ignazio",
      "Michele",
      "Giovanni",
      "Lorenzo",
      "Luciano",
      "The Sun",
      "Jovanotti",
      "Paquito",
      "Martin",
      "Miriam",
      "Elisabetta",
      "Debora",
      "Angela",
      "Alberto",
      "Barbara",
      "Bernardo",
      "Bertelli",
      "Chiara",
      "Clara",
      "Jasna",
      "Davide",
      "Don Matteo Crna Gora 24",
      "Francesco",
      "Gabriele",
      "Barsovia",
      "Giovanni",
      "Francesca",
    ];

    //       riordinare in ordine alfabetico
    friends.sort((a, b) => a.toString().compareTo(b.toString()));

    final groupFriends = friends.fold<LinkedHashMap<String, List<String>>>(
        LinkedHashMap(),
        (map, name) =>
            map..putIfAbsent(name.substring(0, 1), () => []).add(name));

    return DefaultStickyHeaderController(
      child: CustomScrollView(
        slivers: groupFriends.values
            .map((friends) => SliverStickyHeader(
                overlapsContent: true,
                header: SideHeader(letter: friends.first.substring(0, 1)),
                sliver: SliverPadding(
                  padding: EdgeInsets.only(left: 60),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) => ContactTile(name: friends[index]),
                        childCount: friends.length),
                  ),
                )))
            .toList(growable: false),
      ),
    );
  }
}
