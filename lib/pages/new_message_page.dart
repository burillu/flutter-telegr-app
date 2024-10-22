import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telegram_app/blocs/friend/friend_bloc.dart';
import 'package:telegram_app/blocs/user/user_bloc.dart';
import 'package:telegram_app/cubits/search_cubit.dart';
import 'package:telegram_app/mixin/search_components_mixin.dart';
import 'package:telegram_app/models/friend.dart';
import 'package:telegram_app/models/user.dart' as models;
import 'package:telegram_app/pages/chat_error_page.dart';
import 'package:telegram_app/router/app_router.gr.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telegram_app/widgets/contact_tile.dart';
import 'package:telegram_app/widgets/shimmed_list.dart';
import 'package:telegram_app/widgets/side_header.dart';

@RoutePage()
class NewMessagePage extends ConnectivityWidget
    with SearchComponentsMixin
    implements AutoRouteWrapper {
  final User user;

  const NewMessagePage({super.key, required this.user});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider<SearchCubit>(create: (_) => SearchCubit()),
        BlocProvider<FriendBloc>(
            create: (context) => FriendBloc(friendRepository: context.read())
              ..fetchFriends(user.uid)),
        BlocProvider<UserBloc>(
            create: (context) => UserBloc(
                searchCubit: context.read(), userRepository: context.read()))
      ], child: this);
  @override
  Widget connectedBuild(BuildContext context) => BlocBuilder<SearchCubit, bool>(
        builder: (context, isSearching) {
          return Scaffold(
            appBar: _appBar(context, isSearching: isSearching),
            body: _body(context),
          );
        },
      );

  AppBar _appBar(BuildContext context, {bool isSearching = false}) => AppBar(
        leading: BackButton(
          onPressed: () => isSearching
              ? context.read<SearchCubit>().toggle()
              : context.router.popForced(),
        ),
        title: isSearching
            ? searchField(context)
            : Text(AppLocalizations.of(context)?.title_new_message ?? ""),
        actions: [
          !isSearching
              ? IconButton(
                  onPressed: () {
                    context.read<SearchCubit>().toggle();
                    // isSearching = !isSearching;
                  },
                  icon: Icon(Icons.search))
              : Container(),
        ],
      );

  // Widget _searchField(BuildContext context) => TwoWayBindingBuilder<String>(
  //     binding: context.watch<SearchCubit>().searchBinding,
  //     builder: (
  //       context,
  //       controller,
  //       data,
  //       onChanged,
  //       error,
  //     ) =>
  //         TextField(
  //           // cursorHeight: 20,
  //           controller: controller,
  //           onChanged: onChanged,
  //           keyboardType: TextInputType.text,
  //           decoration: InputDecoration(
  //               border: InputBorder.none,
  //               hintText: AppLocalizations.of(context)?.label_search ?? "",
  //               error: Text(error?.localizedString(context) ?? "")),
  //         ));
  Widget _body(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is InitialUserState) {
        return _bodyFirends(context);
      } else if (state is NoUserState) {
        return _noUserFeed(context);
      } else if (state is ErrorUserState) {
        return _errorUserFeed(context);
      } else if (state is FetchedUserState) {
        return _filteredFriends(context, users: state.users);
      }
      return _shimmedItems(context);
    });
  }

  Widget _bodyFirends(BuildContext context) {
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

  Widget _noUserFeed(BuildContext context) => ChatErrorPage(
        icon: Icon(
          FontAwesomeIcons.search,
          size: 128,
          color: Colors.grey,
        ),
        title: AppLocalizations.of(context)?.title_empty_user_search ?? "",
        subtitle:
            AppLocalizations.of(context)?.label_empty_user_search_sub ?? "",
      );
  Widget _errorUserFeed(BuildContext context) => ChatErrorPage(
        icon: Icon(
          FontAwesomeIcons.search,
          size: 128,
          color: Colors.grey,
        ),
        title: AppLocalizations.of(context)?.title_error_user_search ?? "",
        subtitle:
            AppLocalizations.of(context)?.label_error_user_search_sub ?? "",
      );

  Widget _filteredFriends(BuildContext context,
          {required List<models.User> users}) =>
      ListView.builder(
        itemBuilder: (_, index) => ContactTile(
          onTap: () => context.router
              .popAndPush(ChatRoute(user: user, other: users[index])),
          user: users[index],
        ),
        itemCount: users.length,
      );
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
                        (context, index) => ContactTile(
                              user: friends[index].user,
                              onTap: () => context.router.popAndPush(ChatRoute(
                                  user: user, other: friends[index].user!)),
                            ),
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
