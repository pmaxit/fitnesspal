import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fitnesspal/core/theme/colors.dart';
import 'package:fitnesspal/core/services/firestore_service.dart';
import 'package:fitnesspal/core/models/meal.dart';
import 'package:fitnesspal/core/models/daily_metric.dart';

class MealsScreen extends StatefulWidget {
  final bool isDarkMode;

  const MealsScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Meal> _meals = [];
  DailyMetric? _metric;
  bool _isLoading = true;
  StreamSubscription<List<Meal>>? _mealsSubscription;
  StreamSubscription<DailyMetric?>? _metricSubscription;

  @override
  void initState() {
    super.initState();
    _mealsSubscription = _firestoreService.streamMeals().listen((meals) {
      if (mounted) {
        setState(() {
          _meals = meals;
          _isLoading = false;
        });
      }
    });
    _metricSubscription =
        _firestoreService.streamTodayMetric().listen((metric) {
      if (mounted) {
        setState(() {
          _metric = metric;
        });
      }
    });
  }

  @override
  void dispose() {
    _mealsSubscription?.cancel();
    _metricSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

    // Macro totals from actual meals
    const proteinTarget = 150;
    const carbsTarget = 300;
    const fatTarget = 80;

    final totalProtein = _meals.fold<int>(0, (sum, m) => sum + m.proteinGrams);
    final totalCarbs = _meals.fold<int>(0, (sum, m) => sum + m.carbsGrams);
    final totalFat = _meals.fold<int>(0, (sum, m) => sum + m.fatGrams);

    final proteinPercent = (totalProtein / proteinTarget).clamp(0.0, 1.0);
    final carbsPercent = (totalCarbs / carbsTarget).clamp(0.0, 1.0);
    final fatPercent = (totalFat / fatTarget).clamp(0.0, 1.0);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NUTRITION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: fg3,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Meals',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
            ),

            // Macro ring
            _macroRing(
              context,
              isDark,
              totalProtein,
              totalCarbs,
              totalFat,
              proteinPercent,
              carbsPercent,
              fatPercent,
            ),

            // AI insight — only when data exists
            if (_metric?.aiInsight != null)
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  border: Border.all(
                    color: AppColors.accent.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      '✨',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _metric!.aiInsight!,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: fg1,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Just analyzed meal — only when meals exist
            if (_meals.isNotEmpty)
              _mealHeroCard(context, isDark, _meals.first),

            // Today's meals
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'TODAY\'S MEALS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: fg3,
                  letterSpacing: 0.1,
                ),
              ),
            ),

            if (_isLoading)
              _buildLoadingSkeleton(bgCard, border)
            else if (_meals.isEmpty)
              _buildEmptyState(bgCard, border, fg2)
            else
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: bgCard,
                  border: Border.all(color: border),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: List.generate(_meals.length, (i) {
                    final meal = _meals[i];
                    return _mealRow(
                      meal.name,
                      '${meal.calories} cal',
                      meal.description,
                      isDark,
                      showDivider: i < _meals.length - 1,
                    );
                  }),
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton(Color bgCard, Color border) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgCard,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 140,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color bgCard, Color border, Color fg2) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: bgCard,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'No meals logged today',
          style: TextStyle(fontSize: 13, color: fg2),
        ),
      ),
    );
  }

  Widget _macroRing(
    BuildContext context,
    bool isDark,
    int totalProtein,
    int totalCarbs,
    int totalFat,
    double proteinPercent,
    double carbsPercent,
    double fatPercent,
  ) {
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgCard,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Macros today',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: fg3),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _macroItem('Protein', '${totalProtein}g', proteinPercent, Colors.green),
              _macroItem('Carbs', '${totalCarbs}g', carbsPercent, Colors.orange),
              _macroItem('Fat', '${totalFat}g', fatPercent, Colors.blue),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _macroBar('Carbs', carbsPercent, Colors.orange),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _macroBar('Protein', proteinPercent, Colors.green),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _macroBar('Fat', fatPercent, Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _macroItem(
      String label, String value, double percent, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1),
        ),
      ],
    );
  }

  Widget _macroBar(String label, double percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 3,
            backgroundColor: Colors.grey.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
              fontSize: 9, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _mealHeroCard(BuildContext context, bool isDark, Meal meal) {
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.orange.withOpacity(0.3),
                  Colors.amber.withOpacity(0.5),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withOpacity(0.15)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${meal.calories}',
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                        const Text(
                          'CAL',
                          style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.15)),
                    ),
                    child: const Text(
                      'MEAL',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Just analyzed',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _macroStat('Cal', '${meal.calories}'),
                    _macroStat('Protein', '${meal.proteinGrams}g'),
                    _macroStat('Carbs', '${meal.carbsGrams}g'),
                    _macroStat('Fat', '${meal.fatGrams}g'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _macroStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1),
        ),
      ],
    );
  }

  Widget _mealRow(
    String meal,
    String cal,
    String description,
    bool isDark, {
    bool showDivider = true,
  }) {
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Colors.orange, Colors.amber]),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(fontSize: 11, color: fg3),
                    ),
                  ],
                ),
              ),
              Text(
                cal,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
              height: 0,
              thickness: 1,
              indent: 56,
              color: border),
      ],
    );
  }
}
