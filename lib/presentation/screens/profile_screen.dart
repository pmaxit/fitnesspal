import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitnesspal/core/models/daily_metric.dart';
import 'package:fitnesspal/core/models/user_profile.dart';
import 'package:fitnesspal/core/services/firestore_service.dart';
import 'package:fitnesspal/core/services/auth_service.dart';
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
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

    if (_profile == null && _metric == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final initials = _profile?.initials ?? 'MC';
    final name = _profile?.name ?? 'Maya Chen';
    final age = _profile?.age ?? 28;
    final heightInches = _profile?.heightInches ?? 67;
    final weight = _profile?.weightLb.toStringAsFixed(0) ?? '0';
    final activityLevel = _profile?.activityLevel ?? 'low activity';
    
    final goalWeight = _profile?.goalWeightLb.toStringAsFixed(0) ?? '0';
    final diff = (_profile?.weightLb ?? 0) - (_profile?.goalWeightLb ?? 0);
    final weightDiff = diff > 0 ? '${diff.toStringAsFixed(0)} lb to go' : 'Goal reached';
    
    final calorieTarget = _profile?.calorieTarget ?? 2100;
    final sleepGoal = _profile?.sleepGoalHr ?? 8;
    final fitnessExp = _profile?.fitnessExperience ?? 'Intermediate';
    final isVegetarian = _profile?.isVegetarian ?? false;
    
    final heightFt = heightInches ~/ 12;
    final heightIn = heightInches % 12;

    final scoreValue = _metric?.wellnessScore ?? 0.0;
    final displayScore = (scoreValue * 10).round();

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Profile', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.w900, color: fg1)),
                      const SizedBox(height: 4),
                      Text('$name · joined Jan 2026', style: TextStyle(fontSize: 14, color: fg2)),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: bgCard,
                      border: Border.all(color: border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(LucideIcons.logOut, color: fg1),
                      onPressed: () async {
                        await AuthService().signOut();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // User hero
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgCard,
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.accent, Color(0xFF059669)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 20, color: fg1),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$age · $heightFt\'$heightIn" · $weight lb · ${activityLevel.toLowerCase()}',
                          style: TextStyle(fontSize: 13, color: fg2),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _goalPill('Lose ${diff > 0 ? diff.toStringAsFixed(0) : "0"} lb', true, bgCard, border, isDark),
                            if (isVegetarian) _goalPill('Vegetarian', false, bgCard, border, isDark),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Wellness score ring card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: bgCard,
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CustomPaint(
                            painter: WellnessRingPainter(percentage: displayScore.toDouble()),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              displayScore.toString(),
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: fg1, height: 1),
                            ),
                            const SizedBox(width: 4),
                            RotatedBox(
                              quarterTurns: 3,
                              child: Text(
                                'WELLNESS',
                                style: TextStyle(fontSize: 7, fontWeight: FontWeight.w700, color: fg3, letterSpacing: 1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AI WELLNESS SCORE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: fg3, letterSpacing: 1.2)),
                        const SizedBox(height: 6),
                        Text(
                          _metric != null 
                              ? "You've been steady this month — sleep, training and hydration are all trending up."
                              : "Log your first activity to see your AI wellness score and insights.",
                          style: TextStyle(fontSize: 13, color: fg1, height: 1.4, fontWeight: FontWeight.w500),
                        ),
                        if (_metric != null) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(LucideIcons.sparkles, size: 14, color: AppColors.accent),
                              const SizedBox(width: 4),
                              Text(
                                '+6 from last month',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accent),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Goals Section Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GOALS',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: fg3, letterSpacing: 1.2),
                  ),
                  GestureDetector(
                    onTap: _showEditProfileDialog,
                    child: Row(
                      children: [
                        Text('Edit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accent)),
                        const SizedBox(width: 2),
                        Icon(LucideIcons.chevronRight, size: 16, color: AppColors.accent),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Goals List
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: bgCard,
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _goalListItem(
                    icon: LucideIcons.target, 
                    iconColor: AppColors.accent, 
                    title: 'Goal weight', 
                    subtitle: weightDiff, 
                    value: '$goalWeight lb', 
                    isDark: isDark, 
                    showDivider: true,
                    onTap: () => _showEditNumberDialog(
                      title: 'Edit Goal Weight',
                      initialValue: goalWeight,
                      suffix: 'lb',
                      isDouble: true,
                      onSave: (val) {
                        if (_profile != null) _updateProfile(_profile!.copyWith(goalWeightLb: val as double));
                      },
                    ),
                  ),
                  _goalListItem(
                    icon: LucideIcons.zap, 
                    iconColor: AppColors.accent, 
                    title: 'Calorie target', 
                    subtitle: 'Daily limit', 
                    value: '$calorieTarget kcal', 
                    isDark: isDark, 
                    showDivider: true,
                    onTap: () => _showEditNumberDialog(
                      title: 'Edit Calorie Target',
                      initialValue: calorieTarget.toString(),
                      suffix: 'kcal',
                      isDouble: false,
                      onSave: (val) {
                        if (_profile != null) _updateProfile(_profile!.copyWith(calorieTarget: val as int));
                      },
                    ),
                  ),
                  _goalListItem(
                    icon: LucideIcons.heart, 
                    iconColor: AppColors.accent, 
                    title: 'Activity level', 
                    subtitle: 'General activity', 
                    value: activityLevel, 
                    isDark: isDark, 
                    showDivider: true,
                    onTap: () => _showEditDropdownDialog(
                      title: 'Edit Activity Level',
                      currentValue: activityLevel,
                      options: ['Low', 'Moderate', 'High'],
                      onSave: (val) {
                        if (_profile != null) _updateProfile(_profile!.copyWith(activityLevel: val));
                      },
                    ),
                  ),
                  _goalListItem(
                    icon: LucideIcons.refreshCw, 
                    iconColor: AppColors.accent, 
                    title: 'Sleep goal', 
                    subtitle: 'Nightly target', 
                    value: '$sleepGoal hr', 
                    isDark: isDark, 
                    showDivider: true,
                    onTap: () => _showEditNumberDialog(
                      title: 'Edit Sleep Goal',
                      initialValue: sleepGoal.toString(),
                      suffix: 'hr',
                      isDouble: false,
                      onSave: (val) {
                        if (_profile != null) _updateProfile(_profile!.copyWith(sleepGoalHr: val as int));
                      },
                    ),
                  ),
                  _goalListItem(
                    icon: LucideIcons.navigation, 
                    iconColor: AppColors.accent, 
                    title: 'Fitness experience', 
                    subtitle: 'Training level', 
                    value: fitnessExp, 
                    isDark: isDark, 
                    showDivider: false,
                    onTap: () => _showEditDropdownDialog(
                      title: 'Edit Fitness Experience',
                      currentValue: fitnessExp,
                      options: ['Beginner', 'Intermediate', 'Advanced'],
                      onSave: (val) {
                        if (_profile != null) _updateProfile(_profile!.copyWith(fitnessExperience: val));
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile(UserProfile updated) async {
    await FirestoreService().saveUserProfile(updated);
  }

  void _showEditProfileDialog() {
    if (_profile == null) return;
    final nameCtrl = TextEditingController(text: _profile!.name);
    final ageCtrl = TextEditingController(text: _profile!.age.toString());
    final heightCtrl = TextEditingController(text: _profile!.heightInches.toString());
    final weightCtrl = TextEditingController(text: _profile!.weightLb.toStringAsFixed(1));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: ageCtrl, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
              TextField(controller: heightCtrl, decoration: const InputDecoration(labelText: 'Height (inches)'), keyboardType: TextInputType.number),
              TextField(controller: weightCtrl, decoration: const InputDecoration(labelText: 'Weight (lb)'), keyboardType: const TextInputType.numberWithOptions(decimal: true)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final age = int.tryParse(ageCtrl.text) ?? _profile!.age;
              final height = int.tryParse(heightCtrl.text) ?? _profile!.heightInches;
              final weight = double.tryParse(weightCtrl.text) ?? _profile!.weightLb;
              _updateProfile(_profile!.copyWith(
                name: nameCtrl.text,
                age: age,
                heightInches: height,
                weightLb: weight,
              ));
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditNumberDialog({
    required String title,
    required String initialValue,
    required String suffix,
    required bool isDouble,
    required void Function(num) onSave,
  }) {
    final controller = TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: isDouble),
          decoration: InputDecoration(suffixText: suffix),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final val = isDouble 
                  ? double.tryParse(controller.text) 
                  : int.tryParse(controller.text);
              if (val != null) {
                onSave(val);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showEditDropdownDialog({
    required String title,
    required String currentValue,
    required List<String> options,
    required void Function(String) onSave,
  }) {
    // If currentValue isn't in options exactly (case difference maybe), default to first.
    String selected = options.firstWhere((o) => o.toLowerCase() == currentValue.toLowerCase(), orElse: () => options.first);
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: DropdownButton<String>(
              value: selected,
              isExpanded: true,
              items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => selected = val);
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  onSave(selected);
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _goalPill(String label, bool isAccent, Color bgCard, Color border, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAccent ? AppColors.accentSoft2 : Colors.transparent,
        border: Border.all(color: isAccent ? AppColors.accent.withOpacity(0.3) : border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isAccent ? AppColors.accent : (isDark ? AppColors.darkFg2 : AppColors.lightFg2),
        ),
      ),
    );
  }

  Widget _goalListItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String value,
    required bool isDark,
    required bool showDivider,
    VoidCallback? onTap,
  }) {
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;
    final iconBg = isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20), // Matches container roughly
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: fg1)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: TextStyle(fontSize: 13, color: fg3)),
                    ],
                  ),
                ),
                Text(value, style: TextStyle(fontSize: 15, color: fg2)),
                const SizedBox(width: 8),
                Icon(LucideIcons.chevronRight, size: 18, color: fg3),
              ],
            ),
          ),
          if (showDivider)
            Divider(height: 0, thickness: 1, color: border, indent: 72),
        ],
      ),
    );
  }
}

class WellnessRingPainter extends CustomPainter {
  final double percentage;

  WellnessRingPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 6.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - paint.strokeWidth) / 2;

    paint.color = AppColors.accent.withOpacity(0.15);
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