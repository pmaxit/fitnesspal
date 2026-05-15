import 'package:flutter/material.dart';
import 'package:fitnesspal/core/theme/colors.dart';
import 'package:fitnesspal/core/services/firestore_service.dart';
import 'package:fitnesspal/core/models/habit.dart';

class HabitsScreen extends StatefulWidget {
  final bool isDarkMode;

  const HabitsScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  List<Habit> _habits = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    FirestoreService().streamHabits().listen((habits) {
      if (mounted) {
        setState(() {
          _habits = habits;
          _isLoading = false;
        });
      }
    });
  }

  Color _parseColor(String colorStr) {
    switch (colorStr.toLowerCase()) {
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'cyan':
        return Colors.cyan;
      case 'purple':
        return Colors.purple;
      case 'indigo':
        return Colors.indigo;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      case 'teal':
        return Colors.teal;
      case 'pink':
        return Colors.pink;
      case 'amber':
        return Colors.amber;
      default:
        try {
          final hex = colorStr.replaceFirst('#', '');
          return Color(int.parse('FF$hex', radix: 16));
        } catch (_) {
          return Colors.green;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

    if (_isLoading) {
      return SafeArea(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_habits.isEmpty) {
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
                    Text('HABITS',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: fg3,
                            letterSpacing: 0.1)),
                    const SizedBox(height: 4),
                    Text('Habits', style: Theme.of(context).textTheme.displayMedium),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Text('No habits yet',
                      style: TextStyle(fontSize: 14, color: fg2)),
                ),
              ),
            ],
          ),
        ),
      );
    }

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
                  Text('HABITS',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: fg3,
                          letterSpacing: 0.1)),
                  const SizedBox(height: 4),
                  Text('Habits', style: Theme.of(context).textTheme.displayMedium),
                ],
              ),
            ),

            // Streak hero
            Container(
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
                  Text('Current Streak',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg3)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_habits.first.streak,
                              style: Theme.of(context).textTheme.displayMedium),
                          const SizedBox(height: 4),
                          Text('You\'re on fire! 🔥',
                              style: TextStyle(fontSize: 12, color: fg2)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.15),
                          border: Border.all(
                              color: AppColors.warning.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '🔥 23',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.warning),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Calendar heatmap
            _calendarHeatmap(context, isDark),

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
                      'Your fitness habits are strongest on weekdays. Weekend dips are normal!',
                      style: TextStyle(fontSize: 11.5, color: fg1, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            // Habits list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'YOUR HABITS',
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: fg3,
                    letterSpacing: 0.1),
              ),
            ),

            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: bgCard,
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: _habits.map((h) {
                  final color = _parseColor(h.iconColor);
                  return GestureDetector(
                    onTap: () => FirestoreService().toggleHabit(h.id),
                    child: _habitRow(
                        context, h.name, h.streak, h.isCompleted, color, isDark),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _calendarHeatmap(BuildContext context, bool isDark) {
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;
    final heatMap = isDark ? AppColors.darkHeatMap : AppColors.lightHeatMap;

    final days = List.generate(42, (i) {
      if (i < 5) return 0;
      final day = i - 5 + 1;
      if (day > 30) return 0;
      return (day * 7 + i) % 5;
    });

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgCard,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('May 2026',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg3)),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final heat = days[index];
              return Container(
                decoration: BoxDecoration(
                  color: heat == 0 ? Colors.transparent : heatMap[heat],
                  borderRadius: BorderRadius.circular(4),
                  border: index == 27
                      ? Border.all(color: AppColors.accent, width: 2)
                      : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _habitRow(BuildContext context, String habit, String streak,
      bool done, Color color, bool isDark) {
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: done ? AppColors.accent : color.withOpacity(0.5),
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                  color: done ? AppColors.accent : Colors.transparent,
                ),
                child: done
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(habit,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Streak: $streak',
                          style: TextStyle(fontSize: 11, color: fg3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 0, thickness: 1, indent: 56, color: border),
      ],
    );
  }
}
