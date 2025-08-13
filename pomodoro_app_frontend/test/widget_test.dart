import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_app_frontend/main.dart';

void main() {
  testWidgets('App loads home screen with title', (WidgetTester tester) async {
    await tester.pumpWidget(const PomodoroApp());
    await tester.pumpAndSettle();

    expect(find.text('Pomodoro Ladder'), findsOneWidget);
  });

  testWidgets('Has Roll Dice button disabled by default', (WidgetTester tester) async {
    await tester.pumpWidget(const PomodoroApp());
    await tester.pump();

    final rollButton = find.widgetWithText(ElevatedButton, 'Roll Dice');
    expect(rollButton, findsOneWidget);
  });
}
