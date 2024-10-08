import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:telegram_app/cubits/auth/auth_cubit.dart';
import 'package:telegram_app/cubits/chat/cubit/chat_cubit.dart';
import 'package:telegram_app/cubits/scroll_cubit.dart';
import 'package:telegram_app/extension/user_display_name_initials.dart';
import 'package:telegram_app/pages/chat_error_page.dart';
import 'package:telegram_app/widgets/chat_tile.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telegram_app/widgets/shimmed_list.dart';

class HomePage extends ConnectivityWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget connectedBuild(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<ScrollCubit>(
            create: (_) => ScrollCubit(),
          ),
          BlocProvider<ChatCubit>(
            create: (context) =>
                ChatCubit(uid: user.uid, chatRepository: context.read()),
          ),
        ],
        child: LayoutBuilder(
          builder: (context, _) {
            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)?.app_name ?? ""),
              ),
              drawer: _drawer(context),
              body: _body(context),
            );
          },
        ),
      );

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
          user.displayNameInitials,
          style: TextStyle(color: Colors.black54),
        ),
      ),
      accountName: user.displayName != null
          ? Text(user.displayName!)
          : Text(AppLocalizations.of(context)?.label_user_name ?? ""),
      accountEmail: Text(user.email!));
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
        onTap: () {},
      );

  void _signOut(BuildContext context) {
    context.read<AuthCubit>().signOut();
    context.router.popUntilRoot();
  }

  Widget _body(BuildContext context) => Stack(
        children: [
          _chatBody(context),
          _fab(context),
        ],
      );

  Widget _chatBody(_) => BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is FetchedChatState) {
            return _chatContent(context, state: state);
          } else if (state is NoChatState) {
            return _chatEmpty(context);
          } else if (state is ErrorChatState) {
            return _chatError(context);
          } else {
            return _loading(context);
          }
        },
      );

  Widget _chatContent(BuildContext context,
          {required FetchedChatState state}) =>
      NotificationListener(
        child: ListView.builder(
          itemCount: state.chats.length,
          itemBuilder: (_, index) => ChatTile(chat: state.chats[index]),
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

  Widget _chatError(BuildContext context) => ChatErrorPage(
        icon: Icon(
          FontAwesomeIcons.eraser,
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

  Widget _fab(BuildContext context) =>
      BlocBuilder<ScrollCubit, bool>(builder: (context, isScrolling) {
        return AnimatedPositioned(
            duration: Duration(milliseconds: 250),
            bottom: isScrolling ? -100 : 24,
            right: 24,
            child: FloatingActionButton(
              shape: CircleBorder(),
              onPressed: () {},
              child: Icon(FontAwesomeIcons.edit),
            ));
      });
}
