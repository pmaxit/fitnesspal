import 'package:fitnesspal/core/models/habit_category.dart';

class HabitCategoryConstants {
  static const List<String> availableIcons = [
    'dumbbell',
    'leaf',
    'bed',
    'brain',
    'users',
    'palette',
    'heart',
    'zap',
    'target',
    'flame',
    'droplet',
    'pill',
    'sun',
    'moon',
    'coffee',
    'music',
  ];

  static const List<String> availableColors = [
    '#10B981',
    '#3B82F6',
    '#8B5CF6',
    '#F59E0B',
    '#EF4444',
    '#EC4899',
    '#06B6D4',
    '#84CC16',
    '#F97316',
    '#6366F1',
    '#14B8A6',
    '#A855F7',
  ];

  static List<HabitCategory> defaultCategories(String userId) {
    final now = DateTime.now();
    return [
      HabitCategory(
        id: '${userId}_fitness',
        name: 'Fitness',
        iconName: 'dumbbell',
        colorHex: '#10B981',
        createdAt: now,
        sortOrder: 0,
      ),
      HabitCategory(
        id: '${userId}_nutrition',
        name: 'Nutrition',
        iconName: 'leaf',
        colorHex: '#84CC16',
        createdAt: now,
        sortOrder: 1,
      ),
      HabitCategory(
        id: '${userId}_sleep',
        name: 'Sleep',
        iconName: 'bed',
        colorHex: '#6366F1',
        createdAt: now,
        sortOrder: 2,
      ),
      HabitCategory(
        id: '${userId}_mindfulness',
        name: 'Mindfulness',
        iconName: 'brain',
        colorHex: '#8B5CF6',
        createdAt: now,
        sortOrder: 3,
      ),
      HabitCategory(
        id: '${userId}_learning',
        name: 'Learning',
        iconName: 'book',
        colorHex: '#F59E0B',
        createdAt: now,
        sortOrder: 4,
      ),
      HabitCategory(
        id: '${userId}_social',
        name: 'Social',
        iconName: 'users',
        colorHex: '#EC4899',
        createdAt: now,
        sortOrder: 5,
      ),
      HabitCategory(
        id: '${userId}_creative',
        name: 'Creative',
        iconName: 'palette',
        colorHex: '#F97316',
        createdAt: now,
        sortOrder: 6,
      ),
      HabitCategory(
        id: '${userId}_health',
        name: 'Health',
        iconName: 'heart',
        colorHex: '#EF4444',
        createdAt: now,
        sortOrder: 7,
      ),
    ];
  }
}