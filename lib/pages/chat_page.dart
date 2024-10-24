import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_app/cubits/user_status/user_status_cubit.dart';
import 'package:telegram_app/models/user.dart' as models;
import 'package:telegram_app/widgets/connectivity_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;

@RoutePage()
class ChatPage extends ConnectivityWidget implements AutoRouteWrapper {
  final User user;
  final models.User other;

  const ChatPage({super.key, required this.user, required this.other});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(providers: [
        BlocProvider<UserStatusCubit>(
            create: (context) =>
                UserStatusCubit(userRepository: context.read(), user: other))
      ], child: this);

  @override
  Widget connectedBuild(BuildContext context) => Scaffold(
        appBar: _appBar(context),
        body: Column(
          children: [
            _messageBody(context),
            _footer(context),
          ],
        ),
      );

  AppBar _appBar(BuildContext context) => AppBar(
        title: BlocConsumer<UserStatusCubit, UserStatusState>(
          listener: (context, state) {
            _shouldShowError(context, state: state);
          },
          builder: (context, state) => _otherUserTile(context,
              other: state is UpdatedUserStatusState ? state.user : other),
        ),
        actions: [],
      );

  Widget _otherUserTile(BuildContext context, {required models.User other}) {
    return ListTile(
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
                other.lastAccess != null ? other.lastAccess! : DateTime.now(),
                locale: AppLocalizations.of(context)?.localeName),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  Widget _messageBody(BuildContext context) => Expanded(
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/qwd83nc4xxf41.jpeg"),
          )),
          child: Text("Chat Page"),
        ),
      );

  Widget _footer(BuildContext context) => Card(
        shape: Border(),
        margin: EdgeInsets.zero,
        child: Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.emoji_emotions_outlined,
                  color: Colors.grey,
                )),
            Expanded(
              child: TextField(
                minLines: 1,
                maxLines: 6,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        AppLocalizations.of(context)?.label_message ?? ""),
              ),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.attach_file)),
            IconButton(onPressed: () {}, icon: Icon(Icons.mic)),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                  color: Colors.blue,
                ))
          ],
        ),
      );

  _shouldShowError(BuildContext context, {required UserStatusState state}) {
    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      if (state is ErrorUserStatusState) {
        final scaffold = ScaffoldMessenger.of(context);

        scaffold.showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)?.label_error_status_feed ?? ""),
            duration: Duration(seconds: 5),
            action: SnackBarAction(
                label: AppLocalizations.of(context)?.action_ok ?? "",
                onPressed: () {
                  scaffold.hideCurrentSnackBar();
                }),
          ),
        );
      }
    });
  }
}
