import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String name;
  final String initials;
  final String bio;
  final List<String> goals;
  final double weightLb;
  final double bodyFatPct;
  final double muscleLb;
  
  // New fields from profile
  final int age;
  final int heightInches;
  final String activityLevel;
  final double goalWeightLb;
  final int calorieTarget;
  final int sleepGoalHr;
  final String fitnessExperience;
  final bool isVegetarian;
  
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.initials,
    required this.bio,
    required this.goals,
    this.weightLb = 0,
    this.bodyFatPct = 0,
    this.muscleLb = 0,
    this.age = 28,
    this.heightInches = 67, // 5'7"
    this.activityLevel = 'Moderate',
    this.goalWeightLb = 168.0,
    this.calorieTarget = 2100,
    this.sleepGoalHr = 8,
    this.fitnessExperience = 'Intermediate',
    this.isVegetarian = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      id: doc.id,
      name: data['name'] as String,
      initials: data['initials'] as String,
      bio: data['bio'] as String,
      goals: List<String>.from(data['goals'] ?? []),
      weightLb: (data['weightLb'] as num?)?.toDouble() ?? 0,
      bodyFatPct: (data['bodyFatPct'] as num?)?.toDouble() ?? 0,
      muscleLb: (data['muscleLb'] as num?)?.toDouble() ?? 0,
      age: data['age'] as int? ?? 28,
      heightInches: data['heightInches'] as int? ?? 67,
      activityLevel: data['activityLevel'] as String? ?? 'Moderate',
      goalWeightLb: (data['goalWeightLb'] as num?)?.toDouble() ?? 168.0,
      calorieTarget: data['calorieTarget'] as int? ?? 2100,
      sleepGoalHr: data['sleepGoalHr'] as int? ?? 8,
      fitnessExperience: data['fitnessExperience'] as String? ?? 'Intermediate',
      isVegetarian: data['isVegetarian'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> data) {
    return UserProfile(
      id: data['id'] as String? ?? '',
      name: data['name'] as String,
      initials: data['initials'] as String,
      bio: data['bio'] as String,
      goals: List<String>.from(data['goals'] ?? []),
      weightLb: (data['weightLb'] as num?)?.toDouble() ?? 0,
      bodyFatPct: (data['bodyFatPct'] as num?)?.toDouble() ?? 0,
      muscleLb: (data['muscleLb'] as num?)?.toDouble() ?? 0,
      age: data['age'] as int? ?? 28,
      heightInches: data['heightInches'] as int? ?? 67,
      activityLevel: data['activityLevel'] as String? ?? 'Moderate',
      goalWeightLb: (data['goalWeightLb'] as num?)?.toDouble() ?? 168.0,
      calorieTarget: data['calorieTarget'] as int? ?? 2100,
      sleepGoalHr: data['sleepGoalHr'] as int? ?? 8,
      fitnessExperience: data['fitnessExperience'] as String? ?? 'Intermediate',
      isVegetarian: data['isVegetarian'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'initials': initials,
      'bio': bio,
      'goals': goals,
      'weightLb': weightLb,
      'bodyFatPct': bodyFatPct,
      'muscleLb': muscleLb,
      'age': age,
      'heightInches': heightInches,
      'activityLevel': activityLevel,
      'goalWeightLb': goalWeightLb,
      'calorieTarget': calorieTarget,
      'sleepGoalHr': sleepGoalHr,
      'fitnessExperience': fitnessExperience,
      'isVegetarian': isVegetarian,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Map<String, dynamic> toJson() => toFirestore();

  UserProfile copyWith({
    String? id,
    String? name,
    String? initials,
    String? bio,
    List<String>? goals,
    double? weightLb,
    double? bodyFatPct,
    double? muscleLb,
    int? age,
    int? heightInches,
    String? activityLevel,
    double? goalWeightLb,
    int? calorieTarget,
    int? sleepGoalHr,
    String? fitnessExperience,
    bool? isVegetarian,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      initials: initials ?? this.initials,
      bio: bio ?? this.bio,
      goals: goals ?? this.goals,
      weightLb: weightLb ?? this.weightLb,
      bodyFatPct: bodyFatPct ?? this.bodyFatPct,
      muscleLb: muscleLb ?? this.muscleLb,
      age: age ?? this.age,
      heightInches: heightInches ?? this.heightInches,
      activityLevel: activityLevel ?? this.activityLevel,
      goalWeightLb: goalWeightLb ?? this.goalWeightLb,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      sleepGoalHr: sleepGoalHr ?? this.sleepGoalHr,
      fitnessExperience: fitnessExperience ?? this.fitnessExperience,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
