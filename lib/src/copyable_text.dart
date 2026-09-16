import 'package:ui_widgets/src/gaps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyableText extends StatelessWidget {
  const CopyableText({
    super.key,
    required this.value,
    this.style,
    this.copyableValue,
  });

  final String value;
  final String? copyableValue;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Clipboard.setData(ClipboardData(text: copyableValue ?? value)),
      borderRadius: BorderRadius.circular(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(value, style: style)),
          const HorizontalGap(4),
          const Icon(Icons.copy, size: 16),
        ],
      ),
    );
  }
}
