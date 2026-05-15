import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String time;
  final String title;
  final String? subtitle;
  final String? icon;
  final DateTime date;

  const Activity({
    required this.id,
    required this.time,
    required this.title,
    this.subtitle,
    this.icon,
    required this.date,
  });

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Activity(
      id: doc.id,
      time: data['time'] as String,
      title: data['title'] as String,
      subtitle: data['subtitle'] as String?,
      icon: data['icon'] as String?,
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  factory Activity.fromJson(Map<String, dynamic> data) {
    return Activity(
      id: data['id'] as String? ?? '',
      time: data['time'] as String,
      title: data['title'] as String,
      subtitle: data['subtitle'] as String?,
      icon: data['icon'] as String?,
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'time': time,
      'title': title,
      'subtitle': subtitle,
      'icon': icon,
      'date': Timestamp.fromDate(date),
    };
  }

  Map<String, dynamic> toJson() => toFirestore();

  Activity copyWith({
    String? id,
    String? time,
    String? title,
    String? subtitle,
    String? icon,
    DateTime? date,
  }) {
    return Activity(
      id: id ?? this.id,
      time: time ?? this.time,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      date: date ?? this.date,
    );
  }
}
