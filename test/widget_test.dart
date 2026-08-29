import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplease/app.dart';

void main() {
  testWidgets('FoodPlease inicia correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodPleaseApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}