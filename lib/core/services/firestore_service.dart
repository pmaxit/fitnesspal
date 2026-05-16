import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fitnesspal/core/models/user_profile.dart';
import 'package:fitnesspal/core/models/daily_metric.dart';
import 'package:fitnesspal/core/models/meal.dart';
import 'package:fitnesspal/core/models/activity.dart';
import 'package:fitnesspal/core/models/habit.dart';

/// Centralized service for all Firestore CRUD operations.
///
/// Uses a hardcoded [userId] ('demo-user-1') since the app has no
/// authentication yet. Exposes a mix of [Stream]-based APIs for
/// real-time updates and one-shot [Future] fetches where appropriate.
///
/// Every public method catches [FirestoreException] internally and
/// returns a fallback value so callers never need to wrap calls in
/// try/catch for transient Firestore errors.
class FirestoreService {
  static FirestoreService? _instance;

  final FirebaseFirestore _db;

  /// Internal constructor used by the factory and subclasses.
  @visibleForTesting
  FirestoreService.testConstructor({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  /// Main factory – returns the same singleton instance.
  ///
  /// Tests can call [setTestInstance] before the first access to inject a mock.
  factory FirestoreService({FirebaseFirestore? firestore}) {
    // If a test instance was registered, return it regardless of parameters.
    if (_instance != null) return _instance!;
    _instance = FirestoreService.testConstructor(firestore: firestore);
    return _instance!;
  }

  /// Replace the singleton with a test double. Call [resetTestInstance] in
  /// tearDown to restore the default behaviour.
  @visibleForTesting
  static void setTestInstance(FirestoreService service) {
    _instance = service;
  }

  @visibleForTesting
  static void resetTestInstance() {
    _instance = null;
  }

  // ------------------------------------------------------------------
  // User identity
  // ------------------------------------------------------------------

  String _userId = 'demo-user-1';

  String get userId => _userId;
  set userId(String id) => _userId = id;

  // ------------------------------------------------------------------
  // Collection helpers
  // ------------------------------------------------------------------

  DocumentReference<Map<String, dynamic>> get _profileRef =>
      _db.doc('users/$_userId').collection('profile').doc('data');

  CollectionReference<Map<String, dynamic>> get _dailyMetricsCollection =>
      _db.collection('users/$_userId/dailyMetrics');

  CollectionReference<Map<String, dynamic>> get _mealsCollection =>
      _db.collection('users/$_userId/meals');

  CollectionReference<Map<String, dynamic>> get _activitiesCollection =>
      _db.collection('users/$_userId/activities');

  CollectionReference<Map<String, dynamic>> get _habitsCollection =>
      _db.collection('users/$_userId/habits');

  // ------------------------------------------------------------------
  // User Profile
  // ------------------------------------------------------------------

  /// Persist (create or overwrite) the user's profile document.
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      await _profileRef.set(profile.toJson());
    } on FirebaseException {
      // Silently absorb – caller can observe the stream for confirmation.
    }
  }

