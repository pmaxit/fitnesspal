import 'package:cloud_firestore/cloud_firestore.dart';

class DailyMetric {
  final String id;
  final DateTime date;
  final int calories;
  final double sleepHours;
  final int steps;
  final int waterCups;
  final double wellnessScore;
  final String? aiInsight;

  const DailyMetric({
    required this.id,
    required this.date,
    required this.calories,
    required this.sleepHours,
    required this.steps,
    required this.waterCups,
    required this.wellnessScore,
    this.aiInsight,
  });

  factory DailyMetric.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailyMetric(
      id: doc.id,
      date: (data['date'] as Timestamp).toDate(),
      calories: data['calories'] as int,
      sleepHours: (data['sleepHours'] as num).toDouble(),
      steps: data['steps'] as int,
      waterCups: data['waterCups'] as int,
      wellnessScore: (data['wellnessScore'] as num).toDouble(),
      aiInsight: data['aiInsight'] as String?,
    );
  }

  factory DailyMetric.fromJson(Map<String, dynamic> data) {
    return DailyMetric(
      id: data['id'] as String? ?? '',
      date: (data['date'] as Timestamp).toDate(),
      calories: data['calories'] as int,
      sleepHours: (data['sleepHours'] as num).toDouble(),
      steps: data['steps'] as int,
      waterCups: data['waterCups'] as int,
      wellnessScore: (data['wellnessScore'] as num).toDouble(),
      aiInsight: data['aiInsight'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'calories': calories,
      'sleepHours': sleepHours,
      'steps': steps,
      'waterCups': waterCups,
      'wellnessScore': wellnessScore,
      'aiInsight': aiInsight,
    };
  }

  Map<String, dynamic> toJson() => toFirestore();

  DailyMetric copyWith({
    String? id,
    DateTime? date,
    int? calories,
    double? sleepHours,
    int? steps,
    int? waterCups,
    double? wellnessScore,
    String? aiInsight,
  }) {
    return DailyMetric(
      id: id ?? this.id,
      date: date ?? this.date,
      calories: calories ?? this.calories,
      sleepHours: sleepHours ?? this.sleepHours,
      steps: steps ?? this.steps,
      waterCups: waterCups ?? this.waterCups,
      wellnessScore: wellnessScore ?? this.wellnessScore,
      aiInsight: aiInsight ?? this.aiInsight,
    );
  }
}
