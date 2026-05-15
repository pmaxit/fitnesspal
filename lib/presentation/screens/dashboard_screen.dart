import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fitnesspal/core/models/daily_metric.dart';
import 'package:fitnesspal/core/models/user_profile.dart';
import 'package:fitnesspal/core/services/firestore_service.dart';
import 'package:fitnesspal/core/theme/app_theme.dart';
import 'package:fitnesspal/core/theme/colors.dart';
import 'package:fitnesspal/presentation/widgets/progress_ring.dart';

// ── File-private color constants ──
const _emeraldGradientStart = Color(0xFF22C58B);
const _emeraldGradientEnd = Color(0xFF10B981);
const _glowColor = Color(0x3310B981);
const _scoreRingTrackColor = Color(0x33FFFFFF);

class DashboardScreen extends StatefulWidget {
  final bool isDarkMode;

  const DashboardScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirestoreService _firestore = FirestoreService();
  DailyMetric? _metric;
  UserProfile? _profile;
  StreamSubscription<DailyMetric?>? _metricSub;
  StreamSubscription<UserProfile?>? _profileSub;

  @override
  void initState() {
    super.initState();
    _metricSub = _firestore.streamTodayMetric().listen((m) {
      if (mounted) setState(() => _metric = m);
    });
    _profileSub = _firestore.streamUserProfile().listen((p) {
      if (mounted) setState(() => _profile = p);
    });
  }

  @override
  void dispose() {
    _metricSub?.cancel();
    _profileSub?.cancel();
    super.dispose();
  }

  // ── Derived data (nullable — null when data not yet loaded) ──

  String? get _greeting => _profile?.name;

  int? get _wellnessScore => _metric?.wellnessScore.round();

  String? get _aiInsight => _metric?.aiInsight;

  String? get _caloriesValue =>
      _metric != null ? _formatNumber(_metric!.calories) : null;

  double? get _caloriesProgress =>
      _metric != null ? _metric!.calories / 2500 : null;

  String? get _sleepValue =>
      _metric != null ? _metric!.sleepHours.toStringAsFixed(1) : null;

  double? get _sleepProgress =>
      _metric != null ? _metric!.sleepHours / 10 : null;

  String? get _stepsValue =>
      _metric != null ? _formatNumber(_metric!.steps) : null;

  double? get _stepsProgress =>
      _metric != null ? _metric!.steps / 10000 : null;

  String? get _waterValue =>
      _metric != null ? _metric!.waterCups.toString() : null;

  double? get _waterProgress =>
      _metric != null ? _metric!.waterCups / 10 : null;

  // Trend strings use static fallbacks (no historical comparison in models yet).
  String get _caloriesTrend => '↑ +3%';
  String get _sleepTrend => '↑ +12%';
  String get _stepsTrend => '↓ -2%';
  String get _waterTrend => '→ 0%';

