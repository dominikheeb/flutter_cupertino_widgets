import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_widgets/widgets/cupertino_sidebar_item.dart';

class SidebarItemGroup extends StatefulWidget {
  final String title;
  final List<SidebarItem> sidebarItems;

  const SidebarItemGroup({
    required this.title,
    required this.sidebarItems,
    super.key,
  });

  @override
  State<SidebarItemGroup> createState() => _SidebarItemGroupState();
}

class _SidebarItemGroupState extends State<SidebarItemGroup> {
  var isOpen = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 4),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Icon(
                  isOpen ? CupertinoIcons.chevron_down : CupertinoIcons.chevron_up,
                  size: 18,
                ),
                onTap: () => setState(() {
                  isOpen = !isOpen;
                }),
              ),
              const SizedBox(width: 18)
            ],
          ),
        ),
        if (isOpen) ...widget.sidebarItems,
      ],
    );
  }
}
