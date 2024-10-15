import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telegram_app/blocs/friend/friend_bloc.dart';
import 'package:telegram_app/models/friend.dart';
import 'package:telegram_app/pages/chat_error_page.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telegram_app/widgets/contact_tile.dart';
import 'package:telegram_app/widgets/shimmed_list.dart';
import 'package:telegram_app/widgets/side_header.dart';

@RoutePage()
class NewMessagePage extends ConnectivityWidget implements AutoRouteWrapper {
  final User user;

  const NewMessagePage({super.key, required this.user});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider<FriendBloc>(
            create: (context) => FriendBloc(friendRepository: context.read())
              ..fetchFriends(user.uid)),
      ], child: this);
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
    return BlocBuilder<FriendBloc, FriendState>(builder: (context, state) {
      if (state is FetchedFriendsState) {
        return _listFriend(context, friends: state.friends);
      } else if (state is NoFriendsState) {
        return _emptyFriendList(context);
      } else if (state is ErrorFriendState) {
        return _errorFriendList(context);
      }

      return _shimmedItems(context);
    });
  }

  Widget _listFriend(BuildContext context, {required List<Friend> friends}) {
    // final friends = <String>[
    //   "Ignazio",
    //   "Michele",
    //   "Giovanni",
    //   "Lorenzo",
    //   "Luciano",
    //   "The Sun",
    //   "Jovanotti",
    //   "Paquito",
    //   "Martin",
    //   "Miriam",
    //   "Elisabetta",
    //   "Debora",
    //   "Angela",
    //   "Alberto",
    //   "Barbara",
    //   "Bernardo",
    //   "Bertelli",
    //   "Chiara",
    //   "Clara",
    //   "Jasna",
    //   "Davide",
    //   "Don Matteo Crna Gora 24",
    //   "Francesco",
    //   "Gabriele",
    //   "Barsovia",
    //   "Giovanni",
    //   "Francesca",
    // ];

    //       riordinare in ordine alfabetico
    // friends.sort((a, b) => a.toString().compareTo(b.toString()));

    final groupFriends = friends.fold<LinkedHashMap<String, List<Friend>>>(
        LinkedHashMap(),
        (map, friend) =>
            map..putIfAbsent(friend.user!.firstLetter, () => []).add(friend));

    return DefaultStickyHeaderController(
      child: CustomScrollView(
        slivers: groupFriends.values
            .map((friends) => SliverStickyHeader(
                overlapsContent: true,
                header: SideHeader(letter: friends.first.user!.firstLetter),
                sliver: SliverPadding(
                  padding: EdgeInsets.only(left: 60),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            ContactTile(user: friends[index].user),
                        childCount: friends.length),
                  ),
                )))
            .toList(growable: false),
      ),
    );
  }

  Widget _emptyFriendList(BuildContext context) => ChatErrorPage(
        icon: Icon(
          FontAwesomeIcons.userFriends,
          size: 128,
          color: Colors.grey,
        ),
        title: AppLocalizations.of(context)?.title_empty_friends_list ?? "",
        subtitle: AppLocalizations.of(context)?.label_empty_friends_sub ?? "",
      );
  Widget _errorFriendList(BuildContext context) => ChatErrorPage(
        icon: Icon(
          FontAwesomeIcons.userFriends,
          size: 128,
          color: Colors.grey,
        ),
        title: AppLocalizations.of(context)?.title_error_friends_list ?? "",
        subtitle: AppLocalizations.of(context)?.label_error_friends_sub ?? "",
      );
  Widget _shimmedItems(BuildContext context) => ShimmedList(child: Container());
}
