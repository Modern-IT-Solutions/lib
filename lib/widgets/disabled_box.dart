import 'package:flutter/material.dart';

/// [DisabledBox] is a widget that is used to disable a widget.
/// it has the property [enabled] to disable the widget.
/// [enabled] is true by default.
/// it used [Opacity] to make the widget transparent.
///  and [IgnorePointer] to disable the touch events.
class DisabledBox extends StatelessWidget {
  /// [enabled] is a boolean value that determines whether the widget is enabled or not.
  final bool enabled;
  /// [child] is a widget that is used to show the widget.
  final Widget child;
  /// [note] is a widget that is used to show a note on the widget.
  final Widget? note;

  const DisabledBox({
    super.key,
    this.enabled = true,
    required this.child,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    var widget = child;
    if (!enabled) {
      widget = AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: 0.2,
        child: IgnorePointer(
          ignoring: true,
          child: child,
        ),
      );
      if (note != null) {
        widget = Stack(
          children: [
            widget,
            Positioned.fill(
              child: Center(child: note),
            ),
          ],
        );
      }
    }
    return widget;
  }
}
