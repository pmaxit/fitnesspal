import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fitnesspal/core/models/daily_metric.dart';
import 'package:fitnesspal/core/models/user_profile.dart';
import 'package:fitnesspal/core/services/firestore_service.dart';
import 'package:fitnesspal/core/theme/colors.dart';

class ProfileScreen extends StatefulWidget {
  final bool isDarkMode;

  const ProfileScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _profile;
  DailyMetric? _metric;
  StreamSubscription<UserProfile?>? _profileSub;
  StreamSubscription<DailyMetric?>? _metricSub;

  @override
  void initState() {
    super.initState();
    _profileSub = FirestoreService()
        .streamUserProfile()
        .listen((profile) => setState(() => _profile = profile));
    _metricSub = FirestoreService()
        .streamTodayMetric()
        .listen((metric) => setState(() => _metric = metric));
  }

  @override
  void dispose() {
    _profileSub?.cancel();
    _metricSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

    if (_profile == null && _metric == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final initials = _profile?.initials;
    final name = _profile?.name;
    final bio = _profile?.bio;
    final goals = _profile?.goals;
    final hasGoals = goals != null && goals.isNotEmpty;
    final scoreValue = _metric?.wellnessScore;
    final hasMetric = scoreValue != null;

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
                  Text('PROFILE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg3, letterSpacing: 0.1)),
                  const SizedBox(height: 4),
                  Text('Profile', style: Theme.of(context).textTheme.displayMedium),
                ],
              ),
            ),

            // User hero
            if (_profile != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgCard,
                  border: Border.all(color: border),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.accent, Color(0xFF059669)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          initials ?? '',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (name != null)
                            Text(
                              name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          if (name != null && bio != null) const SizedBox(height: 2),
                          if (bio != null)
                            Text(
                              bio,
                              style: TextStyle(fontSize: 12, color: fg2),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Goals
            if (hasGoals) _goalPills(context, isDark, goals),

            // Wellness score ring
            if (hasMetric)
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
                    Text('Wellness Score', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg3)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${scoreValue.toStringAsFixed(1)} / 10', style: Theme.of(context).textTheme.displayMedium),
                            const SizedBox(height: 4),
                            Text('Excellent health', style: TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CustomPaint(
                            painter: WellnessRingPainter(percentage: (scoreValue / 10.0 * 100).round().toDouble()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Body metrics
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'BODY METRICS',
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
                  _metricRow('Height', '5\'11"', isDark),
                  _metricRow('Weight', '178 lbs', isDark),
                  _metricRow('BMI', '24.8', isDark),
                  _metricRow('Body Fat %', '18.2%', isDark),
                ],
              ),
            ),

            // Integrations
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'DEVICE INTEGRATIONS',
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
                  _integrationRow('Apple Health', Icons.apple, isDark),
                  _integrationRow('WHOOP', Icons.watch, isDark),
                  _integrationRow('Garmin', Icons.directions_run, isDark),
                  _integrationRow('Fitbit', Icons.favorite, isDark),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _goalPills(BuildContext context, bool isDark, List<String> goals) {
    final bgPill = isDark ? AppColors.darkBgPill : AppColors.lightBgPill;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: goals.map((goal) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _goalPill(goal, bgPill, border),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _goalPill(String label, Color bgPill, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.accent,
        ),
      ),
    );
  }

  Widget _metricRow(String label, String value, bool isDark) {
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              Text(value, style: TextStyle(fontSize: 13, color: fg3, fontVariations: const [FontVariation('wght', 700)])),
            ],
          ),
        ),
        if (label != 'Body Fat %')
          Divider(height: 0, thickness: 1, color: border),
      ],
    );
  }

  Widget _integrationRow(String label, IconData icon, bool isDark) {
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.accent, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              ),
              const Icon(Icons.chevron_right, size: 20),
            ],
          ),
        ),
        if (label != 'Fitbit')
          Divider(height: 0, thickness: 1, color: border),
      ],
    );
  }
}

class WellnessRingPainter extends CustomPainter {
  final double percentage;

  WellnessRingPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 4) / 2;

    paint.color = AppColors.accent.withOpacity(0.2);
    canvas.drawCircle(center, radius, paint);

    paint.color = AppColors.accent;
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
  bool shouldRepaint(WellnessRingPainter oldDelegate) =>
    oldDelegate.percentage != percentage;
}