  /// Real-time stream of the user's profile document.
  Stream<UserProfile?> streamUserProfile() {
    return _profileRef.snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      final data = snap.data()!;
      return UserProfile.fromJson(<String, dynamic>{...data, 'id': snap.id});
    });
  }

  /// One-shot fetch of the user's profile.
  Future<UserProfile?> getUserProfile() async {
    try {
      final snap = await _profileRef.get();
      if (!snap.exists || snap.data() == null) return null;
      final data = snap.data()!;
      return UserProfile.fromJson(<String, dynamic>{...data, 'id': snap.id});
    } on FirebaseException {
      return null;
    }
  }

  // ------------------------------------------------------------------
  // Daily Metrics
  // ------------------------------------------------------------------

  /// Real-time stream of today's metric document.
  ///
  /// The document ID is the ISO date string (e.g. `2026-05-14`).
  Stream<DailyMetric?> streamTodayMetric() {
    final today = _todayDate();
    return _dailyMetricsCollection.doc(today).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return DailyMetric.fromJson(snap.data()!);
    });
  }

  /// Persist a daily metric (upserts by date string).
  Future<void> saveDailyMetric(DailyMetric metric) async {
    try {
      final dateStr = '${metric.date.year}-${_pad(metric.date.month)}-${_pad(metric.date.day)}';
      await _dailyMetricsCollection.doc(dateStr).set(metric.toJson());
    } on FirebaseException {
      // Silently absorb.
    }
  }

  // ------------------------------------------------------------------
  // Meals
  // ------------------------------------------------------------------

  /// Real-time stream of all meals ordered by timestamp descending.
  Stream<List<Meal>> streamMeals() {
    return _mealsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_snapshotToList<Meal>(Meal.fromJson));
  }

  /// Add a new meal document. Firestore auto-generates the document ID.
  Future<void> addMeal(Meal meal) async {
    try {
      await _mealsCollection.add(meal.toJson());
    } on FirebaseException {
      // Silently absorb.
    }
  }

  /// Delete a meal by its document ID.
  Future<void> deleteMeal(String mealId) async {
    try {
      await _mealsCollection.doc(mealId).delete();
    } on FirebaseException {
      // Silently absorb.
    }
  }

  // ------------------------------------------------------------------
  // Activities
  // ------------------------------------------------------------------

  /// Real-time stream of all activities ordered by timestamp descending.
  Stream<List<Activity>> streamActivities() {
    return _activitiesCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map(_snapshotToList<Activity>(Activity.fromJson));
  }

  /// Add a new activity document.
  Future<void> addActivity(Activity activity) async {
    try {
      await _activitiesCollection.add(activity.toJson());
    } on FirebaseException {
      // Silently absorb.
    }
  }

  // ------------------------------------------------------------------
  // Habits
  // ------------------------------------------------------------------

  /// Real-time stream of all habits.
  Stream<List<Habit>> streamHabits() {
    return _habitsCollection
        .snapshots()
        .map(_snapshotToList<Habit>(Habit.fromJson));
  }

  /// Toggle the completion state of a habit.
  ///
  /// Reads the current document, flips [Habit.isCompleted], and writes
  /// back. Falls back silently on error.
  Future<void> toggleHabit(String habitId) async {
    try {
      await _db.runTransaction((transaction) async {
        final ref = _habitsCollection.doc(habitId);
        final snap = await transaction.get(ref);
        if (!snap.exists || snap.data() == null) return;

        final habit = Habit.fromJson(snap.data()!);
        final isCompleting = !habit.isCompleted;
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        
        List<DateTime> completedDates = List.from(habit.completedDates);
        if (isCompleting) {
          if (!completedDates.any((d) => d.year == today.year && d.month == today.month && d.day == today.day)) {
            completedDates.add(today);
          }
        } else {
          completedDates.removeWhere((d) => d.year == today.year && d.month == today.month && d.day == today.day);
        }

        final updated = habit.copyWith(
          isCompleted: isCompleting,
          completedDates: completedDates,
        );
        transaction.set(ref, updated.toJson());
      });
    } on FirebaseException {
      // Silently absorb.
    }
  }

  /// Add a new habit document.
  Future<void> addHabit(Habit habit) async {
    try {
      await _habitsCollection.add(habit.toJson());
    } on FirebaseException {
      // Silently absorb.
    }
  }

  /// Update an existing habit document.
  Future<void> updateHabit(Habit habit) async {
    try {
      await _habitsCollection.doc(habit.id).update(habit.toJson());
    } on FirebaseException {
      // Silently absorb.
    }
  }

  // ------------------------------------------------------------------
  // Wellness Scores
  // ------------------------------------------------------------------

  /// Real-time stream of all daily metrics (used as score history),
  /// ordered by date descending.
  Stream<List<DailyMetric>> streamScoreHistory() {
    return _dailyMetricsCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map(_snapshotToList<DailyMetric>(DailyMetric.fromJson));
  }

  /// One-shot fetch of the most recent daily metric.
  Future<DailyMetric?> getLatestScore() async {
    try {
      final snap = await _dailyMetricsCollection
          .orderBy('date', descending: true)
          .limit(1)
          .get();
      if (snap.docs.isEmpty) return null;
      final doc = snap.docs.first;
      return DailyMetric.fromJson(<String, dynamic>{...doc.data(), 'id': doc.id});
    } on FirebaseException {
      return null;
    }
  }

  // ------------------------------------------------------------------
  // Helpers
  // ------------------------------------------------------------------

  /// Returns today's date as an ISO-8601 date string (yyyy-MM-dd).
  String _todayDate() {
    final now = DateTime.now();
    return '${now.year}-${_pad(now.month)}-${_pad(now.day)}';
  }

  String _pad(int n) => n.toString().padLeft(2, '0');

  /// Builds a mapper function that converts a [QuerySnapshot] into
  /// a `List<T>` using the supplied [fromJson] factory.
  static List<T> Function(QuerySnapshot<Map<String, dynamic>>)
      _snapshotToList<T>(T Function(Map<String, dynamic>) fromJson) {
    return (snapshot) => snapshot.docs.map((doc) {
          final data = doc.data();
          return fromJson(<String, dynamic>{...data, 'id': doc.id});
        }).toList();
  }
}
