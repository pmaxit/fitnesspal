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
  final int sleepScore;
  final int trainScore;
  final int foodScore;
  final int hydrationScore;
  final int recoveryPct;
  final double energyScore;
  final int calorieTarget;
  final int waterTarget;

  const DailyMetric({
    required this.id,
    required this.date,
    required this.calories,
    required this.sleepHours,
    required this.steps,
    required this.waterCups,
    required this.wellnessScore,
    this.aiInsight,
    this.sleepScore = 0,
    this.trainScore = 0,
    this.foodScore = 0,
    this.hydrationScore = 0,
    this.recoveryPct = 0,
    this.energyScore = 0,
    this.calorieTarget = 2000,
    this.waterTarget = 8,
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
      sleepScore: data['sleepScore'] as int? ?? 0,
      trainScore: data['trainScore'] as int? ?? 0,
      foodScore: data['foodScore'] as int? ?? 0,
      hydrationScore: data['hydrationScore'] as int? ?? 0,
      recoveryPct: data['recoveryPct'] as int? ?? 0,
      energyScore: (data['energyScore'] as num?)?.toDouble() ?? 0,
      calorieTarget: data['calorieTarget'] as int? ?? 2000,
      waterTarget: data['waterTarget'] as int? ?? 8,
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
      sleepScore: data['sleepScore'] as int? ?? 0,
      trainScore: data['trainScore'] as int? ?? 0,
      foodScore: data['foodScore'] as int? ?? 0,
      hydrationScore: data['hydrationScore'] as int? ?? 0,
      recoveryPct: data['recoveryPct'] as int? ?? 0,
      energyScore: (data['energyScore'] as num?)?.toDouble() ?? 0,
      calorieTarget: data['calorieTarget'] as int? ?? 2000,
      waterTarget: data['waterTarget'] as int? ?? 8,
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
      'sleepScore': sleepScore,
      'trainScore': trainScore,
      'foodScore': foodScore,
      'hydrationScore': hydrationScore,
      'recoveryPct': recoveryPct,
      'energyScore': energyScore,
      'calorieTarget': calorieTarget,
      'waterTarget': waterTarget,
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
    int? sleepScore,
    int? trainScore,
    int? foodScore,
    int? hydrationScore,
    int? recoveryPct,
    double? energyScore,
    int? calorieTarget,
    int? waterTarget,
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
      sleepScore: sleepScore ?? this.sleepScore,
      trainScore: trainScore ?? this.trainScore,
      foodScore: foodScore ?? this.foodScore,
      hydrationScore: hydrationScore ?? this.hydrationScore,
      recoveryPct: recoveryPct ?? this.recoveryPct,
      energyScore: energyScore ?? this.energyScore,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      waterTarget: waterTarget ?? this.waterTarget,
    );
  }
}
