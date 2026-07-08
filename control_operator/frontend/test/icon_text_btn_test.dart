/**********************************************************************************
 * Copyright (c) 2026 by Open Vision Technology, LLC., Massachusetts.
 * All rights reserved. This material contains unpublished,
 * copyrighted work, which includes confidential and proprietary
 * information of Open Vision Technology, LLC..
 **********************************************************************************
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/components/icon_text_btn.dart';

void main() {
  testWidgets('IconTextBtn flashing test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: IconTextBtn(
            icon: Icons.abc,
            description: 'Test Btn',
            flashing: true,
            highlightColor: Colors.yellow,
          ),
        ),
      ),
    );

    final iconFinder = find.byType(Icon);
    final textFinder = find.byType(Text);

    Icon icon = tester.widget(iconFinder);
    Text text = tester.widget(textFinder);
    expect(icon.color, Colors.yellow);
    expect(text.style?.color, Colors.yellow);

    // Tick the timer by 1 second
    await tester.pump(const Duration(seconds: 1));

    icon = tester.widget(iconFinder);
    text = tester.widget(textFinder);
    expect(icon.color, Colors.white);
    expect(text.style?.color, Colors.white);

    // Tick the timer by another 1 second
    await tester.pump(const Duration(seconds: 1));

    icon = tester.widget(iconFinder);
    text = tester.widget(textFinder);
    expect(icon.color, Colors.yellow);
    expect(text.style?.color, Colors.yellow);
  });
}
