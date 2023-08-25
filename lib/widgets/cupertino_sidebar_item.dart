import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_widgets/widgets/cupertino_navigation_split_view_state.dart';

class SidebarItem extends StatelessWidget {
  final String title;
  final String trailing;
  final String subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Function()? onTap;
  final bool showNotificationDot;

  const SidebarItem({
    required this.title,
    this.subtitle = "",
    this.trailing = "",
    this.icon,
    this.iconColor,
    this.onTap,
    this.showNotificationDot = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sidebarState = CupertinoNavigationSplitViewState.of(context);
    final isSelected = sidebarState.selectedItem == title;
    final color = iconColor ?? sidebarState.color;

    return GestureDetector(
      child: Stack(children: [
        if (showNotificationDot && !isSelected) ...{
          Positioned(
            top: 18,
            left: 8,
            child: Container(
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        },
        Padding(
          padding: const EdgeInsets.only(left: 14, right: 14.0),
          child: Container(
            decoration: BoxDecoration(
                color: isSelected ? color : CupertinoColors.white.withAlpha(0),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                )),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: subtitle.isEmpty ? 10.0 : 4.0),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  if (icon != null) ...{
                    Icon(
                      icon,
                      color: isSelected ? CupertinoColors.white : color,
                    ),
                  },
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(color: isSelected ? CupertinoColors.white : CupertinoColors.black),
                        ),
                        if (subtitle.isNotEmpty) ...{
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: isSelected ? CupertinoColors.white : CupertinoColors.systemGrey,
                              fontSize: 12,
                            ),
                          ),
                        }
                      ],
                    ),
                  ),
                  Text(
                    trailing,
                    style: TextStyle(
                      color: isSelected ? CupertinoColors.white : CupertinoColors.systemGrey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
      onTap: () {
        sidebarState.updateSelectedItem(title);
        onTap?.call();
      },
    );
  }
}
