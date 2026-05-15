import 'dart:async';

import 'package:flutter/material.dart';
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

  String _scoreLabel(double score) {
    if (score >= 9.0) return 'Excellent';
    if (score >= 7.0) return 'Great';
    if (score >= 5.0) return 'Good';
    return 'Needs Work';
  }

  Color _iconColorForActivity(Activity activity) {
    // Map common activity titles to colors matching the original defaults
    final title = activity.title.toLowerCase();
    if (title.contains('sleep') || title.contains('rest')) return Colors.purple;
    if (title.contains('walk') || title.contains('run') || title.contains('morning')) return Colors.green;
    if (title.contains('lunch') || title.contains('breakfast') || title.contains('meal') || title.contains('eat')) return Colors.orange;
    if (title.contains('supplement') || title.contains('vitamin') || title.contains('water')) return Colors.blue;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ACTIVITY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg3, letterSpacing: 0.1)),
                  const SizedBox(height: 4),
                  Text('Activity Log', style: Theme.of(context).textTheme.displayMedium),
                ],
              ),
            ),

            // Period selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: ['Day', 'Week', 'Month'].map((period) {
                  final isActive = _selectedPeriod == period;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPeriod = period),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: isActive
                            ? AppColors.accent
                            : (isDark ? AppColors.darkBgPill : AppColors.lightBgPill),
                          border: Border.all(
                            color: isActive
                              ? AppColors.accent
                              : border,
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
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // Score card — only when _todayMetric has data
            if (_todayMetric != null)
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
                    Text('Today\'s Score', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg3)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${_todayMetric!.wellnessScore.toStringAsFixed(1)} / 10', style: Theme.of(context).textTheme.displayMedium),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.accentSoft,
                            border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _scoreLabel(_todayMetric!.wellnessScore),
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.accent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Timeline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: _buildTimelineItems(isDark),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
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

    // Sort ascending by time for chronological display
    final sorted = List<Activity>.from(filtered)
      ..sort((a, b) => a.time.compareTo(b.time));

    return sorted.map((activity) => _timelineItem(
      context,
      activity.time,
      activity.title,
      activity.subtitle ?? '',
      isDark,
      _iconColorForActivity(activity),
    )).toList();
  }

  Widget _timelineItem(BuildContext context, String time, String title, String subtitle, bool isDark, Color iconBg) {
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(time, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg3)),
              const SizedBox(height: 8),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 8, spreadRadius: 3),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgCard,
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: iconBg.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 11, color: fg3)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}