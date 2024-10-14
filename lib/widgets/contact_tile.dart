import 'package:flutter/material.dart';

class ContactTile extends StatelessWidget {
  final String name;
  const ContactTile({super.key, required this.name});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            name.substring(0, 1),
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(name),
      );
}
