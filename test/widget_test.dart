import 'package:flutter_test/flutter_test.dart';

import 'package:fitnesspal/presentation/app.dart';

void main() {
  testWidgets('FitnessPal app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FitnessPalApp());

    // Verify the app renders the home screen with the greeting
    expect(find.text('Hi Maya'), findsOneWidget);

    // Verify the bottom navigation is present
    expect(find.text('Home'), findsOneWidget);
  });
}
