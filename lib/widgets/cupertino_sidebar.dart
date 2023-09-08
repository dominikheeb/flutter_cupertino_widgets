import 'package:flutter/cupertino.dart';

class CupertinoSidebar {
  final List<Widget> sidebarItems;
  final Color color;
  final String? title;
  final Widget? footer;
  final Widget? trailing;
  final String? defaultSelection;
  final bool disableCollapsing;
  final Function(bool isCollapsed)? onToggleIsCollapsed;

  CupertinoSidebar({
    required this.sidebarItems,
    required this.color,
    this.title,
    this.footer,
    this.trailing,
    this.defaultSelection,
    this.disableCollapsing = false,
    this.onToggleIsCollapsed,
  });
}
