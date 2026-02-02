// Stephen King Books App - Widget Tests
// Test the main app structure and navigation

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_base_flutter/main.dart';

void main() {
  testWidgets('App loads and shows navigation bar', (WidgetTester tester) async {
    // Initialize dependencies for testing
    // Note: In a real app, you'd mock the dependencies
    // For now, we'll just verify the app structure loads

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app loads (MaterialApp is present)
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify bottom navigation bar exists
    expect(find.byType(NavigationBar), findsOneWidget);

    // Verify Dashboard and Book List destinations exist
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Book List'), findsOneWidget);
  });
}
