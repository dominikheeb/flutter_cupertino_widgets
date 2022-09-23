import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_widgets/flutter_cupertino_widgets.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoDynamicColor.maybeResolve(
          CupertinoColors.systemBackground, context),
      child: const CupertinoNavigationSplitView(
        title: "FLUTTER",
        detail: Center(child: Text("Hello World")),
      ),
    );
  }
}
