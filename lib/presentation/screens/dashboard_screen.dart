import 'package:flutter/material.dart';
import 'package:fitnesspal/core/theme/colors.dart';
import 'package:fitnesspal/presentation/widgets/avatar.dart';
import 'package:fitnesspal/presentation/widgets/progress_ring.dart';

class DashboardScreen extends StatelessWidget {
  final bool isDarkMode;

  const DashboardScreen({Key? key, required this.isDarkMode}) : super(key: key);

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
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TODAY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: fg3,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dashboard',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You\'re steady this week. Keep the momentum.',
                    style: TextStyle(fontSize: 13, color: fg2, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            // Avatar
            AvatarWidget(isDarkMode: isDark),

            // Ring tiles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _ringTile(context, 'Calories', '2,340', 'kcal', 78, isDark),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ringTile(context, 'Water', '6', 'cups', 60, isDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _ringTile(context, 'Habits', '5', 'done', 83, isDark),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ringTile(context, 'Energy', '8.2', '/10', 82, isDark),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // AI Insight
            _aiCard(context, isDark),

            // Quick log row
            _quickLogRow(context, isDark),

            // BMI scale
            _bmiCard(context, isDark),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _ringTile(
    BuildContext context,
    String label,
    String value,
    String unit,
    double percentage,
    bool isDark,
  ) {
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgCard,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: RingPainter(
                    trackColor: border,
                    fillColor: AppColors.accent,
                    percentage: percentage,
                  ),
                  size: const Size(80, 80),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      value,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _aiCard(BuildContext context, bool isDark) {
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;

    return Container(
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
              'You\'ve been consistent with water intake. That\'s great for your metabolism!',
              style: TextStyle(
                fontSize: 11.5,
                color: fg1,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickLogRow(BuildContext context, bool isDark) {
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _quickLogTile('Meal', Icons.restaurant, bgCard, border),
          const SizedBox(width: 8),
          _quickLogTile('Sleep', Icons.bedtime, bgCard, border),
          const SizedBox(width: 8),
          _quickLogTile('Exercise', Icons.fitness_center, bgCard, border),
        ],
      ),
    );
  }

  Widget _quickLogTile(String label, IconData icon, Color bgCard, Color border) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgCard,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.accent, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bmiCard(BuildContext context, bool isDark) {
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
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
          Text('BMI', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg3)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('24.1', style: Theme.of(context).textTheme.displayMedium),
              Text('Normal range', style: TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.48,
              minHeight: 6,
              backgroundColor: border,
              valueColor: AlwaysStoppedAnimation(AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  final Color trackColor;
  final Color fillColor;
  final double percentage;

  RingPainter({
    required this.trackColor,
    required this.fillColor,
    required this.percentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 5) / 2;

    paint.color = trackColor;
    canvas.drawCircle(center, radius, paint);

    paint.color = fillColor;
    const startAngle = -3.14159 / 2;
    final sweepAngle = (2 * 3.14159) * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(RingPainter oldDelegate) =>
    oldDelegate.percentage != percentage ||
    oldDelegate.fillColor != fillColor ||
    oldDelegate.trackColor != trackColor;
}
