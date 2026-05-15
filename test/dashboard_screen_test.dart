import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitnesspal/core/theme/colors.dart';
import 'package:fitnesspal/presentation/screens/dashboard_screen.dart';
import 'package:fitnesspal/presentation/screens/home_screen.dart';

void main() {
  group('DashboardScreen', () {
    testWidgets('renders greeting, score, AI insight, and metric cards',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: DashboardScreen(isDarkMode: true),
        ),
      );

      // Greeting
      expect(find.text('Hi Maya'), findsOneWidget);

      // Wellness score (rendered twice: once in ProgressRing.value, once in centerWidget)
      expect(find.text('84'), findsWidgets);

      // CTA label
      expect(find.text("Today's Plan"), findsOneWidget);

      // AI insight (uses textContaining for the partial match specified by the plan)
      expect(
        find.textContaining('Your recovery is improving'),
        findsWidgets,
      );

      // Metric card labels (some, like "Sleep", also appear in body metrics)
      expect(find.text('Calories'), findsOneWidget);
      expect(find.text('Sleep'), findsWidgets);
      expect(find.text('Steps'), findsOneWidget);
      expect(find.text('Water'), findsOneWidget);
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

      // Verify we start on Home tab (DashboardScreen shows 'Hi Maya')
      expect(find.text('Hi Maya'), findsOneWidget);

      // Get positions of Activity text and icon to find empty area between them
      final textRect = tester.getRect(find.text('Activity'));
      final iconRect = tester.getRect(find.byIcon(Icons.show_chart));

      // Tap in the empty area between icon bottom and text top
      // This is within the GestureDetector but not on the icon or text
      await tester.tapAt(Offset(
        textRect.center.dx,
        (textRect.top + iconRect.bottom) / 2,
      ));
      await tester.pumpAndSettle();

      // Verify Activity screen content appears
      expect(find.text('ACTIVITY'), findsOneWidget);
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

      // Home tab (index 0) is selected by default
      await tester.pump();

      // Find the Container with accentSoft2 decoration color
      // Only the active tab's icon Container should have this
      final activeCue = find.byWidgetPredicate(
        (widget) => widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == AppColors.accentSoft2,
      );
      expect(activeCue, findsOneWidget);
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

      // Tap Activity tab to switch selection away from Home
      await tester.tap(find.text('Activity'));
      await tester.pumpAndSettle();

      // Only one Container should have accentSoft2 (the Activity tab's icon)
      // This proves unselected tabs (Home, Meals, Habits, Profile) do NOT have it
      final activeCues = find.byWidgetPredicate(
        (widget) => widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == AppColors.accentSoft2,
      );
      expect(activeCues, findsOneWidget);
    });
  });
}
