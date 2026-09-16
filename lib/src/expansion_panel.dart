// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

import 'package:flutter/material.dart';

class BetterExpansionPanel extends StatefulWidget {
  const BetterExpansionPanel({
    super.key,
    required this.title,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
    this.isExpanded = false,
    this.onTap,
  });

  final Duration duration;
  final Curve curve;
  final bool isExpanded;
  final Widget title;
  final Widget child;
  final VoidCallback? onTap;

  @override
  State<BetterExpansionPanel> createState() => _BetterExpansionPanelState();
}

class _BetterExpansionPanelState extends State<BetterExpansionPanel> with SingleTickerProviderStateMixin {
  late bool isExpanded;
  late AnimationController rotateController;
  late AnimationController scaleController;
  late Animation<double> rotateAnim;
  late Animation<double> scaleAnim;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpanded;
    rotateController = AnimationController(vsync: this, duration: widget.duration);

    rotateAnim = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(
        parent: rotateController,
        curve: widget.curve,
      ),
    );
  }

  @override
  void dispose() {
    rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.onTap?.call();
          isExpanded = !isExpanded;
          if (isExpanded) {
            rotateController.forward();
          } else {
            rotateController.reverse();
          }
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.title,
          AnimatedSize(
            duration: widget.duration,
            alignment: Alignment.centerLeft,
            child: isExpanded ? widget.child : const SizedBox.shrink(),
          ),
          Center(
            child: SizedBox.square(
              dimension: 32,
              child: AnimatedRotation(
                turns: isExpanded ? -0.5 : 0,
                duration: widget.duration,
                child: const Icon(Icons.keyboard_arrow_down),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
