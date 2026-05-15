import 'dart:async';

import 'package:firebase_core_platform_interface/test.dart';
import 'package:fitnesspal/core/models/activity.dart';
import 'package:fitnesspal/core/models/daily_metric.dart';
import 'package:fitnesspal/core/models/habit.dart';
import 'package:fitnesspal/core/models/meal.dart';
import 'package:fitnesspal/core/models/user_profile.dart';
import 'package:fitnesspal/core/services/firestore_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Must be called at the top of `main()` in every test file that renders
/// a screen backed by [FirestoreService].
void initFirebaseMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
}

/// A fake [FirestoreService] that returns empty data for every stream,
/// causing screens to display their hardcoded fallback/loading values.
///
/// Register it in `setUp`:
/// ```dart
/// setUp(() async {
///   await Firebase.initializeApp();
///   FirestoreService.setTestInstance(FakeFirestoreService());
/// });
/// ```
class FakeFirestoreService extends FirestoreService {
  FakeFirestoreService() : super.testConstructor();

  @override
  Stream<UserProfile?> streamUserProfile() => Stream.value(null);

  @override
  Stream<DailyMetric?> streamTodayMetric() => Stream.value(null);

  @override
  Stream<List<Activity>> streamActivities() => Stream.value([]);

  @override
  Stream<List<Habit>> streamHabits() => Stream.value([]);

  @override
  Stream<List<Meal>> streamMeals() => Stream.value([]);

  @override
  Future<void> toggleHabit(String id) async {}
}
