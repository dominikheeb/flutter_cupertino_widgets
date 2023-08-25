import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_widgets/flutter_cupertino_widgets.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String contentText = "Nothing selected";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoDynamicColor.maybeResolve(CupertinoColors.systemBackground, context),
      child: CupertinoNavigationSplitView(
        detail: Center(child: Text(contentText)),
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
                  iconColor: CupertinoColors.systemPink,
                ),
                SidebarItem(
                  title: "Spotify",
                  icon: CupertinoIcons.music_mic,
                  iconColor: CupertinoColors.systemGreen,
                ),
              ],
            ),
          ],
        ),
        content: CupertinoSidebar(
          title: "Music",
          color: CupertinoColors.systemOrange,
          sidebarItems: [
            SidebarItem(
              title: "Listen Now",
              icon: CupertinoIcons.play_circle,
              onTap: () => setState(() {
                contentText = "Listen Now";
              }),
            ),
            SidebarItem(
              title: "Browse",
              icon: CupertinoIcons.square_grid_2x2,
              onTap: () => setState(() {
                contentText = "Browse";
              }),
            ),
            SidebarItem(
              title: "Radio",
              icon: CupertinoIcons.dot_radiowaves_left_right,
              onTap: () => setState(() {
                contentText = "Radio";
              }),
            ),
            SidebarItem(
              title: "Search",
              icon: CupertinoIcons.search,
              onTap: () => setState(() {
                contentText = "Search";
              }),
            ),
            SidebarItemGroup(
              title: "Library",
              sidebarItems: [
                SidebarItem(
                  title: "Recently Added",
                  icon: CupertinoIcons.clock,
                  subtitle: "23.09.2023",
                  onTap: () => setState(() {
                    contentText = "Recently Added";
                  }),
                ),
                SidebarItem(
                  title: "Albums",
                  icon: CupertinoIcons.music_albums,
                  onTap: () => setState(() {
                    contentText = "Albums";
                  }),
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
                  onTap: () => setState(() {
                    contentText = "Workout";
                  }),
                ),
                SidebarItem(
                  title: "Dance",
                  icon: CupertinoIcons.list_bullet,
                  trailing: "45",
                  onTap: () => setState(() {
                    contentText = "Dance";
                  }),
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
