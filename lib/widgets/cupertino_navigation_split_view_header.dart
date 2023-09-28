import 'dart:ui';

import 'package:flutter/cupertino.dart';

const Color _kDefaultNavBarBorderColor = Color(0x4D000000);
const CupertinoDynamicColor _kDefaultNavBarHeaderColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xF0F9F9F9),
  darkColor: Color(0xF01D1D1D),
);

class CupertinoNavigationSplitViewHeader extends StatelessWidget {
  final double headerHeight;
  final double largeTitleHorizontalPadding;
  final String? largeTitle;
  final Widget? trailing;
  final Widget? leading;

  const CupertinoNavigationSplitViewHeader({
    Key? key,
    this.headerHeight = 76,
    this.largeTitleHorizontalPadding = 24,
    this.largeTitle,
    this.trailing,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final largeTitleStyle = CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _CupertinoNavigationSplitViewHeaderDelegate(
        headerHeight: headerHeight,
        largeTitleStyle: largeTitleStyle,
        largeTitleHorizontalPadding: largeTitleHorizontalPadding,
        largeTitle: largeTitle,
        trailing: trailing,
        leading: leading,
      ),
    );
  }
}

class _CupertinoNavigationSplitViewHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double headerHeight;
  final TextStyle largeTitleStyle;
  final double largeTitlePadding = 6;
  final double largeTitleHorizontalPadding;
  final String? largeTitle;
  final Widget? trailing;
  final Widget? leading;

  double get largeTitleHeight => largeTitle != null && largeTitle!.isNotEmpty
      ? ((largeTitleStyle.fontSize ?? 24) + (largeTitleStyle.height ?? 1)) + 1 + 2 * largeTitlePadding
      : 0;

  _CupertinoNavigationSplitViewHeaderDelegate({
    required this.headerHeight,
    required this.largeTitleStyle,
    required this.largeTitleHorizontalPadding,
    this.largeTitle,
    this.trailing,
    this.leading,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    var value = shrinkOffset - largeTitleHeight - 6;

    var length = 12;

    var t = (value / length).clamp(0, 1).toDouble();

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: SizedBox(
            height: headerHeight,
            child: Stack(
              children: [
                if (shrinkOffset > largeTitleHeight) ...{
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Opacity(
                        opacity: t,
                        child: Container(
                          decoration: BoxDecoration(
                            color: CupertinoDynamicColor.resolve(
                              _kDefaultNavBarHeaderColor,
                              context,
                            ),
                            border: const Border(
                              bottom: BorderSide(
                                color: _kDefaultNavBarBorderColor,
                                width: 0.0, // 0.0 means one physical pixel
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                },
                if (largeTitle != null && largeTitle!.isNotEmpty) ...{
                  AnimatedOpacity(
                    opacity: shrinkOffset >= largeTitleHeight ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: SafeArea(
                      bottom: false,
                      left: false,
                      right: false,
                      child: Container(
                        padding: const EdgeInsets.only(
                          bottom: 16,
                        ),
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          largeTitle!,
                          style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                        ),
                      ),
                    ),
                  ),
                },
              ],
            ),
          ),
        ),
        if (largeTitle != null && largeTitle!.isNotEmpty) ...{
          Positioned(
            top: headerHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              child: OverflowBox(
                minHeight: 0.0,
                maxHeight: double.infinity,
                alignment: AlignmentDirectional.bottomStart,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: largeTitleHorizontalPadding,
                    bottom: 4,
                    right: largeTitleHorizontalPadding,
                  ),
                  child: Text(
                    largeTitle!,
                    style: largeTitleStyle,
                  ),
                ),
              ),
            ),
          ),
        },
        if (leading != null) ...{
          Positioned(
            top: 36,
            left: 20,
            child: leading!,
          ),
        },
        if (trailing != null) ...{
          Positioned(
            top: 36,
            right: 20,
            child: trailing!,
          ),
        },
      ],
    );
  }

  @override
  double get maxExtent => headerHeight + largeTitleHeight;

  @override
  double get minExtent => headerHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
