import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_widgets/flutter_cupertino_widgets.dart';

import 'cupertino_navigation_split_view_state.dart';

const int ipadBreakpoint = 1024;
const Color _kDefaultNavBarBorderColor = Color(0x4D000000);

class CupertinoNavigationSplitView extends StatefulWidget {
  final NavigationViewStyle style;
  final NavigationSplitViewVisibility visibility;
  final CupertinoSidebar? sidebar;
  final CupertinoSidebar content;
  final Widget detail;

  const CupertinoNavigationSplitView({
    Key? key,
    this.sidebar,
    required this.content,
    this.style = NavigationViewStyle.automatic,
    this.visibility = NavigationSplitViewVisibility.automatic,
    required this.detail,
  }) : super(key: key);

  @override
  State<CupertinoNavigationSplitView> createState() => _CupertinoNavigationSplitViewState();
}

class _CupertinoNavigationSplitViewState extends State<CupertinoNavigationSplitView> {
  bool collapsed = false;
  Orientation? orientation;
  late String selectedSidebarItem;
  late String selectedContentItem;

  @override
  void initState() {
    super.initState();
    selectedSidebarItem = "";
    selectedContentItem = "";
  }

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size;
    log(height.toString());

    var newOrientation = MediaQuery.of(context).orientation;

    if (orientation != newOrientation) {
      if (newOrientation == Orientation.landscape) {
        collapsed = widget.sidebar != null;
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
    );
  }

  Widget _sidebarControlWrapper({
    required bool isTablet,
    required bool isLandscape,
    required BuildContext context,
    required NavigationSplitViewVisibility effectiveVisibilty,
  }) {
    void updateSelectedSidebarItem(String updatedSelectedItem) {
      setState(() {
        selectedSidebarItem = updatedSelectedItem;
      });
    }

    void updateSelectedContentItem(String updatedSelectedItem) {
      setState(() {
        selectedContentItem = updatedSelectedItem;
      });
    }

    final child = Row(
      children: [
        if (widget.sidebar != null) ...{
          CupertinoNavigationSplitViewState(
            color: widget.content.color,
            updateSelectedItem: updateSelectedSidebarItem,
            selectedItem: selectedSidebarItem,
            child: AnimatedSidebar(
              width: effectiveVisibilty == NavigationSplitViewVisibility.doubleColumn && isLandscape ? 323 : 0,
              title: widget.sidebar!.title,
              sidebarItems: widget.sidebar!.sidebarItems ?? [],
              footer: widget.sidebar!.footer,
            ),
          )
        },
        CupertinoNavigationSplitViewState(
          color: widget.content.color,
          updateSelectedItem: updateSelectedContentItem,
          selectedItem: selectedContentItem,
          child: AnimatedSidebar(
            width: !isLandscape ? 0 : 323,
            title: widget.content.title,
            sidebarItems: widget.content.sidebarItems ?? [],
            footer: widget.content.footer,
          ),
        ),
        Expanded(
          child: widget.detail,
        ),
      ],
    );

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
          CupertinoNavigationSplitViewState(
            color: widget.content.color,
            updateSelectedItem: updateSelectedContentItem,
            selectedItem: selectedContentItem,
            child: AnimatedSidebar(
              width: effectiveVisibilty == NavigationSplitViewVisibility.doubleColumn && isLandscape == false ? 323 : 0,
              title: widget.content.title,
              sidebarItems: widget.content.sidebarItems ?? [],
            ),
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
    return ClipRect(
      child: AnimatedContainer(
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
