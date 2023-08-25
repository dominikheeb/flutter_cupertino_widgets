import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_widgets/flutter_cupertino_widgets.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoDynamicColor.maybeResolve(CupertinoColors.systemBackground, context),
      child: CupertinoNavigationSplitView(
        detail: const Center(child: Text("Hello World")),
        sidebar: CupertinoSidebar(
          title: "Accounts",
          color: CupertinoColors.systemOrange,
          sidebarItems: const [
            SidebarItemGroup(
              title: "Active",
              disableCollapsing: true,
              sidebarItems: [
                SidebarItem(
                  title: "Apple Music",
                  icon: CupertinoIcons.music_note_2,
                ),
                SidebarItem(
                  title: "Spotify",
                  icon: CupertinoIcons.music_mic,
                ),
              ],
            ),
          ],
        ),
        content: CupertinoSidebar(
          title: "Music",
          color: CupertinoColors.systemOrange,
          sidebarItems: const [
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
          footer: const SizedBox(
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
      ),
    );
  }
}