  static String _formatNumber(int n) {
    final s = n.toString();
    if (s.length <= 3) return s;
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgApp : AppColors.lightBgApp,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Area ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Top row: greeting (if loaded) + notification bell
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_greeting != null)
                          Text(
                            _greeting!,
                            style: Theme.of(context).textTheme.displayMedium,
                          )
                        else
                          const SizedBox.shrink(),
                        GestureDetector(
                          onTap: () {},
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Icon(
                                  Icons.notifications_outlined,
                                  color:
                                      isDark ? AppColors.darkFg1 : AppColors.lightFg1,
                                  size: 26,
                                ),
                              ),
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Container(
                                  width: 9,
                                  height: 9,
                                  decoration: const BoxDecoration(
                                    color: AppColors.accent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // AI Coach chip
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.35),
                          ),
                          color: AppColors.accentSoft,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentGlow,
                              blurRadius: 14,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: AppColors.accent,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'AI Coach',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Loading state ──
              if (_metric == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accent,
                    ),
                  ),
                )
              else ...[
                // ── Hero Card Area ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _HeroWellnessCard(
                    isDarkMode: isDark,
                    wellnessScore: _wellnessScore!,
                    aiInsight: _aiInsight,
                  ),
                ),

                const SizedBox(height: 24),

                // ── Metric Grid Area ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Calories, Sleep
                    Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            label: 'Calories',
                            value: _caloriesValue!,
                            unit: 'kcal',
                            progress: _caloriesProgress!,
                            trend: _caloriesTrend,
                            isDarkMode: isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricCard(
                            label: 'Sleep',
                            value: _sleepValue!,
                            unit: 'hrs',
                            progress: _sleepProgress!,
                            trend: _sleepTrend,
                            isDarkMode: isDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Row 2: Steps, Water
                    Row(
                      children: [
                        Expanded(
                          child: _MetricCard(
                            label: 'Steps',
                            value: _stepsValue!,
                            unit: 'steps',
                            progress: _stepsProgress!,
                            trend: _stepsTrend,
                            isDarkMode: isDark,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _MetricCard(
                            label: 'Water',
                            value: _waterValue!,
                            unit: 'cups',
                            progress: _waterProgress!,
                            trend: _waterTrend,
                            isDarkMode: isDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── CTA Area ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AI Insight (only if available)
                    if (_aiInsight != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.accentSoft,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 12,
                                  color: _emeraldGradientEnd,
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          _emeraldGradientEnd.withValues(alpha: 0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'AI Coach',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: _emeraldGradientEnd,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _aiInsight!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color:
                                    isDark ? AppColors.darkFg1 : AppColors.lightFg1,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Today's Plan CTA
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [_emeraldGradientStart, _emeraldGradientEnd],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: _emeraldGradientEnd.withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Today's Plan",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              size: 20,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Personalized suggestion
                    Text(
                      'Start with a 20-min morning recovery flow \u2192',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.darkFg2 : AppColors.lightFg2,
                      ),
                    ),
                  ],
                ),
              ),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
// ── Body Silhouette Painter (minimalist vector outline) ──
class _BodySilhouettePainter extends CustomPainter {
  final Color color;

  _BodySilhouettePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final h = size.height;

    // Head — smooth circle
    final headR = h * 0.075;
    canvas.drawCircle(Offset(cx, h * 0.09), headR, paint);

    // Torso — organic curves from shoulders to hips
    final torso = Path()
      ..moveTo(cx, h * 0.17)
      ..cubicTo(cx - h * 0.14, h * 0.195, cx - h * 0.18, h * 0.28,
          cx - h * 0.16, h * 0.39)
      ..cubicTo(cx - h * 0.14, h * 0.47, cx - h * 0.10, h * 0.53,
          cx - h * 0.08, h * 0.58)
      ..cubicTo(cx - h * 0.04, h * 0.63, cx + h * 0.04, h * 0.63,
          cx + h * 0.08, h * 0.58)
      ..cubicTo(cx + h * 0.10, h * 0.53, cx + h * 0.14, h * 0.47,
          cx + h * 0.16, h * 0.39)
      ..cubicTo(cx + h * 0.18, h * 0.28, cx + h * 0.14, h * 0.195, cx,
          h * 0.17)
      ..close();
    canvas.drawPath(torso, paint);

    // Left arm — tapered curve from shoulder
    final leftArm = Path()
      ..moveTo(cx - h * 0.13, h * 0.21)
      ..cubicTo(cx - h * 0.22, h * 0.27, cx - h * 0.26, h * 0.37,
          cx - h * 0.23, h * 0.45)
      ..cubicTo(cx - h * 0.22, h * 0.48, cx - h * 0.18, h * 0.48,
          cx - h * 0.18, h * 0.44)
      ..cubicTo(cx - h * 0.20, h * 0.37, cx - h * 0.17, h * 0.28,
          cx - h * 0.11, h * 0.24)
      ..close();
    canvas.drawPath(leftArm, paint);

    // Right arm — mirrored
    final rightArm = Path()
      ..moveTo(cx + h * 0.13, h * 0.21)
      ..cubicTo(cx + h * 0.22, h * 0.27, cx + h * 0.26, h * 0.37,
          cx + h * 0.23, h * 0.45)
      ..cubicTo(cx + h * 0.22, h * 0.48, cx + h * 0.18, h * 0.48,
          cx + h * 0.18, h * 0.44)
      ..cubicTo(cx + h * 0.20, h * 0.37, cx + h * 0.17, h * 0.28,
          cx + h * 0.11, h * 0.24)
      ..close();
    canvas.drawPath(rightArm, paint);

    // Left leg — tapered from hip
    final leftLeg = Path()
      ..moveTo(cx - h * 0.07, h * 0.59)
      ..cubicTo(cx - h * 0.09, h * 0.72, cx - h * 0.10, h * 0.87,
          cx - h * 0.08, h * 0.97)
      ..lineTo(cx - h * 0.04, h * 0.97)
      ..cubicTo(cx - h * 0.05, h * 0.87, cx - h * 0.04, h * 0.72,
          cx - h * 0.03, h * 0.59)
      ..close();
    canvas.drawPath(leftLeg, paint);

    // Right leg — mirrored
    final rightLeg = Path()
      ..moveTo(cx + h * 0.07, h * 0.59)
      ..cubicTo(cx + h * 0.09, h * 0.72, cx + h * 0.10, h * 0.87,
          cx + h * 0.08, h * 0.97)
      ..lineTo(cx + h * 0.04, h * 0.97)
      ..cubicTo(cx + h * 0.05, h * 0.87, cx + h * 0.04, h * 0.72,
          cx + h * 0.03, h * 0.59)
      ..close();
    canvas.drawPath(rightLeg, paint);
  }

  @override
  bool shouldRepaint(_BodySilhouettePainter oldDelegate) =>
      oldDelegate.color != color;
}

// ── Hero Wellness Card ──
class _HeroWellnessCard extends StatelessWidget {
  final bool isDarkMode;
  final int wellnessScore;
  final String? aiInsight;

  const _HeroWellnessCard({
    required this.isDarkMode,
    required this.wellnessScore,
    this.aiInsight,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = isDarkMode;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgCard : AppColors.lightBgCard,
        borderRadius: BorderRadius.circular(AppTheme.radius3xl),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.darkShadowMd : AppColors.lightShadowMd,
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radius3xl),
        child: Stack(
          children: [
            // Subtle gradient overlay at top
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.topCenter,
                      radius: 1.2,
                      colors: [
                        Color.fromARGB(18, 16, 185, 129),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Card content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: score ring + silhouette
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Wellness score ring
                      _WellnessScoreRing(
                        isDarkMode: isDark,
                        score: wellnessScore,
                      ),
                      const Spacer(),
                      // Body silhouette with metrics overlaid
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 76,
                            height: 114,
                            child: CustomPaint(
                              painter: _BodySilhouettePainter(
                                color: isDark
                                    ? Colors.white.withOpacity(0.20)
                                    : AppColors.darkFg2.withOpacity(0.20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Body metrics — 2x2 grid
                  Row(
                    children: [
                      _bodyMetric(
                        textTheme,
                        '68',
                        'kg',
                        'Weight',
                        isDark,
                      ),
                      const Spacer(),
                      _bodyMetric(
                        textTheme,
                        '21',
                        '%',
                        'Body fat',
                        isDark,
                      ),
                      const Spacer(),
                      _bodyMetric(
                        textTheme,
                        '7.5',
                        'hrs',
                        'Sleep',
                        isDark,
                      ),
                      const Spacer(),
                      _bodyMetric(
                        textTheme,
                        '82',
                        '%',
                        'Recovery',
                        isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Divider
                  Container(
                    height: 1,
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  const SizedBox(height: 12),
                  // AI insight row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AI chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.accent.withOpacity(0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 10,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'AI Coach',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accent,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Insight text
                      Expanded(
                        child: Text(
                          aiInsight ?? '',
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.4,
                            fontWeight: FontWeight.w400,
                            color:
                                isDark ? AppColors.darkFg2 : AppColors.lightFg2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyMetric(
    TextTheme textTheme,
    String value,
    String unit,
    String label,
    bool isDark,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkFg1 : AppColors.lightFg1,
                  height: 1.1,
                ),
              ),
              TextSpan(
                text: ' $unit',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.accent,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.darkFg3 : AppColors.lightFg3,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

// ── Wellness Score Ring Widget ──
class _WellnessScoreRing extends StatelessWidget {
  final bool isDarkMode;
  final int score;

  const _WellnessScoreRing({
    required this.isDarkMode,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return ProgressRing(
      size: 140,
      strokeWidth: 10,
      glowColor: _glowColor,
      trackColor: isDarkMode ? _scoreRingTrackColor : AppColors.lightBorder,
      percentage: score.toDouble(),
      label: 'Wellness Score',
      value: score.toString(),
      unit: '',
      centerWidget: Text(
        score.toString(),
        style: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.w900,
          color: isDarkMode ? Colors.white : AppColors.darkFg1,
        ),
      ),
    );
  }
}

// ── Metric Mini Card Widget ──
class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final double progress;
  final String trend;
  final bool isDarkMode;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.progress,
    required this.trend,
    required this.isDarkMode,
  });

  Color _trendColor() {
    if (trend.startsWith('↑')) return Colors.green;
    if (trend.startsWith('↓')) return Colors.red;
    return isDarkMode ? AppColors.darkFg3 : AppColors.lightFg3;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBgCard : AppColors.lightBgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode ? AppColors.darkShadowSm : AppColors.lightShadowSm,
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProgressRing(
            size: 70,
            strokeWidth: 6,
            glowColor: null,
            trackColor: isDarkMode
                ? const Color(0x33FFFFFF)
                : const Color(0x1A000000),
            fillColor: AppColors.accent,
            percentage: progress * 100,
            label: '',
            value: '',
            unit: '',
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? AppColors.darkFg3 : AppColors.lightFg3,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$value $unit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDarkMode ? AppColors.darkFg1 : AppColors.lightFg1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            trend,
            style: TextStyle(fontSize: 11, color: _trendColor()),
          ),
        ],
      ),
    );
  }
}
