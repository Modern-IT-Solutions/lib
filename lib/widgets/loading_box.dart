
import 'package:flutter/material.dart';

import 'disabled_box.dart';

/// [LoadingBox] is a widget that shows a loading indicator
/// when the child is null
class LoadingBox extends StatefulWidget {
  final Widget child;
  final bool loading;
  const LoadingBox({super.key, required this.child, this.loading = false});

  @override
  State<LoadingBox> createState() => _LoadingBoxState();
}

class _LoadingBoxState extends State<LoadingBox> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DisabledBox(enabled: !widget.loading, child: widget.child),
        if (widget.loading)
           const Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator.adaptive(strokeWidth: 2),
                // SizedBox(height: 10),
                // Text('Loading...'),
                // SizedBox(
                //   width: 100,

                //   child: LinearProgressIndicator(
                //     minHeight: 2,
                //   ),
                // ),
              ],
            ),
          ),
      ],
    );
  }
}
