import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:fitnesspal/core/models/daily_metric.dart';
import 'package:fitnesspal/core/models/habit.dart';
import 'package:fitnesspal/core/models/user_profile.dart';
import 'package:fitnesspal/core/services/firestore_service.dart';
import 'package:fitnesspal/core/theme/colors.dart';
import 'package:fitnesspal/presentation/widgets/progress_ring.dart';

const _waterRingColor = Color(0xFF06B6D4);

enum TrajectoryPeriod { today, fourWeek, twelveWeek }

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
  List<Habit> _habits = [];
  
  StreamSubscription<DailyMetric?>? _metricSub;
  StreamSubscription<UserProfile?>? _profileSub;
  StreamSubscription<List<Habit>>? _habitsSub;

  TrajectoryPeriod _selectedPeriod = TrajectoryPeriod.today;

  @override
  void initState() {
    super.initState();
    _metricSub = _firestore.streamTodayMetric().listen((m) {
      if (mounted) setState(() => _metric = m);
    });
    _profileSub = _firestore.streamUserProfile().listen((p) {
      if (mounted) setState(() => _profile = p);
    });
    _habitsSub = _firestore.streamHabits().listen((h) {
      if (mounted) setState(() => _habits = h);
    });
  }

  @override
  void dispose() {
    _metricSub?.cancel();
    _profileSub?.cancel();
    _habitsSub?.cancel();
    super.dispose();
  }

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
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE · MMMM d').format(now);
    final yearStr = DateFormat('yyyy').format(now);

    final profile = _profile;
    final metric = _metric ?? DailyMetric(
      id: 'default',
      date: DateTime.now(),
      calories: 0,
      sleepHours: 0,
      steps: 0,
      waterCups: 0,
      wellnessScore: 0.0,
      calorieTarget: profile?.calorieTarget ?? 2100,
      waterTarget: 8,
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgApp : AppColors.lightBgApp,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DashboardHeader(
                name: profile?.name ?? '...',
                dateSubtitle: '$dateStr · steady week so far',
                isDarkMode: isDark,
              ),
              const SizedBox(height: 24),
              if (profile == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  ),
                )
              else ...[
                _TrajectoryCard(
                  isDarkMode: isDark,
                  profile: profile,
                  metric: metric,
                  selectedPeriod: _selectedPeriod,
                  onPeriodChanged: (p) => setState(() => _selectedPeriod = p),
                  dateStr: '${DateFormat('MMM d').format(now)}, $yearStr',
                ),
                const SizedBox(height: 24),
                _TodayRingsSection(
                  isDarkMode: isDark,
                  metric: metric,
                  habits: _habits,
                  formatNumber: _formatNumber,
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

class _DashboardHeader extends StatelessWidget {
  final String name;
  final String dateSubtitle;
  final bool isDarkMode;

  const _DashboardHeader({
    required this.name,
    required this.dateSubtitle,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final fg1 = isDarkMode ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDarkMode ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDarkMode ? AppColors.darkFg3 : AppColors.lightFg3;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GOOD MORNING',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: fg3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Hi, $name',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: fg1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateSubtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: fg2,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            _HeaderAction(icon: LucideIcons.sparkles, isDarkMode: isDarkMode),
            const SizedBox(width: 12),
            _HeaderAction(
              icon: LucideIcons.bell,
              isDarkMode: isDarkMode,
              showDot: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final bool isDarkMode;
  final bool showDot;

  const _HeaderAction({
    required this.icon,
    required this.isDarkMode,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final border = isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;
    final card = isDarkMode ? AppColors.darkBgCard : AppColors.lightBgCard;
    final fg1 = isDarkMode ? AppColors.darkFg1 : AppColors.lightFg1;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border.withOpacity(0.5)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, color: showDot ? fg1 : AppColors.accent, size: 22),
          if (showDot)
            Positioned(
              right: 12,
              top: 12,
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
    );
  }
}

class _TrajectoryCard extends StatelessWidget {
  final bool isDarkMode;
  final UserProfile profile;
  final DailyMetric metric;
  final TrajectoryPeriod selectedPeriod;
  final ValueChanged<TrajectoryPeriod> onPeriodChanged;
  final String dateStr;

  const _TrajectoryCard({
    required this.isDarkMode,
    required this.profile,
    required this.metric,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    required this.dateStr,
  });

  @override
  Widget build(BuildContext context) {
    final fg1 = isDarkMode ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDarkMode ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDarkMode ? AppColors.darkFg3 : AppColors.lightFg3;
    final border = isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;
    final card = isDarkMode ? AppColors.darkBgCard : AppColors.lightBgCard;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Stack(
        children: [
          // Radial glow at top
          Positioned(
            top: -100,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accent.withOpacity(0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'YOUR TRAJECTORY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: fg3,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.sparkles, size: 10, color: AppColors.accent),
                        SizedBox(width: 4),
                        Text(
                          'AI',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Where you are today',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: fg1,
                ),
              ),
              Text(
                dateStr,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: fg3,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 240,
                child: Stack(
                  children: [
                    Center(
                      child: CustomPaint(
                        size: const Size(140, 220),
                        painter: _BodySilhouettePainter(
                          color: fg2.withOpacity(0.18),
                        ),
                      ),
                    ),
                    // Glow dots
                    _GlowDot(left: 0.32 * 140 + (math.max(0, (MediaQuery.of(context).size.width - 40 - 140) / 2)), top: 0.22 * 220 + 10),
                    _GlowDot(left: 0.64 * 140 + (math.max(0, (MediaQuery.of(context).size.width - 40 - 140) / 2)), top: 0.30 * 220 + 10),
                    _GlowDot(left: 0.60 * 140 + (math.max(0, (MediaQuery.of(context).size.width - 40 - 140) / 2)), top: 0.70 * 220 + 10),
                    _GlowDot(left: 0.38 * 140 + (math.max(0, (MediaQuery.of(context).size.width - 40 - 140) / 2)), top: 0.56 * 220 + 10),
                    
                    // Stat Labels
                    Positioned(
                      left: 0,
                      top: 40,
                      child: _BodyStatLabel(
                        label: 'MUSCLE',
                        value: '${profile.muscleLb.round()}',
                        unit: 'lb',
                        isDarkMode: isDarkMode,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 10,
                      child: _BodyStatLabel(
                        label: 'RECOVERY',
                        value: '${metric.recoveryPct}',
                        unit: '%',
                        isDarkMode: isDarkMode,
                        crossAxisAlignment: CrossAxisAlignment.end,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 40,
                      child: _BodyStatLabel(
                        label: 'BODY FAT',
                        value: '${profile.bodyFatPct.round()}',
                        unit: '%',
                        isDarkMode: isDarkMode,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 80,
                      child: _BodyStatLabel(
                        label: 'WEIGHT',
                        value: '${profile.weightLb.round()}',
                        unit: 'lb',
                        isDarkMode: isDarkMode,
                        crossAxisAlignment: CrossAxisAlignment.end,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _PeriodPillSelector(
                selected: selectedPeriod,
                onChanged: onPeriodChanged,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 16),
              Text(
                'Stay consistent to reach your goals — your body adapts daily.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: fg2,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlowDot extends StatelessWidget {
  final double left;
  final double top;

  const _GlowDot({required this.left, required this.top});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left - 7,
      top: top - 7,
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.accent.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _BodyStatLabel extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final bool isDarkMode;
  final CrossAxisAlignment crossAxisAlignment;

  const _BodyStatLabel({
    required this.label,
    required this.value,
    required this.unit,
    required this.isDarkMode,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final fg1 = isDarkMode ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg3 = isDarkMode ? AppColors.darkFg3 : AppColors.lightFg3;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            color: fg3,
          ),
        ),
        const SizedBox(height: 2),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: fg1,
                ),
              ),
              TextSpan(
                text: unit,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PeriodPillSelector extends StatelessWidget {
  final TrajectoryPeriod selected;
  final ValueChanged<TrajectoryPeriod> onChanged;
  final bool isDarkMode;

  const _PeriodPillSelector({
    required this.selected,
    required this.onChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDarkMode ? const Color(0xFF1F2937) : const Color(0xFFF3F4F6);

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          _PillItem(
            label: 'Today',
            isActive: selected == TrajectoryPeriod.today,
            onTap: () => onChanged(TrajectoryPeriod.today),
          ),
          _PillItem(
            label: '+4 wk',
            isActive: selected == TrajectoryPeriod.fourWeek,
            onTap: () => onChanged(TrajectoryPeriod.fourWeek),
          ),
          _PillItem(
            label: '+12 wk',
            isActive: selected == TrajectoryPeriod.twelveWeek,
            onTap: () => onChanged(TrajectoryPeriod.twelveWeek),
          ),
        ],
      ),
    );
  }
}

class _PillItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _PillItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? Colors.white : (Theme.of(context).brightness == Brightness.dark ? AppColors.darkFg2 : AppColors.lightFg2),
            ),
          ),
        ),
      ),
    );
  }
}

class _TodayRingsSection extends StatelessWidget {
  final bool isDarkMode;
  final DailyMetric metric;
  final List<Habit> habits;
  final String Function(int) formatNumber;

  const _TodayRingsSection({
    required this.isDarkMode,
    required this.metric,
    required this.habits,
    required this.formatNumber,
  });

  @override
  Widget build(BuildContext context) {
    final fg3 = isDarkMode ? AppColors.darkFg3 : AppColors.lightFg3;
    final habitsCompleted = habits.where((h) => h.isCompleted).length;
    final habitsTotal = habits.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TODAY\'S RINGS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: fg3,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Row(
                children: [
                  Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                  Icon(LucideIcons.chevronRight, size: 16, color: AppColors.accent),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _RingCard(
                label: 'CALORIES',
                value: formatNumber(metric.calories),
                sub: 'of ${formatNumber(metric.calorieTarget)} kcal',
                progress: metric.calories / metric.calorieTarget * 100,
                isDarkMode: isDarkMode,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RingCard(
                label: 'WATER',
                value: '${metric.waterCups}/${metric.waterTarget}',
                unit: ' glasses',
                sub: '${math.max(0, metric.waterTarget - metric.waterCups)} to go',
                progress: metric.waterCups / metric.waterTarget * 100,
                ringColor: _waterRingColor,
                isDarkMode: isDarkMode,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _RingCard(
                label: 'HABITS',
                value: '$habitsCompleted/$habitsTotal',
                sub: habitsCompleted == habitsTotal ? '' : '${habitsTotal - habitsCompleted} to go',
                progress: habitsTotal > 0 ? (habitsCompleted / habitsTotal * 100) : 0,
                isDarkMode: isDarkMode,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RingCard(
                label: 'ENERGY',
                value: metric.energyScore.toStringAsFixed(1),
                unit: '/10',
                progress: metric.energyScore * 10,
                isDarkMode: isDarkMode,
                centerWidget: const Icon(
                  LucideIcons.smile,
                  size: 24,
                  color: AppColors.accent,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RingCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final String sub;
  final double progress;
  final Color ringColor;
  final bool isDarkMode;
  final Widget? centerWidget;

  const _RingCard({
    required this.label,
    required this.value,
    this.unit = '',
    this.sub = '',
    required this.progress,
    this.ringColor = AppColors.accent,
    required this.isDarkMode,
    this.centerWidget,
  });

  @override
  Widget build(BuildContext context) {
    final fg1 = isDarkMode ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg3 = isDarkMode ? AppColors.darkFg3 : AppColors.lightFg3;
    final border = isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;
    final card = isDarkMode ? AppColors.darkBgCard : AppColors.lightBgCard;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          ProgressRing(
            size: 56,
            strokeWidth: 6,
            percentage: progress,
            label: '',
            value: '',
            unit: '',
            showLabel: false,
            fillColor: ringColor,
            trackColor: isDarkMode ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1),
            centerWidget: centerWidget ?? const SizedBox.shrink(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: fg3,
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: value,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: fg1,
                        ),
                      ),
                      if (unit.isNotEmpty)
                        TextSpan(
                          text: unit,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: fg3,
                          ),
                        ),
                    ],
                  ),
                ),
                if (sub.isNotEmpty)
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: fg3,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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

    // Head
    final headR = h * 0.075;
    canvas.drawCircle(Offset(cx, h * 0.09), headR, paint);

    // Torso
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

    // Left arm
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

    // Right arm
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

    // Left leg
    final leftLeg = Path()
      ..moveTo(cx - h * 0.07, h * 0.59)
      ..cubicTo(cx - h * 0.09, h * 0.72, cx - h * 0.10, h * 0.87,
          cx - h * 0.08, h * 0.97)
      ..lineTo(cx - h * 0.04, h * 0.97)
      ..cubicTo(cx - h * 0.05, h * 0.87, cx - h * 0.04, h * 0.72,
          cx - h * 0.03, h * 0.59)
      ..close();
    canvas.drawPath(leftLeg, paint);

    // Right leg
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
