import 'package:flutter/material.dart';

class EasyTabBar extends StatefulWidget {
  final List<Widget> tabs;
  final VoidCallback? onTabChanged;

  /// tab contant
  final List<Widget>? children;

  /// initial index of tab
  final int initialIndex;
  const EasyTabBar({
    super.key,
    required this.tabs,
    this.onTabChanged,
    this.initialIndex = 0,
    this.children,
  })  :
        // if children is not null then tabs length must be equal to children length
        assert(children == null || tabs.length == children.length),
        // initial index must be less than tabs length
        assert(initialIndex < tabs.length);

  @override
  State<EasyTabBar> createState() => _EasyTabBarState();
}

class _EasyTabBarState extends State<EasyTabBar> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
    _tabController.addListener(() {
      if (widget.onTabChanged != null) widget.onTabChanged!();
      setState(() {
        selectedIndex = _tabController.index;
      });
    });
    _tabController.index = widget.initialIndex;
    selectedIndex = _tabController.index;
  }

  /// dispose tab controller
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(
            controller: _tabController,
            // items to left
            tabs: widget.tabs,
            splashBorderRadius: BorderRadius.circular(10),
            isScrollable: true,
          ),
          if (widget.children != null) widget.children!.elementAt(selectedIndex),
        ],
      ),
    );
  }
}
