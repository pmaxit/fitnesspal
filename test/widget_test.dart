import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitnesspal/core/services/firestore_service.dart';
import 'package:fitnesspal/presentation/app.dart';

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

  testWidgets('FitnessPal app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FitnessPalApp());

    // No greeting shown when profile data is absent
    expect(find.text('Hi Maya'), findsNothing);

    // Verify the bottom navigation is present
    expect(find.text('Home'), findsOneWidget);
  });
}
