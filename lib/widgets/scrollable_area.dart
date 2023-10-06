


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


/// [ScrollableArea] is a widget that can be used to show a scrollable area
/// also shows arrows to indicate the direction of the scroll
/// you can also use it to show a refresh indicator and control the scroll by th indicators
class ScrollableArea extends StatefulWidget {
  final AlignmentGeometry? alignment;
  final bool scrollable;
  final bool refreshable;
  final bool paginable;
  final ScrollableAreaArrows arrows;
  final bool showIndicator;
  final Axis direction;
  final void Function(ScrollMetrics metrics)? onRefresh;
  final Future<void> Function(ScrollMetrics metrics)? onEnd;
  final void Function(ScrollMetrics metrics)? onStart;
  final void Function(ScrollMetrics metrics)? onMiddle;
  final void Function()? onInit;
  final void Function(ScrollNotification notification)? onNotification;
  final ScrollController? controller;

  final Widget Function(BuildContext context, Widget? child,
      ValueNotifier<ScrollNotification?> notifier)? builder;
  final Widget child;
  final Widget? topWidget;

  const ScrollableArea(
      {super.key,
      required this.child,
      this.scrollable = true,
      this.refreshable = true,
      this.paginable = true,
      this.arrows = const ScrollableAreaArrows(),
      this.showIndicator = true,
      this.direction = Axis.vertical,
      this.onRefresh,
      this.onStart,
      this.onMiddle,
      this.onEnd,
      this.onNotification,
      this.onInit,
      this.controller,
      this.alignment,
      this.builder,
      this.topWidget});

  @override
  State<ScrollableArea> createState() => _ScrollableAreaState();
}

class _ScrollableAreaState extends State<ScrollableArea> {
  ValueNotifier<ScrollNotification?> _notifier = ValueNotifier(null);
  late ScrollController? _controller;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onInit?.call();
    });
    _controller =
        widget.controller ?? (widget.scrollable ? ScrollController() : null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _builder = widget.builder ??
        (BuildContext context, Widget child,
            ValueNotifier<ScrollNotification?> notifier) {
          return widget.scrollable
              ? SingleChildScrollView(
                  controller: _controller,
                  scrollDirection: widget.direction,
                  child: child,
                  physics: const AlwaysScrollableScrollPhysics(),
                )
              : child;
        };
    // return _builder(context, widget.child, _notifier);
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollNotification) {
          _onNotification(notification);
        } else if (notification is ScrollMetricsNotification) {
          _onNotification(ScrollStartNotification(
            context: notification.context,
            metrics: notification.metrics,
          ));
        }
        return true;
      },
      child: Stack(
        children: [
          Align(
              alignment: _getAlignment(widget.alignment),
              child: _builder(context, widget.child, _notifier)),
          if (widget.scrollable || _controller != null) ...[
            if (widget.direction == Axis.horizontal) ...[
              Positioned(
                // textDirection: Directionality.of(context),
                right: widget.arrows.margin,
                bottom: 0,
                top: 0,
                child: ScrollableAreaArrow(
                  show: widget.arrows.end,
                  controller: _controller!,
                  notifier: _notifier,
                  direction: ArrowDirection.right,
                ),
              ),
              Positioned(
                // textDirection: Directionality.of(context),
                // end: 10,
                left: widget.arrows.margin,
                bottom: 0,
                top: 0,
                child: ScrollableAreaArrow(
                  show: widget.arrows.start,
                  controller: _controller!,
                  notifier: _notifier,
                  direction: ArrowDirection.left,
                ),
              ),
            ] else ...[
              Positioned.directional(
                textDirection: Directionality.of(context),
                start: 0,
                end: 0,
                top: widget.arrows.margin,
                child: ScrollableAreaArrow(
                  show: widget.arrows.top,
                  controller: _controller!,
                  notifier: _notifier,
                  direction: ArrowDirection.top,
                ),
              ),
              Positioned.directional(
                textDirection: Directionality.of(context),
                end: 0,
                bottom: widget.arrows.margin,
                start: 0,
                child: ScrollableAreaArrow(
                  show: widget.arrows.bottom,
                  controller: _controller!,
                  notifier: _notifier,
                  direction: ArrowDirection.bottom,
                ),
              ),
            ],
          ],
          if (widget.topWidget != null) widget.topWidget!
        ],
      ),
    );
  }

  void _onNotification(ScrollNotification notification) {
    _notifier.value = notification;
    ScrollMetrics metrics = notification.metrics;
    // if reached the end of the list, call onLoadMore
    if (widget.paginable && metrics.pixels == metrics.maxScrollExtent) {
      widget.onEnd?.call(metrics);
    }
    // if reached the top of the list, call onRefresh
    if (widget.refreshable && metrics.pixels == 0) {
      widget.onStart?.call(metrics);
    }
    // onMiddle of scrolling, call onMiddle
    if (widget.onMiddle != null) {
      widget.onMiddle?.call(metrics);
    }

    widget.onNotification?.call(notification);
  }
  
  _getAlignment(AlignmentGeometry? alignment) {
    if (alignment != null) {
      return alignment;
    }
    if (widget.direction == Axis.horizontal) {
      return Alignment.centerLeft;
    }
    return Alignment.topCenter;
  }
}



