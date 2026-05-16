import 'package:cloud_firestore/cloud_firestore.dart';

class HabitCategory {
  final String id;
  final String name;
  final String iconName;
  final String colorHex;
  final DateTime createdAt;
  final int sortOrder;

  const HabitCategory({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorHex,
    required this.createdAt,
    required this.sortOrder,
  });

  factory HabitCategory.fromJson(String id, Map<String, dynamic> data) {
    return HabitCategory(
      id: id,
      name: data['name'] as String? ?? '',
      iconName: data['iconName'] as String? ?? 'heart',
      colorHex: data['colorHex'] as String? ?? '#10B981',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      sortOrder: data['sortOrder'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'iconName': iconName,
      'colorHex': colorHex,
      'createdAt': Timestamp.fromDate(createdAt),
      'sortOrder': sortOrder,
    };
  }

  HabitCategory copyWith({
    String? id,
    String? name,
    String? iconName,
    String? colorHex,
    DateTime? createdAt,
    int? sortOrder,
  }) {
    return HabitCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}