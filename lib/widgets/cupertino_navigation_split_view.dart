import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_widgets/widgets/cupertino_navigation_split_view_header.dart';

const int ipadBreakpoint = 1024;
const Color _kDefaultNavBarBorderColor = Color(0x4D000000);

class CupertinoNavigationSplitView extends StatefulWidget {
  final String? title;
  final NavigationViewStyle style;
  final NavigationSplitViewVisibility visibility;
  final Widget detail;

  const CupertinoNavigationSplitView({
    Key? key,
    this.title,
    this.style = NavigationViewStyle.automatic,
    this.visibility = NavigationSplitViewVisibility.automatic,
    required this.detail,
  }) : super(key: key);

  @override
  State<CupertinoNavigationSplitView> createState() =>
      _CupertinoNavigationSplitViewState();
}

class _CupertinoNavigationSplitViewState
    extends State<CupertinoNavigationSplitView> {
  bool collapsed = false;
  Orientation? orientation;

  @override
  void initState() {
    super.initState();
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

    return _sidebarControlWrapper(
      context: context,
      isTablet: isTablet,
      isLandscape: isLandscape,
      effectiveVisibilty: effectiveVisibilty,
      child: Row(
        children: [
          AnimatedSidebar(
            width: effectiveVisibilty ==
                        NavigationSplitViewVisibility.doubleColumn &&
                    isLandscape
                ? 323
                : 0,
            title: widget.title,
          ),
          Expanded(
            child: widget.detail,
          ),
        ],
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
            opacity: effectiveVisibilty ==
                        NavigationSplitViewVisibility.doubleColumn &&
                    isLandscape == false
                ? 1
                : 0,
            child: IgnorePointer(
              ignoring: effectiveVisibilty !=
                      NavigationSplitViewVisibility.doubleColumn ||
                  isLandscape == true,
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
            width: effectiveVisibilty ==
                        NavigationSplitViewVisibility.doubleColumn &&
                    isLandscape == false
                ? 323
                : 0,
            title: widget.title,
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

  const AnimatedSidebar({
    Key? key,
    required this.width,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      width: width,
      decoration: BoxDecoration(
        color: CupertinoDynamicColor.resolve(
            CupertinoColors.secondarySystemBackground, context),
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
          child: CustomScrollView(
            slivers: [
              CupertinoNavigationSplitViewHeader(
                largeTitle: title,
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text("a"),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text("a"),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text("a"),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text("a"),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text("a"),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text("a"),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text("a"),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text("a"),
                  ),
                ]),
              )
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
