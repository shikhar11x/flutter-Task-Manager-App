import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D0D1A),
            Color(0xFF111128),
            Color(0xFF0f3460),
            Color(0xFF1a6eb5),
          ],
        ),
      ),
      child: child,
    );
  }
}