import 'package:flutter/cupertino.dart';

class TestApp extends StatelessWidget {
  final Widget child;

  const TestApp({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.systemOrange,
      ),
      home: Container(
        color: CupertinoDynamicColor.maybeResolve(CupertinoColors.systemBackground, context),
        child: child,
      ),
    );
  }
}
