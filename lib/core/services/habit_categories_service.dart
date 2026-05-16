import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnesspal/core/models/habit_category.dart';
import 'package:fitnesspal/core/models/habit.dart';
import 'package:fitnesspal/core/utils/habit_category_constants.dart';

class HabitCategoriesService {
  static HabitCategoriesService? _instance;

  final FirebaseFirestore _db;
  final String _userId;

  HabitCategoriesService._({
    FirebaseFirestore? firestore,
    required String userId,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _userId = userId;

  factory HabitCategoriesService({String? userId}) {
    _instance ??= HabitCategoriesService._(userId: userId ?? 'demo-user-1');
    return _instance!;
  }

  static void resetInstance() {
    _instance = null;
  }

  CollectionReference<Map<String, dynamic>> get _categoriesCollection =>
      _db.collection('users/$_userId/habitCategories');

  CollectionReference<Map<String, dynamic>> get _habitsCollection =>
      _db.collection('users/$_userId/habits');

  Stream<List<HabitCategory>> streamCategories() {
    return _categoriesCollection
        .orderBy('sortOrder')
        .snapshots()
        .map(_snapshotToList);
  }

  Future<List<HabitCategory>> getCategories() async {
    try {
      final snap = await _categoriesCollection.orderBy('sortOrder').get();
      return snap.docs.map((doc) {
        return HabitCategory.fromJson(doc.id, doc.data());
      }).toList();
    } on FirebaseException {
      return [];
    }
  }

  Future<void> addCategory(HabitCategory category) async {
    try {
      await _categoriesCollection.doc(category.id).set(category.toJson());
    } on FirebaseException {}
  }

  Future<void> updateCategory(HabitCategory category) async {
    try {
      await _categoriesCollection.doc(category.id).update(category.toJson());
    } on FirebaseException {}
  }

  Future<List<Habit>> getHabitsByCategoryColor(String colorHex) async {
    try {
      final snap = await _habitsCollection
          .where('categoryColor', isEqualTo: colorHex)
          .get();
      return snap.docs.map((doc) {
        return Habit.fromJson({...doc.data(), 'id': doc.id});
      }).toList();
    } on FirebaseException {
      return [];
    }
  }

  Future<void> deleteCategoryAndHabits(String categoryId) async {
    try {
      final catSnap = await _categoriesCollection.doc(categoryId).get();
      if (!catSnap.exists || catSnap.data() == null) return;

      final colorHex = catSnap.data()!['colorHex'] as String;
      final habitsSnap = await _habitsCollection
          .where('categoryColor', isEqualTo: colorHex)
          .get();

      await _db.runTransaction((transaction) async {
        transaction.delete(_categoriesCollection.doc(categoryId));
        for (final habitDoc in habitsSnap.docs) {
          transaction.delete(habitDoc.reference);
        }
      });
    } on FirebaseException {}
  }

  Future<void> reorderCategories(List<String> orderedIds) async {
    try {
      await _db.runTransaction((transaction) async {
        for (int i = 0; i < orderedIds.length; i++) {
          transaction.update(
            _categoriesCollection.doc(orderedIds[i]),
            {'sortOrder': i},
          );
        }
      });
    } on FirebaseException {}
  }

  Future<void> initDefaultsIfNeeded() async {
    try {
      final snap = await _categoriesCollection.get();
      if (snap.docs.isEmpty) {
        final defaults = HabitCategoryConstants.defaultCategories(_userId);
        await _db.runTransaction((transaction) async {
          for (final cat in defaults) {
            transaction.set(_categoriesCollection.doc(cat.id), cat.toJson());
          }
        });
      }
    } on FirebaseException {}
  }

  List<HabitCategory> _snapshotToList(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map((doc) {
      return HabitCategory.fromJson(doc.id, doc.data());
    }).toList();
  }
}