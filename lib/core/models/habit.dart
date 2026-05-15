import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String id;
  final String name;
  final String description;
  final String goal;
  final String streak;
  final int streakValue;
  final int recordStreak;
  final bool isCompleted;
  final String iconColor;
  final String categoryColor;
  final DateTime createdAt;
  final List<DateTime> completedDates;

  const Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.goal,
    required this.streak,
    required this.streakValue,
    required this.recordStreak,
    required this.isCompleted,
    required this.iconColor,
    required this.categoryColor,
    required this.createdAt,
    required this.completedDates,
  });

  factory Habit.fromJson(Map<String, dynamic> data) {
    final timestamps = data['completedDates'] as List<dynamic>?;
    return Habit(
      id: data['id'] as String? ?? '',
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      goal: data['goal'] as String? ?? '',
      streak: data['streak'] as String? ?? '0 days',
      streakValue: data['streakValue'] as int? ?? 0,
      recordStreak: data['recordStreak'] as int? ?? 0,
      isCompleted: data['isCompleted'] as bool? ?? false,
      iconColor: data['iconColor'] as String? ?? '#10B981',
      categoryColor: data['categoryColor'] as String? ?? '#10B981',
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
      completedDates: timestamps != null
          ? timestamps
              .map((e) => (e as Timestamp).toDate())
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'goal': goal,
      'streak': streak,
      'streakValue': streakValue,
      'recordStreak': recordStreak,
      'isCompleted': isCompleted,
      'iconColor': iconColor,
      'categoryColor': categoryColor,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedDates':
          completedDates.map((e) => Timestamp.fromDate(e)).toList(),
    };
  }

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    String? goal,
    String? streak,
    int? streakValue,
    int? recordStreak,
    bool? isCompleted,
    String? iconColor,
    String? categoryColor,
    DateTime? createdAt,
    List<DateTime>? completedDates,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      goal: goal ?? this.goal,
      streak: streak ?? this.streak,
      streakValue: streakValue ?? this.streakValue,
      recordStreak: recordStreak ?? this.recordStreak,
      isCompleted: isCompleted ?? this.isCompleted,
      iconColor: iconColor ?? this.iconColor,
      categoryColor: categoryColor ?? this.categoryColor,
      createdAt: createdAt ?? this.createdAt,
      completedDates: completedDates ?? this.completedDates,
    );
  }
}
