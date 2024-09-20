import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telegram_app/widgets/connectivity_widget.dart';

class HomePage extends ConnectivityWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget connectedBuild(BuildContext context) => Scaffold(
        body: Center(
          child: Text("Home page"),
        ),
      );
}
