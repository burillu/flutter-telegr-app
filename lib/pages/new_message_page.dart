import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';

@RoutePage()
class NewMessagePage extends ConnectivityWidget {
  final User user;

  const NewMessagePage({super.key, required this.user});
  @override
  Widget connectedBuild(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("nuovo messaggio")),
        body: Center(child: Text("nuovo messaggio")),
      );
}
