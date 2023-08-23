import 'package:flutter/cupertino.dart';

class CupertinoNavigationSplitViewState extends InheritedWidget {
  final Color color;
  final void Function(String selectedItem) updateSelectedItem;
  final String? selectedItem;

  const CupertinoNavigationSplitViewState({
    super.key,
    required this.color,
    required this.updateSelectedItem,
    this.selectedItem,
    required super.child,
  });

  static CupertinoNavigationSplitViewState? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CupertinoNavigationSplitViewState>();
  }

  static CupertinoNavigationSplitViewState of(BuildContext context) {
    final CupertinoNavigationSplitViewState? result = maybeOf(context);
    assert(result != null, 'No CupertionoNavigationSplitViewState found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(CupertinoNavigationSplitViewState oldWidget) {
    return color != oldWidget.color || selectedItem != oldWidget.selectedItem;
  }
}
