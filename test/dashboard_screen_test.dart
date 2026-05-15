import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitnesspal/core/services/firestore_service.dart';
import 'package:fitnesspal/core/theme/colors.dart';
import 'package:fitnesspal/presentation/screens/dashboard_screen.dart';
import 'package:fitnesspal/presentation/screens/home_screen.dart';

import 'test_helper.dart';

void main() {
  initFirebaseMocks();

  setUp(() async {
    await Firebase.initializeApp();
    FirestoreService.setTestInstance(FakeFirestoreService());
  });

  tearDown(() {
    FirestoreService.resetTestInstance();
  });

  group('DashboardScreen', () {
    testWidgets('shows loading state when Firestore returns null data',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(isDarkMode: true),
        ),
      );

      // No greeting shown when profile is null
      expect(find.text('Hi Maya'), findsNothing);

      // Header elements still present
      expect(find.text('GOOD MORNING'), findsOneWidget);

      // Loading indicator shown when metric is null
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // No metric-related content rendered
      expect(find.text('YOUR TRAJECTORY'), findsNothing);
      expect(find.text('MUSCLE'), findsNothing);
      expect(find.text('RECOVERY'), findsNothing);
      expect(find.text('BODY FAT'), findsNothing);
      expect(find.text('WEIGHT'), findsNothing);
    });

    testWidgets('shows trajectory stats when data is loaded',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(isDarkMode: true),
        ),
      );
      
      // Wait for stream emissions
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Hi, Maya'), findsOneWidget);
      expect(find.text('Hi, Maya'), findsOneWidget);
      expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('138')), findsOneWidget); // Muscle
      expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('72')), findsOneWidget);  // Recovery
      expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('22')), findsOneWidget);  // Body Fat
      expect(find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('178')), findsOneWidget); // Weight
    });
  });

  group('HomeScreen bottom navigation', () {
    testWidgets('renders all bottom nav tab labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            isDarkMode: true,
            onThemeToggle: () {},
            isCompactDensity: false,
            onDensityToggle: () {},
          ),
        ),
      );

      // Bottom nav labels
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Activity'), findsOneWidget);
      expect(find.text('Meals'), findsOneWidget);
      expect(find.text('Habits'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets(
        'tapping empty area inside Activity tab cell switches to Activity tab',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            isDarkMode: true,
            onThemeToggle: () {},
            isCompactDensity: false,
            onDensityToggle: () {},
          ),
        ),
      );

      // Verify we start on Home tab (DashboardScreen shows loading state)
      expect(find.text('GOOD MORNING'), findsOneWidget);

      // Get positions of Activity text and

      // Get positions of the bottom nav items
      final activityItem = tester.getTopLeft(find.text('Activity'));
      final mealsItem = tester.getTopLeft(find.text('Meals'));

      // Tap the area that should correspond to Activity tab.
      // We tap in the space between Activity and Meals to hit the invisible
      // tappable area (InkWell / GestureDetector) of the Activity tab.
      final tabCenter =
          Offset((activityItem.dx + mealsItem.dx) / 2, activityItem.dy + 12);

      await tester.tapAt(tabCenter);
      await tester.pumpAndSettle();

      // After tapping Activity tab, we should see the Timeline header
      expect(find.text('Timeline'), findsOneWidget);
    });


  });
}
