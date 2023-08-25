import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_widgets/flutter_cupertino_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_app.dart';

const iPadLandscape12InchSize = Size(1366.0, 1024.0);
const iPadPortrait12InchSize = Size(1024.0, 1366.0);

void main() {
  testWidgets('CupertinoNavigationSplitView for 12inch Ipad is showing Sidebar', (tester) async {
    // setup
    tester.binding.window.physicalSizeTestValue = iPadLandscape12InchSize;

    // resets the screen to its original size after the test end
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
/*
    await tester.pumpWidget(
      const TestApp(
        child: CupertinoNavigationSplitView(
          title: "FLUTTER",
          color: CupertinoColors.systemOrange,
          detail: Center(child: Text("Hello World")),
        ),
      ),
    );
*/
    final sideBarFinder = find.byType(AnimatedSidebar);

    expect(sideBarFinder, findsNWidgets(2));

    final foundWidgets = sideBarFinder.evaluate().toList();

    expect(foundWidgets, anyElement(predicate<Element>((v) => v.size?.width == 0)));
    expect(foundWidgets, anyElement(predicate<Element>((v) => v.size?.width != 0)));
  });
}
