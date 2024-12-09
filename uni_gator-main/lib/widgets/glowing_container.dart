import 'package:flutter/material.dart';

class GlowingContainer extends StatelessWidget {
  final Widget child;
  final double glowIntensity;
  final Color glowColor;

  const GlowingContainer({
    Key? key,
    required this.child,
    this.glowIntensity = 5.0,
    this.glowColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.2),
            blurRadius: glowIntensity * 2,
            spreadRadius: glowIntensity / 2,
          ),
        ],
      ),
      child: child,
    );
  }
}
