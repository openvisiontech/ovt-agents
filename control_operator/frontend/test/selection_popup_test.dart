/**********************************************************************************
 * Copyright (c) 2026 by Open Vision Technology, LLC., Massachusetts.
 * All rights reserved. This material contains unpublished,
 * copyrighted work, which includes confidential and proprietary
 * information of Open Vision Technology, LLC..
 **********************************************************************************
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/screens/asset_screen.dart';
import 'package:frontend/providers/data_providers.dart';
import 'package:frontend/components/selectable_list.dart';

void main() {
  testWidgets('AssetScreen selection popup rendering and interaction test', (WidgetTester tester) async {
    // Set a larger screen size to prevent layout/overflow errors in test environment
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;

    // Ignore overflow errors caused by font metrics differences in test environment
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('overflowed')) {
        return;
      }
      previousOnError?.call(details);
    };

    // Reset physical size and onError back to default after the test runs
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      FlutterError.onError = previousOnError;
    });

    final container = ProviderContainer();
    final guiData = container.read(guiDataProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: AssetScreen(),
          ),
        ),
      ),
    );

    // Initial state: Selection popup is not visible
    expect(find.byType(SelectableList), findsNothing);

    // Trigger the selection popup
    int? checkedIndex;
    guiData.showSelectionPopup(
      title: 'Select Destination',
      items: const ['Point A', 'Point B', 'Point C'],
      selectedIndex: 1,
      onCheck: (index) {
        checkedIndex = index;
      },
    );

    // Let the widget rebuild with the new state
    await tester.pump();

    // Verify selection popup is now visible with the correct title and items
    expect(find.byType(SelectableList), findsOneWidget);
    expect(find.text('Select Destination'), findsOneWidget);
    expect(find.text('Point A'), findsOneWidget);
    expect(find.text('Point B'), findsOneWidget);
    expect(find.text('Point C'), findsOneWidget);

    // Verify selected index background color (Point B is index 1, should be selected)
    final listTileB = find.widgetWithText(ListTile, 'Point B');
    expect(listTileB, findsOneWidget);
    final containerB = find.ancestor(of: listTileB, matching: find.byType(Container)).first;
    final Container containerWidget = tester.widget(containerB);
    expect(containerWidget.color, Colors.blue[100]);

    // Test selection changes
    // Tap on Point C (index 2)
    await tester.tap(find.text('Point C'));
    await tester.pump();

    // Verify state was updated
    expect(guiData.selectionPopupSelectedIndex, 2);

    // Test arrow navigation
    // Tap up button to go back to Point B
    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pump();
    expect(guiData.selectionPopupSelectedIndex, 1);

    // Tap down button to go to Point C
    await tester.tap(find.byIcon(Icons.arrow_downward));
    await tester.pump();
    expect(guiData.selectionPopupSelectedIndex, 2);

    // Test Check action
    await tester.tap(find.byIcon(Icons.check));
    await tester.pump();

    // Verify callback was triggered with the final index
    expect(checkedIndex, 2);

    // Verify popup is closed
    expect(find.byType(SelectableList), findsNothing);
    expect(guiData.selectionPopupVisible, false);
  });
}
