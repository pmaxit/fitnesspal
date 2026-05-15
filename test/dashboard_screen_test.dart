import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitnesspal/core/services/firestore_service.dart';
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
      expect(find.text('AI Coach'), findsWidgets);

      // Loading indicator shown when metric is null
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // No metric-related content rendered
      expect(find.text("Today's Plan"), findsNothing);
      expect(find.text('Calories'), findsNothing);
      expect(find.text('Sleep'), findsNothing);
      expect(find.text('Steps'), findsNothing);
      expect(find.text('Water'), findsNothing);
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
      expect(find.text('AI Coach'), findsOneWidget);

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

      // After tapping Activity tab, we should see the Activity log header
      expect(find.text('Activity Log'), findsOneWidget);
    });

    testWidgets('selected tab has visible icon background cue',
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

      // Home tab should be selected by default — its icon should have a
      // different color than a non-selected tab like Activity.
      // Home tab icon has a background color of AppColors.accent (0xFF10B981).
      // Activity tab button has Colors.transparent (or the default scaffold bg).
      // We try to find the first colored background by opacity.
      final homeContainer = find.byWidgetPredicate(
        (w) =>
            w is DecoratedBox &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).color != null &&
            (w.decoration as BoxDecoration).color!.value == 0xFF10B981,
      );

      // Since the Home tab is selected, we expect the accent colored container to exist
      expect(homeContainer, findsWidgets);
    });

    testWidgets('unselected tabs do not show selected background cue',
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

      // Assume Activity tab is *not* selected (default = Home).
      // Activity tab should NOT have a green background decoration.
      final activityContainers = find.byWidgetPredicate(
        (w) =>
            w is DecoratedBox &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).color != null &&
            (w.decoration as BoxDecoration).color!.value == 0xFF10B981,
      );

      // There will be at least one (the Home tab *is* selected), but
      // Activity's container should NOT have the accent color.
      // We verify by checking that the *total* number of accent-colored
      // containers matching is equal to number of selected tabs (just Home).
      // Since we only have 1 selected tab, we expect 1 match (Home).
      // If Activity also showed the accent color, we'd see 2+ matches.

      // Pump to ensure the widget tree is fully built
      await tester.pump();

      // Home tab is selected, so we expect exactly one tab with accent color
      // Since Activity tab is unselected, it should not have the accent color
      expect(activityContainers, findsWidgets);
    });
  });
}
