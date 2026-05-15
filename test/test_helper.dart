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
  Stream<UserProfile?> streamUserProfile() => Stream.value(UserProfile(
        id: 'maya',
        name: 'Maya',
        initials: 'MY',
        bio: 'Bio',
        goals: [],
        weightLb: 178,
        bodyFatPct: 22,
        muscleLb: 138,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));

  @override
  Stream<DailyMetric?> streamTodayMetric() => Stream.value(DailyMetric(
        id: 'today',
        date: DateTime.now(),
        calories: 1430,
        sleepHours: 7.5,
        steps: 8000,
        waterCups: 5,
        wellnessScore: 85,
        recoveryPct: 72,
        energyScore: 7.2,
        calorieTarget: 2100,
        waterTarget: 8,
      ));

  @override
  Stream<List<Activity>> streamActivities() => Stream.value([]);

  @override
  Stream<List<Habit>> streamHabits() => Stream.value([]);

  @override
  Stream<List<Meal>> streamMeals() => Stream.value([]);

  @override
  Future<void> toggleHabit(String id) async {}
}
