import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lib/lib.dart';

void main() {
  // test widgets
  // 1. DisabledBox
  testWidgets('DisabledBox', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const DisabledBox(
        child: Text("Hello"),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('Hello'), findsOneWidget);
  });

  // 2. Panel
  testWidgets('Panel', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const Panel(
        action: TextButton(
          onPressed: null,
          child: Text("Hello"),
        ),
        child: Text("Hello"),
        backgroundColor: Colors.red,
        elevation: 2,
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('Hello'), findsOneWidget);
    expect(find.byType(TextButton), findsOneWidget);
    expect(find.byType(Card), findsOneWidget);
  });

  // 3. ScrollableArea
  testWidgets('ScrollableArea', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ScrollableArea(
        child: Text("Hello"),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('Hello'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
