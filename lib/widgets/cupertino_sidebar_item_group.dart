import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_widgets/widgets/cupertino_sidebar_item.dart';

class SidebarItemGroup extends StatefulWidget {
  final String title;
  final List<SidebarItem> sidebarItems;
  final bool disableCollapsing;

  const SidebarItemGroup({
    required this.title,
    required this.sidebarItems,
    this.disableCollapsing = false,
    super.key,
  });

  @override
  State<SidebarItemGroup> createState() => _SidebarItemGroupState();
}

class _SidebarItemGroupState extends State<SidebarItemGroup> with SingleTickerProviderStateMixin {
  var isOpen = true;
  var turns = 0.25;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _animationController.forward(from: 1);
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 4),
          child: GestureDetector(
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
                if (!widget.disableCollapsing) ...{
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: turns,
                    child: const Icon(
                      CupertinoIcons.chevron_forward,
                      size: 22,
                    ),
                  ),
                },
                const SizedBox(width: 18)
              ],
            ),
            onTap: () => widget.disableCollapsing
                ? null
                : setState(() {
                    isOpen = !isOpen;
                    turns = turns == 0.0 ? 0.25 : 0.0;

                    if (isOpen) {
                      _animationController.forward();
                    } else {
                      _animationController.reverse();
                    }
                  }),
          ),
        ),
        SizeTransition(
          sizeFactor: _animationController,
          axis: Axis.vertical,
          axisAlignment: -1,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: const Offset(0, 0),
            ).animate(_animationController),
            child: Column(
              children: [
                ...widget.sidebarItems,
              ],
            ),
          ),
        )
      ],
    );
  }
}
