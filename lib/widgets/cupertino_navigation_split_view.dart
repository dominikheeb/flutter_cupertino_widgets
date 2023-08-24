import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_widgets/widgets/cupertino_navigation_split_view_header.dart';

import 'cupertino_navigation_split_view_state.dart';

const int ipadBreakpoint = 1024;
const Color _kDefaultNavBarBorderColor = Color(0x4D000000);

class CupertinoNavigationSplitView extends StatefulWidget {
  final String? title;
  final Color color;
  final List<Widget>? sidebarItems;
  final Widget? footer;
  final NavigationViewStyle style;
  final NavigationSplitViewVisibility visibility;
  final Widget detail;

  const CupertinoNavigationSplitView({
    Key? key,
    required this.color,
    this.title,
    this.style = NavigationViewStyle.automatic,
    this.visibility = NavigationSplitViewVisibility.automatic,
    this.sidebarItems,
    this.footer,
    required this.detail,
  }) : super(key: key);

  @override
  State<CupertinoNavigationSplitView> createState() => _CupertinoNavigationSplitViewState();
}

class _CupertinoNavigationSplitViewState extends State<CupertinoNavigationSplitView> {
  bool collapsed = false;
  Orientation? orientation;
  late String selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = "";
  }

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size;
    log(height.toString());

    var newOrientation = MediaQuery.of(context).orientation;

    if (orientation != newOrientation) {
      if (newOrientation == Orientation.landscape) {
        collapsed = false;
      } else {
        collapsed = true;
      }

      orientation = newOrientation;
    }

    var isTablet = true; // TODO: dynamic
    final isLandscape = orientation == Orientation.landscape;
    NavigationSplitViewVisibility effectiveVisibilty;

    log("isLandscape $isLandscape");

    if (widget.visibility != NavigationSplitViewVisibility.automatic) {
      effectiveVisibilty = widget.visibility;
    } else if (isLandscape && collapsed == false) {
      effectiveVisibilty = NavigationSplitViewVisibility.doubleColumn;
    } else if (isLandscape == false && collapsed == false) {
      effectiveVisibilty = NavigationSplitViewVisibility.doubleColumn;
    } else {
      effectiveVisibilty = NavigationSplitViewVisibility.detailOnly;
    }

    void updateSelectedItem(String updatedSelectedItem) {
      setState(() {
        selectedItem = updatedSelectedItem;
      });
    }

    return CupertinoNavigationSplitViewState(
      color: widget.color,
      updateSelectedItem: updateSelectedItem,
      selectedItem: selectedItem,
      child: _sidebarControlWrapper(
        context: context,
        isTablet: isTablet,
        isLandscape: isLandscape,
        effectiveVisibilty: effectiveVisibilty,
        child: Row(
          children: [
            AnimatedSidebar(
              width: effectiveVisibilty == NavigationSplitViewVisibility.doubleColumn && isLandscape ? 323 : 0,
              title: widget.title,
              sidebarItems: widget.sidebarItems ?? [],
              footer: widget.footer,
            ),
            Expanded(
              child: widget.detail,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sidebarControlWrapper({
    required bool isTablet,
    required Widget child,
    required bool isLandscape,
    required BuildContext context,
    required NavigationSplitViewVisibility effectiveVisibilty,
  }) {
    if (isTablet) {
      return Stack(
        children: [
          child,
          AnimatedPositioned(
            left: collapsed ? 10 : 12,
            duration: const Duration(milliseconds: 250),
            child: SafeArea(
              bottom: false,
              right: false,
              child: CupertinoButton(
                padding: const EdgeInsets.all(12),
                onPressed: () {
                  setState(() {
                    collapsed = !collapsed;
                  });
                },
                child: Icon(
                  CupertinoIcons.sidebar_left,
                  color: CupertinoTheme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 320),
            opacity: effectiveVisibilty == NavigationSplitViewVisibility.doubleColumn && isLandscape == false ? 1 : 0,
            child: IgnorePointer(
              ignoring: effectiveVisibilty != NavigationSplitViewVisibility.doubleColumn || isLandscape == true,
              child: GestureDetector(
                onTap: () => setState(() {
                  collapsed = true;
                }),
                child: Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.darkBackgroundGray.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
          AnimatedSidebar(
            width: effectiveVisibilty == NavigationSplitViewVisibility.doubleColumn && isLandscape == false ? 323 : 0,
            title: widget.title,
            sidebarItems: widget.sidebarItems ?? [],
          ),
        ],
      );
    }

    return child;
  }
}

class AnimatedSidebar extends StatelessWidget {
  final double width;
  final String? title;
  final List<Widget> sidebarItems;
  final Widget? footer;

  const AnimatedSidebar({
    Key? key,
    required this.width,
    required this.sidebarItems,
    this.title,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      width: width,
      decoration: BoxDecoration(
        color: CupertinoDynamicColor.resolve(CupertinoColors.secondarySystemBackground, context),
        border: const Border(
          right: BorderSide(
            color: _kDefaultNavBarBorderColor,
            width: 0.0,
          ),
        ),
      ),
      curve: Curves.easeOut,
      child: OverflowBox(
        minWidth: 0,
        maxWidth: double.infinity,
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 323,
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    CupertinoNavigationSplitViewHeader(
                      largeTitle: title,
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(sidebarItems),
                    ),
                  ],
                ),
              ),
              if (footer != null) ...{footer!}
            ],
          ),
        ),
      ),
    );
  }
}

enum NavigationViewStyle {
  automatic,
  column,
  stack,
}

enum NavigationSplitViewVisibility {
  detailOnly,
  automatic,
  doubleColumn,
  all,
}