/// [ScrollableAreaArrows] is a class that can be used to show or hide the arrows
class ScrollableAreaArrows {
  final bool top;
  final bool bottom;
  final bool start;
  final bool end;
  // margin
  final double margin;

  const ScrollableAreaArrows({
    this.top = true,
    this.bottom = true,
    this.start = true,
    this.end = true,
    this.margin = 10,
  });
  // all
  factory ScrollableAreaArrows.all(bool visibility, {
    double margin = 10,
  }) => ScrollableAreaArrows(
        top: visibility,
        bottom: visibility,
        start: visibility,
        end: visibility,
        margin: margin,
      );
  // symmetric visible [vertical, horizontal]
  factory ScrollableAreaArrows.symmetric(bool vertical, bool horizontal, {
    double margin = 10,
  }) => ScrollableAreaArrows(
        top: vertical,
        bottom: vertical,
        start: horizontal,
        end: horizontal,
        margin: margin,
      );
  
  /// only
  factory ScrollableAreaArrows.only({
    bool top = false,
    bool bottom = false,
    bool start = false,
    bool end = false,
    double margin = 10,
  }) => ScrollableAreaArrows(
        top: top,
        bottom: bottom,
        start: start,
        end: end,
        margin: margin,
      );
}


/// Arrow direction for [ScrollableAreaArrow] class
class ScrollableAreaArrow extends StatelessWidget {
  final ScrollController controller;
  final ValueListenable<ScrollNotification?> notifier;
  final ArrowDirection direction;
  final double rate;
  final Widget? icon;
  final bool show;

  const ScrollableAreaArrow(
      {super.key,
      required this.controller,
      required this.notifier,
      required this.direction,
      this.rate = 1,
      this.icon,
      this.show = true});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ScrollNotification?>(
        valueListenable: notifier,
        builder: (context, value, child) {
          return AnimatedScale(
            scale: _getScale(context, value),
            duration: Duration(milliseconds: 300),
            child: Center(
              child: FloatingActionButton.small(
                heroTag: UniqueKey(),
                backgroundColor: Theme.of(context).cardColor,
                onPressed: () {
                  if (value != null) {
                    var dir = _selectDir(context);
                    controller.animateTo(
                      value.metrics.pixels +
                          value.metrics.extentInside / 2 * dir * rate,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Center(
                  child: RotatedBox(
                    quarterTurns: direction.quarterTurns,
                    child: icon ??
                        Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  int _selectDir(context) {
    if (direction == ArrowDirection.top) {
      return -1;
    } else if (direction == ArrowDirection.bottom) {
      return 1;
    } else if (direction == ArrowDirection.left) {
      if (Directionality.of(context) == TextDirection.ltr) {
        return -1;
      } else {
        return 1;
      }
    } else if (direction == ArrowDirection.right) {
      if (Directionality.of(context) == TextDirection.ltr) {
        return 1;
      } else {
        return -1;
      }
    } else {
      return 0;
    }
  }

  double _getScale(context, ScrollNotification? value) {
    if (!show) {
      return 0;
    }
    if (notifier.value != null) {
      var dir = _selectDir(context);
      if (value!.metrics.maxScrollExtent == 0) {
        return 0;
      }
      if (notifier.value!.metrics.pixels == 0 && dir == -1) {
        return 0;
      }
      if (notifier.value!.metrics.pixels ==
              notifier.value!.metrics.maxScrollExtent &&
          dir == 1) {
        return 0;
      }
      return 1;
    }
    return 0;
  }
}

/// Arrow direction for [ScrollableAreaArrow]
enum ArrowDirection {
  top,
  bottom,
  right,
  left,
}

/// Extension for [ArrowDirection]
extension QuarterTurns on ArrowDirection {
  /// [QuarterTurns] for [ArrowDirection] to get the currect quarter turns
  int get quarterTurns {
    switch (this) {
      case ArrowDirection.bottom:
        return 1;
      case ArrowDirection.left:
        return 2;
      case ArrowDirection.top:
        return 3;
      case ArrowDirection.right:
        return 4;
      default:
        return 1;
    }
  }
  /// [Axis] for [ArrowDirection] to get the currect axis
  Axis get axis {
    switch (this) {
      case ArrowDirection.bottom:
        return Axis.vertical;
      case ArrowDirection.left:
        return Axis.horizontal;
      case ArrowDirection.top:
        return Axis.vertical;
      case ArrowDirection.right:
        return Axis.horizontal;
      default:
        return Axis.horizontal;
    }
  }
}