import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:fitnesspal/core/theme/colors.dart';
import 'package:fitnesspal/core/models/activity.dart';
import 'package:fitnesspal/core/models/daily_metric.dart';
import 'package:fitnesspal/core/services/firestore_service.dart';

class ActivityScreen extends StatefulWidget {
  final bool isDarkMode;

  const ActivityScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String _selectedPeriod = 'Day';
  List<Activity> _activities = [];
  DailyMetric? _todayMetric;
  bool _isLoading = true;
  StreamSubscription<List<Activity>>? _activitySubscription;
  StreamSubscription<DailyMetric?>? _metricSubscription;

  @override
  void initState() {
    super.initState();
    _activitySubscription =
        FirestoreService().streamActivities().listen((activities) {
      if (mounted) {
        setState(() {
          _activities = activities;
          _isLoading = false;
        });
      }
    });
    _metricSubscription =
        FirestoreService().streamTodayMetric().listen((metric) {
      if (mounted) {
        setState(() {
          _todayMetric = metric;
        });
      }
    });
  }

  @override
  void dispose() {
    _activitySubscription?.cancel();
    _metricSubscription?.cancel();
    super.dispose();
  }

  List<Activity> _filteredActivities() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (_selectedPeriod) {
      case 'Day':
        return _activities.where((a) =>
            a.date.year == today.year &&
            a.date.month == today.month &&
            a.date.day == today.day).toList();
      case 'Week':
        final weekAgo = today.subtract(const Duration(days: 7));
        return _activities.where((a) =>
            !a.date.isBefore(weekAgo) &&
            a.date.isBefore(today.add(const Duration(days: 1)))).toList();
      case 'Month':
        final monthAgo = today.subtract(const Duration(days: 30));
        return _activities.where((a) =>
            !a.date.isBefore(monthAgo) &&
            a.date.isBefore(today.add(const Duration(days: 1)))).toList();
      default:
        return [];
    }
  }

  Color _iconColorForActivity(Activity activity) {
    final title = activity.title.toLowerCase();
    if (title.contains('sleep') || title.contains('rest') || title.contains('slept')) return const Color(0xFF8B5CF6);
    if (title.contains('walk') || title.contains('run') || title.contains('morning') || title.contains('hr')) return AppColors.accent;
    if (title.contains('lunch') || title.contains('breakfast') || title.contains('meal') || title.contains('eat')) return const Color(0xFFF59E0B);
    if (title.contains('supplement') || title.contains('vitamin') || title.contains('water')) return const Color(0xFF06B6D4);
    return AppColors.accent;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;
    final metric = _todayMetric;

    if (_isLoading) {
      return SafeArea(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header matching design
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEEE · d').format(DateTime.now()).toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: fg3,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Timeline', style: Theme.of(context).textTheme.displayMedium),
                        const SizedBox(height: 4),
                        Text(
                          '${_activities.length} events • ${metric?.calories ?? 1742} kcal in • 596 out',
                          style: TextStyle(fontSize: 12, color: fg3, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      _headerIcon(LucideIcons.filter, border, fg1),
                      const SizedBox(width: 12),
                      _headerIcon(LucideIcons.bell, border, fg1),
                    ],
                  ),
                ],
              ),
            ),

            // Period selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: ['Day', 'Week', 'Month'].asMap().entries.map((entry) {
                  final index = entry.key;
                  final period = entry.value;
                  final isActive = _selectedPeriod == period;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 4,
                        right: index == 2 ? 0 : 4,
                      ),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedPeriod = period),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: isActive
                              ? AppColors.accent
                              : (isDark ? AppColors.darkBgPill : AppColors.lightBgPill),
                            border: Border.all(
                              color: isActive ? AppColors.accent : border,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            period,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isActive ? Colors.white : fg2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // Day Score card
            _buildScoreCard(metric, bgCard, border, fg1, fg3, isDark),

            // Timeline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 12, top: 12),
                    child: Text(
                      'TODAY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: fg3,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  ..._buildTimelineItems(isDark),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _headerIcon(IconData icon, Color border, Color fg1) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Icon(icon, color: fg1, size: 20),
    );
  }

  Widget _buildScoreCard(DailyMetric? metric, Color bgCard, Color border, Color fg1, Color fg3, bool isDark) {
    final score = metric != null ? (metric.wellnessScore * 10).toInt() : 87;
    final wellnessScore = metric?.wellnessScore ?? 8.7;
    final insight = metric?.aiInsight ?? "Strong day — sleep, training, and protein all on target. Hydration is the only soft spot.";
    
    final sleepScore = metric?.sleepScore ?? 88;
    final trainScore = metric?.trainScore ?? 92;
    final foodScore = metric?.foodScore ?? 74;
    final hydrationScore = metric?.hydrationScore ?? 62;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgCard,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular Score
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      value: wellnessScore / 10,
                      strokeWidth: 4,
                      backgroundColor: isDark ? Colors.white10 : Colors.black12,
                      valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                    ),
                  ),
                  Text(
                    '$score',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: fg1,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Insight text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DAY SCORE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: fg3,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      insight,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: fg1.withOpacity(0.9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Sub-scores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metricSubScore('SLEEP', sleepScore, Colors.green),
              _metricSubScore('TRAIN', trainScore, AppColors.accent),
              _metricSubScore('FOOD', foodScore, Colors.orange),
              _metricSubScore('HYDR', hydrationScore, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricSubScore(String label, int score, Color color) {
    final fg3 = widget.isDarkMode ? AppColors.darkFg3 : AppColors.lightFg3;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: fg3, letterSpacing: 0.5),
        ),
        const SizedBox(height: 4),
        Text(
          '$score',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color),
        ),
      ],
    );
  }

  List<Widget> _buildTimelineItems(bool isDark) {
    final filtered = _filteredActivities();

    if (filtered.isEmpty) {
      final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: Text(
              'No activities logged',
              style: TextStyle(fontSize: 14, color: fg3),
            ),
          ),
        ),
      ];
    }

    int parseTime(String t) {
      try {
        final parts = t.split(' ');
        final hm = parts[0].split(':');
        int h = int.parse(hm[0]);
        int m = int.parse(hm[1]);
        if (parts.length > 1) {
          if (parts[1].toUpperCase() == 'PM' && h != 12) h += 12;
          if (parts[1].toUpperCase() == 'AM' && h == 12) h = 0;
        }
        return h * 60 + m;
      } catch (_) { return 0; }
    }

    final sorted = List<Activity>.from(filtered)
      ..sort((a, b) => parseTime(b.time).compareTo(parseTime(a.time)));

    return List.generate(sorted.length, (index) {
      final activity = sorted[index];
      final isSleep = activity.title.toLowerCase().contains('sleep') || activity.title.toLowerCase().contains('slept');
      final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;
      final dotColor = isSleep ? fg3 : AppColors.accent;

      return _timelineItem(
        context,
        activity.time,
        activity.title,
        activity.subtitle ?? '',
        isDark,
        _iconColorForActivity(activity),
        dotColor,
        index == 0,
        index == sorted.length - 1,
      );
    });
  }

  Widget _timelineItem(BuildContext context, String time, String title, String subtitle, bool isDark, Color iconBg, Color dotColor, bool isFirst, bool isLast) {
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

    final isSleep = title.toLowerCase().contains('slept');
    final isMeal = title.toLowerCase().contains('meal') || title.toLowerCase().contains('breakfast');
    final isHR = title.toLowerCase().contains('hr');

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                Text(
                  time.toLowerCase().replaceAll(' am', 'a').replaceAll(' pm', 'p'),
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg3),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 14,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 22,
                  decoration: BoxDecoration(
                    gradient: isFirst ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, border],
                    ) : null,
                    color: isFirst ? null : border,
                  ),
                ),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBgApp : AppColors.lightBgApp,
                    shape: BoxShape.circle,
                    border: Border.all(color: dotColor, width: 2),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    decoration: BoxDecoration(
                      gradient: isLast ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [border, Colors.transparent],
                      ) : null,
                      color: isLast ? null : border,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgCard,
                  border: Border.all(color: border),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: iconBg.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getIconForTitle(title),
                            size: 16,
                            color: iconBg,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: fg1),
                          ),
                        ),
                        if (isSleep)
                          Text(
                            'Quality 88%',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg3),
                          ),
                        if (isMeal)
                          Text(
                            subtitle.split(' • ').first,
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg3),
                          ),
                        if (isHR)
                          Text(
                            '54 bpm',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg3),
                          ),
                      ],
                    ),
                    if (!isHR && !isMeal) ...[
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: fg2, height: 1.4),
                      ),
                    ],
                    if (isSleep) ...[
                      const SizedBox(height: 12),
                      Divider(color: border, height: 1),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: _itemMetric('7h 34m', 'TOTAL', fg1, fg3)),
                          Expanded(child: _itemMetric('88', 'QUALITY', fg1, fg3)),
                          Expanded(child: _itemMetric('54', 'AVG HR', fg1, fg3)),
                        ],
                      ),
                    ],
                    if (isHR) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.accent.withOpacity(0.15)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(LucideIcons.sparkles, size: 14, color: AppColors.accent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                subtitle,
                                style: TextStyle(fontSize: 12, color: fg1.withOpacity(0.9), height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (isMeal) ...[
                      const SizedBox(height: 12),
                      Container(
                        height: 72,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFDE047), // yellow-300
                              Color(0xFFF59E0B), // amber-500
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    final t = title.toLowerCase();
    if (t.contains('slept')) return LucideIcons.bed;
    if (t.contains('hr')) return LucideIcons.heart;
    if (t.contains('meal') || t.contains('breakfast')) return LucideIcons.target;
    if (t.contains('walk')) return LucideIcons.footprints;
    if (t.contains('run')) return LucideIcons.dumbbell;
    if (t.contains('vitamin')) return LucideIcons.pill;
    if (t.contains('water')) return LucideIcons.droplet;
    return LucideIcons.calendar;
  }

  Widget _itemMetric(String value, String label, Color fg1, Color fg3) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: fg1)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: fg3, letterSpacing: 0.5)),
      ],
    );
  }
}