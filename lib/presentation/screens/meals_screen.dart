import 'package:flutter/material.dart';
import 'package:fitnesspal/core/theme/colors.dart';

class MealsScreen extends StatelessWidget {
  final bool isDarkMode;

  const MealsScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode;
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NUTRITION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg3, letterSpacing: 0.1)),
                  const SizedBox(height: 4),
                  Text('Meals', style: Theme.of(context).textTheme.displayMedium),
                ],
              ),
            ),

            // Macro ring
            _macroRing(context, isDark),

            // AI insight
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text('✨', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Great protein intake! Your macro balance supports muscle recovery.',
                      style: TextStyle(fontSize: 11.5, color: fg1, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            // Just analyzed meal
            _mealHeroCard(context, isDark),

            // Today's meals
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'TODAY\'S MEALS',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg3, letterSpacing: 0.1),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: bgCard,
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _mealRow('Breakfast', '450 cal', 'Oatmeal with berries', isDark),
                  _mealRow('Lunch', '620 cal', 'Grilled chicken salad', isDark),
                  _mealRow('Snack', '180 cal', 'Almonds & apple', isDark),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _macroRing(BuildContext context, bool isDark) {
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
          Text('Macros today', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg3)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _macroItem('Protein', '125g', 50, Colors.green),
              _macroItem('Carbs', '245g', 68, Colors.orange),
              _macroItem('Fat', '65g', 72, Colors.blue),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _macroBar('Carbs', 0.68, Colors.orange),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _macroBar('Protein', 0.50, Colors.green),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _macroBar('Fat', 0.72, Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _macroItem(String label, String value, double percent, Color color) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.1)),
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
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _mealHeroCard(BuildContext context, bool isDark) {
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
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '9.1',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        const Text(
                          'SCORE',
                          style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 14,
                  left: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: const Text(
                      'HEALTHY',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
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
                Text('Grilled Salmon Bowl', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('Just analyzed', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _macroStat('Cal', '520'),
                    _macroStat('Protein', '38g'),
                    _macroStat('Carbs', '42g'),
                    _macroStat('Fat', '18g'),
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
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.1)),
      ],
    );
  }

  Widget _mealRow(String meal, String cal, String description, bool isDark) {
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.orange, Colors.amber]),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meal, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(description, style: TextStyle(fontSize: 11, color: fg3)),
                  ],
                ),
              ),
              Text(cal, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        if (meal != 'Snack')
          Divider(height: 0, thickness: 1, indent: 56, color: border),
      ],
    );
  }
}
