import 'package:flutter/material.dart';

class ChatErrorPage extends StatelessWidget {
  final Icon icon;
  final String title;
  final String? subtitle;

  const ChatErrorPage(
      {super.key, required this.icon, required this.title, this.subtitle});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.grey),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                subtitle != null ? subtitle! : "",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
}
