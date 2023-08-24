import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_widgets/flutter_cupertino_widgets.dart';
import 'package:flutter_cupertino_widgets/widgets/cupertino_sidebar_item.dart';
import 'package:flutter_cupertino_widgets/widgets/cupertino_sidebar_item_group.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoDynamicColor.maybeResolve(CupertinoColors.systemBackground, context),
      child: const CupertinoNavigationSplitView(
        color: CupertinoColors.systemOrange,
        title: "Music",
        detail: Center(child: Text("Hello World")),
        sidebarItems: [
          SidebarItem(
            title: "Listen Now",
            icon: CupertinoIcons.play_circle,
          ),
          SidebarItem(
            title: "Browse",
            icon: CupertinoIcons.square_grid_2x2,
          ),
          SidebarItem(
            title: "Radio",
            icon: CupertinoIcons.dot_radiowaves_left_right,
          ),
          SidebarItem(
            title: "Search",
            icon: CupertinoIcons.search,
          ),
          SidebarItemGroup(
            title: "Library",
            sidebarItems: [
              SidebarItem(
                title: "Recently Added",
                icon: CupertinoIcons.clock,
                subtitle: "23.09.2023",
              ),
              SidebarItem(
                title: "Albums",
                icon: CupertinoIcons.music_albums,
              ),
            ],
          ),
          SidebarItemGroup(
            title: "Playlists",
            sidebarItems: [
              SidebarItem(
                title: "Workout",
                icon: CupertinoIcons.list_bullet,
                trailing: "23",
              ),
              SidebarItem(
                title: "Dance",
                icon: CupertinoIcons.list_bullet,
                trailing: "45",
              ),
            ],
          ),
        ],
        footer: SizedBox(
          height: 48,
          child: Text(
            "+ Playlist",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: CupertinoColors.systemOrange,
            ),
          ),
        ),
      ),
    );
  }
}
