import 'dart:math';

import 'package:flutter/material.dart';

/// [Panel] is a widget that is used to show a panel.
/// it has the property [title] to show a title on the panel.
/// it has the property [action] to show an action on the panel.
/// easy way to implement simple semantic panel.
class Panel extends StatelessWidget {
  final Widget child;
  final Widget? title;
  final Widget? action;
  // padding
  final EdgeInsetsGeometry padding;
  // margin
  final EdgeInsetsGeometry margin;
  /// [borderRadius] is a border radius that is used to round the panel. by default it is 0
  final BorderRadiusGeometry borderRadius;
  /// [backgroundColor] is a color that is used to set the background color of the panel. by default it is transparent
  final Color? backgroundColor;
  /// [elevation] is a double value that is used to set the elevation of the panel. by default it is 0
  final double elevation;

  const Panel({
    super.key,
    required this.child,
    this.title,
    this.action,
    this.padding = const EdgeInsets.all(12),
    this.margin = const EdgeInsets.all(0),
    this.borderRadius = BorderRadius.zero,
    this.backgroundColor,
    this.elevation = 0,
  });


  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Card(
        margin: margin,
        elevation: elevation,
        color: backgroundColor ?? Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null || action != null)
            ContaineredBox(
              child: Padding(
                padding: padding,
                child: Row(
                  children: [
                    if (title != null)
                      DefaultTextStyle(
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                        child: title!,
                      ),
                    const Spacer(),
                    if (action != null)
                      Theme(
                        data: Theme.of(context).copyWith(
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        child: action!,
                      ),
                  ],
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

/// [PanelCard] is a widget that is used to show a panel card.
class PanelCard extends StatelessWidget {
  final Widget child;
  final double shadowOpacity;

  const PanelCard({super.key, required this.child, this.shadowOpacity = 0.2});
  factory PanelCard.noShadow({Key? key, required Widget child}) {
    return PanelCard(key: key, shadowOpacity: 0, child: child);
  }

  static double borderRadius = 16;
  static BoxDecoration decoration(BuildContext context,
      [double shadowOpacity = 0.2]) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: shadowOpacity == 0
          ? null
          : [
              BoxShadow(
                blurRadius: 4,
                color:
                    Theme.of(context).primaryColor.withOpacity(shadowOpacity),
                offset: const Offset(0, 2),
              ),
            ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration(context, shadowOpacity),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}



/// [PanelBar] Row containing a title? and a action button?. and icon?
class PanelBar extends StatelessWidget {
  /// [title] is the title of the panel bar. its widget.
  final Widget? title;

  /// [subtitle] is the subtitle of the panel bar. its widget.
  final Widget? subtitle;

  /// [action] is the action of the panel bar. its widget.
  final Widget? action;

  /// [icon] is the icon of the panel bar. its widget.
  final Widget? icon;

  PanelBar({
    Key? key,
    this.title,
    this.subtitle,
    this.action,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[icon!, const SizedBox(width: 10)],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

        if (title != null)
          DefaultTextStyle(
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontSize: 24,
                ),
            child: title!,
          ),

        if (subtitle != null)...[
          if (title != null) const SizedBox(height: 4),
          DefaultTextStyle(
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 16,
                ),
            child: subtitle!,
          ),]
          ],
        ),
        const Spacer(),
        if (action != null)
          ConstrainedBox(
              constraints: BoxConstraints.loose(
                Size(100, 40),
              ),
              child: action!),
      ],
    );
  }
}



/// [ContaineredBox] is a widget that is used to show a containere that has a max width.
class ContaineredBox extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const ContaineredBox({super.key, required this.child, this.maxWidth = 900});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// [SafeContaineredBox]
class SafeContaineredBox extends StatelessWidget {
  final Widget child;
  const SafeContaineredBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    double paddingValue = max(0, (MediaQuery.of(context).size.width - 900) / 2);

    return Container(
      padding: EdgeInsetsDirectional.only(start: paddingValue),
      child: child,
    );
  }
}



/// widget [GeneralCard] is used to show a widget in a panel
class GeneralCard extends StatelessWidget {
  /// title
  final Widget? title;
  /// description
  final Widget? description;
  /// text align
  final TextAlign textAlign;
  const GeneralCard({super.key, this.title, this.description,
  this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    /// apply default style to the title and description
    var titleStyle = Theme.of(context).textTheme.titleMedium;
    var descriptionStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Colors.grey,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: DefaultTextStyle(
              textAlign: textAlign,
              style: titleStyle!,
              child: title!,
            ),
          ),
        if (description != null)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: DefaultTextStyle(
              textAlign: textAlign,
              style: descriptionStyle!,
              child: description!,
            ),
          ),
      ],
    );
  }
}

