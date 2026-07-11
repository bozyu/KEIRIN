import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keirin/main.dart';

void main() {
  testWidgets('shows setup feed and opens add setup sheet', (tester) async {
    await tester.pumpWidget(const KeirinApp());

    expect(find.text('KEIRIN'), findsOneWidget);
    expect(find.text('сэтапы fixed gear'), findsOneWidget);
    expect(find.text('0 сэтапов в ленте'), findsOneWidget);
    expect(find.text('ну типа лол, добавь хоть чё нить. смешно? а мне нет.'),
        findsOneWidget);
    expect(find.text('фиксы'), findsOneWidget);
    expect(find.text('мои сэтапы'), findsOneWidget);
    expect(find.text('настройки'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('новый сэтап'), findsOneWidget);
    expect(find.text('юзерку бро'), findsOneWidget);
    expect(find.text('рама'), findsWidgets);
  });
}
