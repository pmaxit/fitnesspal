import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitnesspal/core/theme/colors.dart';
import 'package:fitnesspal/core/services/firestore_service.dart';
import 'package:fitnesspal/core/models/meal.dart';
import 'package:fitnesspal/core/models/daily_metric.dart';
import 'package:fitnesspal/presentation/widgets/progress_ring.dart';

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
    final bgCard = isDark ? const Color(0xFF161920) : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

    // Based on the screenshot
    const proteinTarget = 130;
    const carbsTarget = 240;
    const fatTarget = 70;
    const calorieTarget = 2100;

    final totalProtein = _meals.fold<int>(0, (sum, m) => sum + m.proteinGrams);
    final totalCarbs = _meals.fold<int>(0, (sum, m) => sum + m.carbsGrams);
    final totalFat = _meals.fold<int>(0, (sum, m) => sum + m.fatGrams);
    final totalCalories = _meals.fold<int>(0, (sum, m) => sum + m.calories);

    final proteinUnder = proteinTarget - totalProtein;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TODAY · ${totalCalories.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} / ${calorieTarget.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} KCAL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: fg3,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Meals',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 34,
                            color: fg1,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_meals.length} meals logged · ${proteinUnder > 0 ? '${proteinUnder}g protein under' : 'Protein target met'}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: fg3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: border),
                        ),
                        child: Icon(LucideIcons.filter, color: fg1, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: border),
                        ),
                        child: Icon(LucideIcons.sparkles, color: fg1, size: 20),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // Top Macro Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: border),
              ),
              child: Row(
                children: [
                  ProgressRing(
                    percentage: (totalCalories / calorieTarget * 100).clamp(0.0, 100.0),
                    size: 96,
                    label: '',
                    value: '',
                    unit: '',
                    showLabel: false,
                    strokeWidth: 8,
                    fillColor: const Color(0xFF10B981), // Emerald
                    trackColor: border,
                    centerWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$totalCalories',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: fg1,
                          ),
                        ),
                        Text(
                          'KCAL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: fg3,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: [
                        _buildMacroBar('PROTEIN', totalProtein, proteinTarget, const Color(0xFF10B981), fg1, fg2, fg3, border),
                        const SizedBox(height: 14),
                        _buildMacroBar('CARBS', totalCarbs, carbsTarget, Colors.orange, fg1, fg2, fg3, border),
                        const SizedBox(height: 14),
                        _buildMacroBar('FAT', totalFat, fatTarget, const Color(0xFF8B5CF6), fg1, fg2, fg3, border),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // AI Insight Card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgCard,
                border: Border.all(color: const Color(0xFF0F3E33)), // Subtle green border
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(LucideIcons.sparkles, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOOKING AT YOUR DAY',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF10B981),
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _metric?.aiInsight ?? "You're sitting ${proteinUnder > 0 ? proteinUnder : 0}g protein under and fiber's a little soft. A simple swap at dinner — chicken or tofu over the salad — gets you there.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: fg1,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // JUST ANALYZED Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
              child: Text(
                "JUST ANALYZED",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: fg3,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            if (_meals.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: bgCard,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top image area
                    Container(
                      height: 180,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF84CC16), Color(0xFFEAB308), Color(0xFFB45309)],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 16,
                            right: 16,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                shape: BoxShape.circle,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'A-',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'SCORE',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white70,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: Row(
                              children: [
                                _buildTag('LUNCH'),
                                const SizedBox(width: 8),
                                _buildTag('HIGH FIBER'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Meal Details
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _meals.first.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: fg1,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${_meals.first.description} · ${TimeOfDay.fromDateTime(_meals.first.createdAt).format(context)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: fg3,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildMiniMacroCard('${_meals.first.calories}', 'k', 'KCAL', 0.8, const Color(0xFF10B981), isDark, bgCard, border, fg1, fg3),
                              _buildMiniMacroCard('${_meals.first.proteinGrams}', 'g', 'PROTEIN', 0.6, const Color(0xFF10B981), isDark, bgCard, border, fg1, fg3),
                              _buildMiniMacroCard('${_meals.first.carbsGrams}', 'g', 'CARBS', 0.4, Colors.orange, isDark, bgCard, border, fg1, fg3),
                              _buildMiniMacroCard('${_meals.first.fatGrams}', 'g', 'FAT', 0.3, const Color(0xFF8B5CF6), isDark, bgCard, border, fg1, fg3),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_meals.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(LucideIcons.utensils, size: 48, color: fg3.withOpacity(0.4)),
                      const SizedBox(height: 12),
                      Text(
                        'No meals logged today',
                        style: TextStyle(fontSize: 14, color: fg2, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 100), // Extra space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildMacroBar(String label, int current, int target, Color color, Color fg1, Color fg2, Color fg3, Color border) {
    final percent = (current / target).clamp(0.0, 1.0);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: fg2,
                letterSpacing: 1.0,
              ),
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: fg1),
                children: [
                  TextSpan(text: '$current'),
                  TextSpan(
                    text: '/${target}g',
                    style: TextStyle(color: fg3, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          width: double.infinity,
          decoration: BoxDecoration(
            color: border,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percent,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMiniMacroCard(String value, String unit, String label, double percent, Color color, bool isDark, Color bgCard, Color border, Color fg1, Color fg3) {
    return Container(
      width: 72,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1D24) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: fg1,
                  height: 1.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: fg3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: fg3,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: border,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percent,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}