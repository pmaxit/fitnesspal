import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String id;
  final String name;
  final String streak;
  final bool isCompleted;
  final String iconColor;
  final DateTime createdAt;
  final List<DateTime> completedDates;

  const Habit({
    required this.id,
    required this.name,
    required this.streak,
    required this.isCompleted,
    required this.iconColor,
    required this.createdAt,
    required this.completedDates,
  });

  factory Habit.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final timestamps = data['completedDates'] as List<dynamic>?;
    return Habit(
      id: doc.id,
      name: data['name'] as String,
      streak: data['streak'] as String,
      isCompleted: data['isCompleted'] as bool,
      iconColor: data['iconColor'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      completedDates: timestamps != null
          ? timestamps
              .map((e) => (e as Timestamp).toDate())
              .toList()
          : const [],
    );
  }

  factory Habit.fromJson(Map<String, dynamic> data) {
    final timestamps = data['completedDates'] as List<dynamic>?;
    return Habit(
      id: data['id'] as String? ?? '',
      name: data['name'] as String,
      streak: data['streak'] as String,
      isCompleted: data['isCompleted'] as bool,
      iconColor: data['iconColor'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      completedDates: timestamps != null
          ? timestamps
              .map((e) => (e as Timestamp).toDate())
              .toList()
          : const [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'streak': streak,
      'isCompleted': isCompleted,
      'iconColor': iconColor,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedDates':
          completedDates.map((e) => Timestamp.fromDate(e)).toList(),
    };
  }

  Map<String, dynamic> toJson() => toFirestore();

  Habit copyWith({
    String? id,
    String? name,
    String? streak,
    bool? isCompleted,
    String? iconColor,
    DateTime? createdAt,
    List<DateTime>? completedDates,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      streak: streak ?? this.streak,
      isCompleted: isCompleted ?? this.isCompleted,
      iconColor: iconColor ?? this.iconColor,
      createdAt: createdAt ?? this.createdAt,
      completedDates: completedDates ?? this.completedDates,
    );
  }
}
