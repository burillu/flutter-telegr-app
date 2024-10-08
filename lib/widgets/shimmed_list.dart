import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmedList extends StatelessWidget {
  final Widget child;

  const ShimmedList({super.key, required this.child});

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.grey,
          child: child,
        ),
        itemCount: 10,
      );
}
