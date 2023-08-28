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
  bool contentCollapsed = false;
  bool sidebarCollapsed = true;
  bool isInteractable = true;
  Orientation? orientation;
  String selectedSidebarItem = "";
  String selectedContentItem = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var newOrientation = MediaQuery.of(context).orientation;

    if (orientation != newOrientation) {
      if (newOrientation == Orientation.landscape) {
        contentCollapsed = widget.sidebar != null;
      } else {
        contentCollapsed = true;
        sidebarCollapsed = true;
      }

      orientation = newOrientation;
    }

    var isTablet = true; // TODO: dynamic
    final isLandscape = orientation == Orientation.landscape;
    NavigationSplitViewVisibility effectiveVisibilty;

    log("isLandscape $isLandscape");

    if (widget.visibility != NavigationSplitViewVisibility.automatic) {
      effectiveVisibilty = widget.visibility;
    } else if (isLandscape && contentCollapsed == false) {
      effectiveVisibilty = NavigationSplitViewVisibility.doubleColumn;
    } else if (isLandscape == false && contentCollapsed == false) {
      effectiveVisibilty = sidebarCollapsed ? NavigationSplitViewVisibility.doubleColumn : NavigationSplitViewVisibility.all;
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
        if (!isLandscape) {
          sidebarCollapsed = true;
        }
      });
    }

    void updateSelectedContentItem(String updatedSelectedItem) {
      setState(() {
        selectedContentItem = updatedSelectedItem;
        if (!isLandscape) {
          sidebarCollapsed = true;
          contentCollapsed = true;
        }
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
              trailing: widget.sidebar!.trailing,
            ),
          )
        },
        CupertinoNavigationSplitViewState(
          color: widget.content.color,
          updateSelectedItem: updateSelectedContentItem,
          selectedItem: selectedContentItem,
          child: AnimatedSidebar(
            width: !isLandscape || (contentCollapsed && widget.sidebar == null) ? 0 : 323,
            title: widget.content.title,
            sidebarItems: widget.content.sidebarItems ?? [],
            footer: widget.content.footer,
            trailing: widget.content.trailing,
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
            left: contentCollapsed ? 10 : 12,
            duration: const Duration(milliseconds: 250),
            child: SafeArea(
              bottom: false,
              right: false,
              child: CupertinoButton(
                padding: const EdgeInsets.all(12),
                onPressed: () {
                  setState(() {
                    contentCollapsed = !contentCollapsed;
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
            opacity: (effectiveVisibilty == NavigationSplitViewVisibility.doubleColumn ||
                        effectiveVisibilty == NavigationSplitViewVisibility.all) &&
                    isLandscape == false
                ? 1
                : 0,
            child: IgnorePointer(
              ignoring: (effectiveVisibilty != NavigationSplitViewVisibility.doubleColumn &&
                      effectiveVisibilty != NavigationSplitViewVisibility.all) ||
                  isLandscape == true,
              child: GestureDetector(
                onTap: () => setState(() {
                  contentCollapsed = true;
                  sidebarCollapsed = true;
                }),
                child: Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.darkBackgroundGray.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              if (widget.sidebar != null) ...{
                CupertinoNavigationSplitViewState(
                  color: widget.sidebar!.color,
                  updateSelectedItem: updateSelectedSidebarItem,
                  selectedItem: selectedSidebarItem,
                  child: AnimatedSidebar(
                    width: effectiveVisibilty == NavigationSplitViewVisibility.all && isLandscape == false ? 323 : 0,
                    title: widget.sidebar!.title,
                    sidebarItems: widget.sidebar!.sidebarItems ?? [],
                    footer: widget.sidebar!.footer,
                    trailing: widget.sidebar!.trailing,
                  ),
                ),
              },
              CupertinoNavigationSplitViewState(
                color: widget.content.color,
                updateSelectedItem: updateSelectedContentItem,
                selectedItem: selectedContentItem,
                child: AnimatedSidebar(
                  width: (effectiveVisibilty == NavigationSplitViewVisibility.doubleColumn ||
                              effectiveVisibilty == NavigationSplitViewVisibility.all) &&
                          isLandscape == false
                      ? 323
                      : 0,
                  title: widget.content.title,
                  sidebarItems: widget.content.sidebarItems ?? [],
                  footer: widget.content.footer,
                  trailing: widget.content.trailing,
                ),
              ),
            ],
          ),
          if (!contentCollapsed && !isLandscape && widget.sidebar != null && sidebarCollapsed) ...{
            AnimatedPositioned(
              left: 12,
              duration: const Duration(milliseconds: 250),
              child: SafeArea(
                bottom: false,
                right: false,
                child: CupertinoButton(
                  padding: const EdgeInsets.all(12),
                  onPressed: () {
                    setState(() {
                      sidebarCollapsed = !sidebarCollapsed;
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.chevron_back,
                        color: CupertinoTheme.of(context).primaryColor,
                      ),
                      Text(widget.sidebar!.title ?? "")
                    ],
                  ),
                ),
              ),
            ),
          }
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
  final Widget? trailing;

  const AnimatedSidebar({
    Key? key,
    required this.width,
    required this.sidebarItems,
    this.title,
    this.footer,
    this.trailing,
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
                        trailing: trailing,
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
