import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
  });
}
