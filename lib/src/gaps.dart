// Copyright (c) 2025 Order of Runes Authors. All rights reserved.

import 'package:flutter/material.dart';

/// Vertical gap widget
class VerticalGap extends StatelessWidget {
  /// A vertical space of [gapSize].
  ///
  /// Default gap is 16.
  const VerticalGap([this.gapSize = 16]);

  final double gapSize;

  @override
  Widget build(BuildContext context) => SizedBox(height: gapSize);
}

/// Horizontal gap widget
class HorizontalGap extends StatelessWidget {
  /// A horizontal space of [gapSize].
  ///
  /// Default gap is 8.
  const HorizontalGap([this.gapSize = 8]);

  final double gapSize;

  @override
  Widget build(BuildContext context) => SizedBox(width: gapSize);
}
