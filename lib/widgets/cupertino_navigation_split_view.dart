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
  Orientation? previousOrientation;
  late String selectedSidebarItem;
  late String selectedContentItem;

  @override
  void initState() {
    super.initState();
    selectedSidebarItem = widget.sidebar?.defaultSelection ?? "";
    selectedContentItem = widget.content.defaultSelection ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (previousOrientation != orientation) {
        if (orientation == Orientation.landscape) {
          contentCollapsed = widget.sidebar != null;
        } else {
          contentCollapsed = !widget.content.disableCollapsing;
          sidebarCollapsed = true;
        }

        previousOrientation = orientation;
      }

      var isTablet = true; // TODO: dynamic
      final isLandscape = previousOrientation == Orientation.landscape;
      NavigationSplitViewVisibility effectiveVisibilty;

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
    });
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
        if (MediaQuery.of(context).orientation == Orientation.portrait) {
          sidebarCollapsed = true;
        }
      });
    }

    void updateSelectedContentItem(String updatedSelectedItem) {
      setState(() {
        selectedContentItem = updatedSelectedItem;
        if (MediaQuery.of(context).orientation == Orientation.portrait) {
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
              sidebar: widget.sidebar!,
            ),
          )
        },
        CupertinoNavigationSplitViewState(
          color: widget.content.color,
          updateSelectedItem: updateSelectedContentItem,
          selectedItem: selectedContentItem,
          child: AnimatedSidebar(
            width: !isLandscape || (contentCollapsed && widget.sidebar == null) ? 0 : 323,
            sidebar: widget.content,
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
          if (!widget.content.disableCollapsing) ...{
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
                      widget.content.onToggleIsCollapsed?.call(!contentCollapsed);
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
          },
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
                    sidebar: widget.sidebar!,
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
                  sidebar: widget.content,
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
  final CupertinoSidebar sidebar;

  const AnimatedSidebar({
    Key? key,
    required this.width,
    required this.sidebar,
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
                        largeTitle: sidebar.title,
                        trailing: sidebar.trailing,
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(sidebar.sidebarItems),
                      ),
                    ],
                  ),
                ),
                if (sidebar.footer != null) ...{sidebar.footer!}
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
