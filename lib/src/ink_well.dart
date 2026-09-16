// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

import 'package:flutter/material.dart';

class BetterInkWell extends StatelessWidget {
  const BetterInkWell({
    super.key,
    required this.onTap,
    required this.child,
    this.radius = 10,
  });

  final Widget child;
  final VoidCallback onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        fit: StackFit.loose,
        children: [
          child,
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(onTap: onTap),
            ),
          ),
        ],
      ),
    );
  }
}
