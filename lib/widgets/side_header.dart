import 'package:flutter/material.dart';

class SideHeader extends StatelessWidget {
  final String letter;
  const SideHeader({super.key, required this.letter});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: 56,
            width: 56,
            child: Text(
              letter,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: Colors.grey),
            ),
          ),
        ),
      );
}
