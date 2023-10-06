
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


/// [FlexTable] is a table that use flex to layout the columns
/// you can set scroll and width and height for columns and rows
/// you can fix a row or column to the left or right or make it sticky
///
class FlexTable extends InheritedWidget {
  /// [direction] is the direction of the table, default is [Axis.horizontal]
  final Axis direction;

  /// [scrollable] is the scrollable direction of the table, default is [false]
  final bool scrollable;

  /// [itemSize] is the size of each item, default is [Size(100, double.infinity)]
  final List<FlexTableItemConfig?>? configs;

  /// [gap] is the space between each item, default is [12]
  final double gap;

  /// [selectable] is the selectable of the table, default is [false]
  final bool selectable;

  /// [onSelectChanged] is the callback when the selection changed, param is the list of selected items
  final void Function(List<int>?)? onSelectChanged;

  const FlexTable({
    super.key,
    required super.child,
    this.direction = Axis.horizontal,
    this.scrollable = false,
    this.configs,
    this.gap = 12,
    this.selectable = false,
    this.onSelectChanged,
  });

  @override
  bool updateShouldNotify(FlexTable oldWidget) {
    return configs != oldWidget.configs ||
        direction != oldWidget.direction ||
        scrollable != oldWidget.scrollable ||
        gap != oldWidget.gap;
  }

  static FlexTable? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FlexTable>();
  }
}


/// [FlexTableItemConfig] is a class that contains the size of each item in the table
class FlexTableItemConfig {
  /// [name] is the name of the segment
  final String? name;
  final double? width;
  final double? height;
  final double? minWidth;
  final int? flex;

  /// [hezdden] is the hidden of the segment
  final bool hidden;

  const FlexTableItemConfig({
    this.width,
    this.height,
    this.minWidth,
    this.flex = 1,
    this.name,
    this.hidden = false,
  });

  // constructor for flex
  const FlexTableItemConfig.flex(this.flex, {this.name, this.hidden = false,this.minWidth})
      : width = null,
        height = null;

  // constructor for size
  const FlexTableItemConfig.size({
    this.hidden = false,
    this.width,
    this.height,this.minWidth,
    this.name,
  }) : flex = null;

  // constructor for square
  const FlexTableItemConfig.square(double size,
      {this.name, this.hidden = false,this.minWidth,})
      : width = size,
        height = size,
        flex = null;

  // constructor for hidden
  const FlexTableItemConfig.hidden({this.name, this.minWidth,this.hidden = true})
      : width = null,
        height = null,
        flex = null;
}

/// [FlexTableItem] is a class that contains the data of each item in the table

class FlexTableItem extends StatelessWidget {
  final List<Widget> children;
  final bool isHeader;
  // on select changed
  final void Function(bool?)? onSelectChanged;
  // selected
  final bool? selected;
  // tristate
  const FlexTableItem({
    super.key,
    required this.children,
    this.isHeader = false,
    this.onSelectChanged,
    this.selected = false,
  });

  /// factory constructor for header
  factory FlexTableItem.header({
    Key? key,
    required List<Widget> children,
  }) {
    return FlexTableItem(
      key: key,
      children: children,
      isHeader: true,
    );
  }

  // _getSizeOf(index)
  FlexTableItemConfig _getSizeOf(BuildContext context, int index) {
    var configs = FlexTable.of(context)?.configs;
    // if index in range of sizes, return sizes[index] else return default size
    return index < (configs?.length ?? 0)
        ? configs![index] ?? const FlexTableItemConfig()
        : const FlexTableItemConfig();
  }

  @override
  Widget build(BuildContext context) {
    var flexTable = FlexTable.of(context);
    var childs = <Widget>[];
    
    return Row(
      children: [
          if (flexTable?.selectable == true)
            SizedBox.square(
              dimension: 40,
              child: Checkbox(
                tristate: selected == null,
                value: selected,
                onChanged: onSelectChanged,
              ),
            ),
        for (var j = 0; j < children.length; j++) ...[
          if (j != 0) SizedBox(width: flexTable?.gap),
          Builder(
            builder: (context) {
              var size = _getSizeOf(context, j);
              return Expanded(
                flex: size.flex ?? 0,
                child: Container(
                  // random color
                  // color: Colors.primaries[j % Colors.primaries.length],
                  width: size.width,
                  height: size.height,
                  child: children[j],
                ),
              );
            }
          ),
        ],
      ],
    );
  }
}
