import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telegram_app/cubits/auth/auth_cubit.dart';
import 'package:telegram_app/cubits/chat/chat_cubit.dart';
import 'package:telegram_app/cubits/scroll_cubit.dart';
import 'package:telegram_app/cubits/search_cubit.dart';
import 'package:telegram_app/extension/user_display_name_initials.dart';
import 'package:telegram_app/mixin/search_components_mixin.dart';
import 'package:telegram_app/models/chat.dart';
import 'package:telegram_app/pages/chat_error_page.dart';
import 'package:telegram_app/router/app_router.gr.dart';
import 'package:telegram_app/widgets/chat_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telegram_app/widgets/shimmed_list.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, SearchComponentsMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
      reverseDuration: Duration(milliseconds: 250),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider<ScrollCubit>(
              create: (_) => ScrollCubit(),
            ),
            BlocProvider<ChatCubit>(
              create: (context) => ChatCubit(
                  uid: widget.user.uid, chatRepository: context.read()),
            ),
            BlocProvider<SearchCubit>(
              create: (_) => SearchCubit(),
            ),
          ],
          child: LayoutBuilder(
            builder: (context, __) => BlocBuilder<SearchCubit, bool>(
              builder: (context, isSearching) {
                return Scaffold(
                  appBar: _appBar(context, isSearching: isSearching),
                  drawer: _drawer(context),
                  body: _body(context, isSearching: isSearching),
                );
              },
            ),
          ));

  AppBar _appBar(BuildContext context, {bool isSearching = false}) => AppBar(
        title: isSearching
            ? searchField(context)
            : Text(AppLocalizations.of(context)?.app_name ?? ""),
        leading: LayoutBuilder(builder: (context, _) {
          return IconButton(
            onPressed: () {
              if (isSearching) {
                context.read<SearchCubit>().toggle();
                _animationController.reverse();
              } else {
                Scaffold.of(context).openDrawer();
              }
            },
            icon: AnimatedIcon(
              progress: _animationController,
              icon: AnimatedIcons.menu_arrow,
            ),
          );
        }),
        actions: !isSearching
            ? [
                IconButton(
                  onPressed: () {
                    context.read<SearchCubit>().toggle();
                    _animationController.forward();
                  },
                  icon: Icon(Icons.search),
                ),
              ]
            : null,
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

  Widget _drawer(BuildContext context) => Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _userHeaderDrawer(context),
                  _newMessageTile(context),
                ],
              ),
            ),
            Divider(height: 0),
            _logoutButton(context),
          ],
        ),
      );

  Widget _userHeaderDrawer(BuildContext context) => UserAccountsDrawerHeader(
      currentAccountPicture: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey.shade300,
        child: Text(
          widget.user.displayNameInitials,
          style: TextStyle(color: Colors.black54),
        ),
      ),
      accountName: widget.user.displayName != null
          ? Text(widget.user.displayName!)
          : Text(AppLocalizations.of(context)?.label_user_name ?? ""),
      accountEmail: Text(widget.user.email!));
  Widget _logoutButton(BuildContext context) => ListTile(
        onTap: () => _shouldShowLogoutDialog(context),
        leading: Icon(Icons.logout),
        title: Text(AppLocalizations.of(context)?.action_logout ?? ""),
      );

  _shouldShowLogoutDialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
              AppLocalizations.of(context)?.dialog_title_confirm_logout ?? ""),
          content: Text(
              AppLocalizations.of(context)?.dialog_confirm_logout_message ??
                  ""),
          actions: [
            TextButton(
              onPressed: () => _signOut(context),
              child: Text(AppLocalizations.of(context)?.action_ok ?? ""),
            ),
            TextButton(
                onPressed: () => context.router.popForced(),
                child: Text(AppLocalizations.of(context)?.action_no ?? ""))
          ],
        ),
      ),
    );
  }

  Widget _newMessageTile(BuildContext context) => ListTile(
        title: Text(AppLocalizations.of(context)?.action_new_message ?? ""),
        leading: Icon(FontAwesomeIcons.edit),
        onTap: () {
          context.router.push(NewMessageRoute(user: widget.user));
        },
      );

  void _signOut(BuildContext context) {
    context.read<AuthCubit>().signOut();
    context.router.popUntilRoot();
  }

  Widget _body(BuildContext context, {bool isSearching = false}) => Stack(
        children: [
          _chatBody(context),
          _fab(context, isSearching: isSearching),
        ],
      );

  Widget _chatBody(_) => BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is FetchedChatState) {
            return _chatContent(context, chats: state.chats);
          } else if (state is NoChatState) {
            return _chatEmpty(context);
          } else if (state is ErrorChatState) {
            return _chatError(context);
          } else {
            return _loading(context);
          }
        },
      );

  Widget _chatContent(BuildContext context, {required List<Chat> chats}) =>
      StreamBuilder<String?>(
          stream: context.watch<SearchCubit>().searchBinding.stream,
          builder: (context, snapshot) {
            final List<Chat> filteredChats = chats
                .where(
                  (chat) =>
                      !snapshot.hasData ||
                      chat.user!.displayName
                          .toLowerCase()
                          .contains(snapshot.data!.toLowerCase()) ||
                      chat.lastMessage.toLowerCase().contains(
                            snapshot.data!.toLowerCase(),
                          ),
                )
                .toList(growable: false);

            if (filteredChats.isEmpty) {
              return _searchChatEmpty(context);
            }
            return NotificationListener(
              child: ListView.builder(
                itemCount: filteredChats.length,
                itemBuilder: (_, index) => ChatTile(
                  chat: filteredChats[index],
                  onTap: () => context.router.push(ChatRoute(
                      user: widget.user, other: filteredChats[index].user!)),
                ),
              ),
              onNotification: (notification) {
                if (notification is ScrollStartNotification) {
                  context.read<ScrollCubit>().start();
                } else if (notification is ScrollEndNotification) {
                  context.read<ScrollCubit>().end();
                }
                return false;
              },
            );
          });

  Widget _searchChatEmpty(BuildContext context) => ChatErrorPage(
        icon: Icon(
          Icons.chat,
          size: 128,
          color: Colors.grey,
        ),
        title: AppLocalizations.of(context)?.title_search_empty_chat ?? "",
        subtitle:
            AppLocalizations.of(context)?.label_search_empty_chat_sub ?? "",
      );

  Widget _chatError(BuildContext context) => ChatErrorPage(
        icon: Icon(
          Icons.error,
          size: 128,
          color: Colors.grey,
        ),
        title: AppLocalizations.of(context)?.title_error_chat ?? "",
        subtitle: AppLocalizations.of(context)?.label_error_chat_sub ?? "",
      );

  Widget _chatEmpty(BuildContext context) => ChatErrorPage(
        icon: Icon(
          FontAwesomeIcons.file,
          size: 128,
          color: Colors.grey,
        ),
        title: AppLocalizations.of(context)?.title_empty_chat ?? "",
        subtitle: AppLocalizations.of(context)?.label_empty_chat_sub ?? "",
      );
  Widget _loading(BuildContext context) => ShimmedList(
        child: ChatTile.shimmed(),
      );

  Widget _fab(BuildContext context, {bool isSearching = false}) =>
      BlocBuilder<ScrollCubit, bool>(
          builder: (context, isScrolling) => AnimatedPositioned(
              duration: Duration(milliseconds: 250),
              bottom: isScrolling || isSearching ? -100 : 24,
              right: 24,
              child: FloatingActionButton(
                shape: CircleBorder(),
                onPressed: () {
                  context.router.push(NewMessageRoute(user: widget.user));
                },
                child: Icon(FontAwesomeIcons.edit),
              )));
}
