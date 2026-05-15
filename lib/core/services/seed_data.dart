import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnesspal/core/models/activity.dart';
import 'package:fitnesspal/core/models/daily_metric.dart';
import 'package:fitnesspal/core/models/habit.dart';
import 'package:fitnesspal/core/models/meal.dart';
import 'package:fitnesspal/core/models/user_profile.dart';
import 'package:fitnesspal/core/services/firestore_service.dart';

/// Seeds the Firestore database with sample data for the demo user.
///
/// Call this once on app startup. It checks if data already exists
/// and only seeds if the collections are empty.
Future<void> seedDatabase() async {
  final service = FirestoreService();
  final userId = service.userId;

  // Check if user profile already exists
  final profileDoc = await service.getUserProfile();
  if (profileDoc != null) return; // Already seeded

  // ── User Profile ──
  final profile = UserProfile(
    id: userId,
    name: 'Maya',
    initials: 'MY',
    bio: 'Wellness focused • 28 yo',
    goals: ['Lose Weight', 'Build Muscle', 'Sleep Better'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  await service.saveUserProfile(profile);

  // ── Today's Daily Metric ──
  final today = DateTime.now();
  final todayMetric = DailyMetric(
    id: '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}',
    date: today,
    calories: 1840,
    sleepHours: 7.5,
    steps: 8432,
    waterCups: 6,
    wellnessScore: 8.4,
    aiInsight: 'Your recovery is improving after better sleep consistency.',
  );
  await service.saveDailyMetric(todayMetric);

  // ── Meals ──
  final meals = [
    Meal(
      id: '',
      name: 'Breakfast',
      calories: 450,
      description: 'Oatmeal with berries',
      proteinGrams: 15,
      carbsGrams: 65,
      fatGrams: 12,
      createdAt: DateTime.now(),
    ),
    Meal(
      id: '',
      name: 'Lunch',
      calories: 620,
      description: 'Grilled chicken salad',
      proteinGrams: 42,
      carbsGrams: 35,
      fatGrams: 28,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    Meal(
      id: '',
      name: 'Snack',
      calories: 180,
      description: 'Almonds & apple',
      proteinGrams: 6,
      carbsGrams: 22,
      fatGrams: 8,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];
  for (final meal in meals) {
    await service.addMeal(meal);
  }

  // ── Activities ──
  final activities = [
    Activity(
      id: '',
      time: '06:30',
      title: 'Sleep ended',
      subtitle: 'Quiet rest · 7h 22m',
      icon: '🌙',
      date: today,
    ),
    Activity(
      id: '',
      time: '07:15',
      title: 'Morning walk',
      subtitle: '2.3 mi · 35 min',
      icon: '🚶',
      date: today,
    ),
    Activity(
      id: '',
      time: '12:30',
      title: 'Lunch break',
      subtitle: 'Walk · 15 min',
      icon: '🍽️',
      date: today,
    ),
    Activity(
      id: '',
      time: '18:00',
      title: 'Evening run',
      subtitle: '5K · 28 min',
      icon: '🏃',
      date: today,
    ),
  ];
  for (final activity in activities) {
    await service.addActivity(activity);
  }

  // ── Habits ──
  final habits = [
    Habit(
      id: '',
      name: 'Morning Run',
      streak: '12 days',
      isCompleted: true,
      iconColor: '#4CAF50',
      createdAt: DateTime.now(),
      completedDates: [today, today.subtract(const Duration(days: 1)), today.subtract(const Duration(days: 2))],
    ),
    Habit(
      id: '',
      name: 'Read 30 min',
      streak: '5 days',
      isCompleted: false,
      iconColor: '#2196F3',
      createdAt: DateTime.now(),
      completedDates: [today, today.subtract(const Duration(days: 1))],
    ),
  ];
  for (final habit in habits) {
    await service.addHabit(habit);
  }
}
