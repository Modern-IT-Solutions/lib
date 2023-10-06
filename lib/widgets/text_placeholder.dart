import 'dart:math';

import 'package:flutter/material.dart';

/// [TextPlaceholder] is a widget that can be used to show a placeholder
/// for a text widget. It can be used to show a placeholder for a text widget
class TextPlaceholder extends StatelessWidget {
  /// [enabled] is a boolean value that determines whether the placeholder
  final bool enabled;

  /// [child] is a widget that can be used to show a placeholder
  final Widget? child;

  /// [lines] is an integer value that determines the number of lines
  final int lines;

  /// [height] is a double value that determines the height of the placeholder
  final double height;

  /// [width] is a double value that determines the width of the placeholder
  /// if width is not specified, then the width will be in formular width = random(width/2) + width/2
  final double? width;

  /// [color] is a color value that determines the color of the placeholder
  final Color? color;

  const TextPlaceholder({
    super.key,
    this.enabled = true,
    this.lines = 1,
    this.child,
    this.height = 14,
    this.width = 90,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    var random = Random();
    return enabled
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < lines; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: height,
                  /// if width is null, then the width will be random
                  width: width == null
                      ? width
                      : ((random.nextDouble() * (width! / 2)) + width! / 2),
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: color ?? Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
            ],
          )
        : child ?? SizedBox();
  }
}
