import 'package:cloud_firestore/cloud_firestore.dart';

class Meal {
  final String id;
  final String name;
  final int calories;
  final String description;
  final int proteinGrams;
  final int carbsGrams;
  final int fatGrams;
  final DateTime createdAt;

  const Meal({
    required this.id,
    required this.name,
    required this.calories,
    required this.description,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.createdAt,
  });

  factory Meal.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Meal(
      id: doc.id,
      name: data['name'] as String,
      calories: data['calories'] as int,
      description: data['description'] as String,
      proteinGrams: data['proteinGrams'] as int,
      carbsGrams: data['carbsGrams'] as int,
      fatGrams: data['fatGrams'] as int,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  factory Meal.fromJson(Map<String, dynamic> data) {
    return Meal(
      id: data['id'] as String? ?? '',
      name: data['name'] as String,
      calories: data['calories'] as int,
      description: data['description'] as String,
      proteinGrams: data['proteinGrams'] as int,
      carbsGrams: data['carbsGrams'] as int,
      fatGrams: data['fatGrams'] as int,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'calories': calories,
      'description': description,
      'proteinGrams': proteinGrams,
      'carbsGrams': carbsGrams,
      'fatGrams': fatGrams,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Map<String, dynamic> toJson() => toFirestore();

  Meal copyWith({
    String? id,
    String? name,
    int? calories,
    String? description,
    int? proteinGrams,
    int? carbsGrams,
    int? fatGrams,
    DateTime? createdAt,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      description: description ?? this.description,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
