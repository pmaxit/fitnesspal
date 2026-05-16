import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitnesspal/core/theme/colors.dart';
import 'package:fitnesspal/core/services/firestore_service.dart';
import 'package:fitnesspal/core/services/ai_service.dart';
import 'package:fitnesspal/core/models/habit.dart';
import 'dart:async';

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
    if (colorStr.startsWith('#')) {
      final hex = colorStr.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    }
    return AppColors.accent;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;
    final bgApp = isDark ? AppColors.darkBgApp : AppColors.lightBgApp;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: bgApp,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Calculate stats
    final totalHabits = _habits.length;
    final completedToday = _habits.where((h) => h.isCompleted).length;
    const consistency = 0; // Reset from 87 to 0 for new user state
    final currentStreak = _habits.isEmpty ? 0 : _habits.map((h) => h.streakValue).reduce((a, b) => a > b ? a : b);
    final recordStreak = _habits.isEmpty ? 0 : _habits.map((h) => h.recordStreak).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      backgroundColor: bgApp,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(context, completedToday, totalHabits, consistency, currentStreak, fg1, fg2, fg3),
              const SizedBox(height: 24),
              _buildStreakHero(context, currentStreak, recordStreak, isDark),
              const SizedBox(height: 24),
              _buildCalendarHeatmap(context, isDark, fg1, fg3),
              const SizedBox(height: 24),
              _buildTodaySectionHeader(context, completedToday, totalHabits, fg2, fg3),
              const SizedBox(height: 12),
              _buildHabitList(context, isDark),
              const SizedBox(height: 100), // Bottom nav padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int done, int total, int consistency, int currentStreak, Color fg1, Color fg2, Color fg3) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'APRIL 2026 • $currentStreak-DAY STREAK',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: fg3,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Habits',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: fg1,
              ),
            ),
            Row(
              children: [
                _iconButton(LucideIcons.sliders, widget.isDarkMode),
                const SizedBox(width: 12),
                _iconButton(
                  LucideIcons.plus,
                  widget.isDarkMode,
                  isAccent: true,
                  onTap: () => _showAddHabitModal(context),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$done of $total today • $consistency% consistency this month',
          style: TextStyle(
            fontSize: 14,
            color: fg2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _iconButton(IconData icon, bool isDark, {bool isAccent = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isAccent ? AppColors.accent : (isDark ? AppColors.darkBgCard : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: isAccent ? null : Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          boxShadow: isAccent ? [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Icon(
          icon,
          color: isAccent ? Colors.white : (isDark ? Colors.white : Colors.black),
          size: 22,
        ),
      ),
    );
  }

  Widget _buildStreakHero(BuildContext context, int current, int record, bool isDark) {
    final bg = isDark ? AppColors.darkBgCardSolid : Colors.white;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.darkBorder.withOpacity(0.5) : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(LucideIcons.flame, color: Colors.orange, size: 32),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CURRENT STREAK',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg3, letterSpacing: 0.5),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$current',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: fg1),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'days',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: fg2),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${record - current} more to beat your record of $record',
                  style: TextStyle(fontSize: 13, color: fg2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeatmap(BuildContext context, bool isDark, Color fg1, Color fg3) {
    final bg = isDark ? AppColors.darkBgCardSolid : Colors.white;
    final heatMap = isDark ? AppColors.darkHeatMap : AppColors.lightHeatMap;

    // Fixed mockup for April 2026
    // 1st is Wednesday (index 2)

    // Padding for Monday start
    // April 1, 2026 is a Wednesday.
    // M T W T F S S
    //     1 2 3 4 5
    // 6 7 8 9 10 11 12
    // 13 14...
    
    final days = [
      -1, -1, 1, 2, 3, 4, 5,
      6, 7, 8, 9, 10, 11, 12,
      13, 14, 15, 16, 17, 18, 19,
      20, 21, 22, 23, 24, 25, 26,
      27, 28, 29, 30, -1, -1, -1
    ];

    // Map day to intensity based on image
    // Calculate intensity based on actual habit completion dates
    int getIntensity(int day) {
      if (day == -1) return -1;
      
      // Get the month/year we are currently viewing (April 2026 based on UI)
      // Note: In a real app, this would be dynamic based on current month view
      final date = DateTime(2026, 4, day);
      
      int completedCount = 0;
      for (final habit in _habits) {
        final wasCompleted = habit.completedDates.any((d) => 
          d.year == date.year && d.month == date.month && d.day == date.day
        );
        if (wasCompleted) completedCount++;
      }
      
      if (completedCount == 0) return 0;
      
      // Calculate intensity (0-4) based on percentage of habits completed
      if (_habits.isEmpty) return 0;
      final percentage = completedCount / _habits.length;
      if (percentage >= 1.0) return 4; // All
      if (percentage >= 0.7) return 3; // Most
      if (percentage >= 0.4) return 2; // Some
      return 1; // Light
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.darkBorder.withOpacity(0.5) : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('APRIL 2026', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: fg3, letterSpacing: 0.5)),
              Row(
                children: [
                  _smallNavButton(LucideIcons.chevronLeft, isDark),
                  const SizedBox(width: 8),
                  _smallNavButton(LucideIcons.chevronRight, isDark),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildHeatmapLegend(isDark),
          const SizedBox(height: 20),
          _buildWeekdayHeaders(fg3),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              if (day == -1) return const SizedBox.shrink();
              
              final intensity = getIntensity(day);
              final color = intensity == 0 ? Colors.transparent : heatMap[intensity];
              final isToday = day == 14; // Mocking today as 14th to match image circle

              return Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                  border: isToday ? Border.all(color: AppColors.accent, width: 2) : null,
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: intensity > 2 ? Colors.white : (intensity > 0 ? fg1 : fg3.withOpacity(0.5)),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _smallNavButton(IconData icon, bool isDark) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgCard : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: isDark ? Colors.white : Colors.black),
    );
  }

  Widget _buildHeatmapLegend(bool isDark) {
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;
    final heatMap = isDark ? AppColors.darkHeatMap : AppColors.lightHeatMap;

    return Row(
      children: [
        _legendItem('Light', heatMap[1], fg3),
        const SizedBox(width: 12),
        _legendItem('Some', heatMap[2], fg3),
        const SizedBox(width: 12),
        _legendItem('Most', heatMap[3], fg3),
        const SizedBox(width: 12),
        _legendItem('All', heatMap[4], fg3),
      ],
    );
  }

  Widget _legendItem(String label, Color color, Color textColor) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor)),
      ],
    );
  }

  Widget _buildWeekdayHeaders(Color color) {
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: labels.map((l) => SizedBox(
        width: 30,
        child: Center(
          child: Text(l, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ),
      )).toList(),
    );
  }

  Widget _buildTodaySectionHeader(BuildContext context, int done, int total, Color fg2, Color fg3) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'TODAY • $done OF $total DONE',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: fg3, letterSpacing: 0.5),
        ),
        Row(
          children: [
            Text('All', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.accent)),
            const SizedBox(width: 4),
            Icon(LucideIcons.chevronRight, size: 18, color: AppColors.accent),
          ],
        ),
      ],
    );
  }

  Widget _buildHabitList(BuildContext context, bool isDark) {
    return Column(
      children: _habits.map((habit) => _buildHabitItem(context, habit, isDark)).toList(),
    );
  }

  Widget _buildHabitItem(BuildContext context, Habit habit, bool isDark) {
    final bg = isDark ? AppColors.darkBgCardSolid : Colors.white;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    
    return GestureDetector(
      onTap: () => _showAddHabitModal(context, habit: habit),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? AppColors.darkBorder.withOpacity(0.5) : AppColors.lightBorder),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => FirestoreService().toggleHabit(habit.id),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: habit.isCompleted ? AppColors.accent : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: habit.isCompleted ? AppColors.accent : (isDark ? AppColors.darkBorderStrong : Colors.grey[300]!),
                    width: 2,
                  ),
                ),
                child: habit.isCompleted
                    ? Icon(LucideIcons.check, color: Colors.white, size: 18)
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _parseColor(habit.categoryColor),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        habit.name,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: fg1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    habit.description,
                    style: TextStyle(fontSize: 13, color: fg2),
                  ),
                ],
              ),
            ),
            _streakBadge(habit.streakValue, isDark),
          ],
        ),
      ),
    );
  }

  Widget _streakBadge(int streak, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.flame, color: Colors.orange, size: 14),
          const SizedBox(width: 2),
          Text(
            '$streak',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.orange),
          ),
        ],
      ),
    );
  }
  void _showAddHabitModal(BuildContext context, {Habit? habit}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddHabitBottomSheet(isDarkMode: widget.isDarkMode, habit: habit),
    );
  }
}

class _AddHabitBottomSheet extends StatefulWidget {
  final bool isDarkMode;
  final Habit? habit;

  const _AddHabitBottomSheet({required this.isDarkMode, this.habit});

  @override
  State<_AddHabitBottomSheet> createState() => _AddHabitBottomSheetState();
}

class _AddHabitBottomSheetState extends State<_AddHabitBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late String _aiGoal;
  late int _aiDifficulty;
  bool _isAnalyzing = false;
  final AiService _aiService = AiService();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.habit?.name);
    _descriptionController = TextEditingController(text: widget.habit?.description);
    _aiGoal = widget.habit?.goal ?? "Type to see goal...";
    _aiDifficulty = widget.habit?.difficulty ?? 1;
    
    _titleController.addListener(_onInputChanged);
    _descriptionController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_titleController.text.isNotEmpty || _descriptionController.text.isNotEmpty) {
        _analyzeHabit();
      }
    });
  }


  Future<void> _analyzeHabit() async {
    setState(() {
      _isAnalyzing = true;
    });

    final result = await _aiService.analyzeHabit(
      _titleController.text,
      _descriptionController.text,
    );

    if (mounted) {
      setState(() {
        _aiGoal = result['goal'] ?? "No goal found";
        final rawDifficulty = result['difficulty'];
        if (rawDifficulty is int) {
          _aiDifficulty = rawDifficulty;
        } else if (rawDifficulty is String) {
          switch (rawDifficulty.toLowerCase()) {
            case 'easy': _aiDifficulty = 1; break;
            case 'moderate': _aiDifficulty = 3; break;
            case 'hard': _aiDifficulty = 5; break;
            default: _aiDifficulty = int.tryParse(rawDifficulty) ?? 1;
          }
        } else {
          _aiDifficulty = 1;
        }
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bg = isDark ? AppColors.darkBgApp : Colors.white;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final cardBg = isDark ? AppColors.darkBgCard : Colors.grey[100]!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBorder : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.habit == null ? 'New Habit' : 'Edit Habit',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: fg1),
          ),
          const SizedBox(height: 24),
          _buildTextField('Title', 'e.g. Morning Run', _titleController, isDark),
          const SizedBox(height: 16),
          _buildTextField('Description', 'Why this habit?', _descriptionController, isDark, maxLines: 3),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? AppColors.darkBorder : Colors.transparent),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('AI ANALYSIS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg2, letterSpacing: 1.0)),
                    if (_isAnalyzing)
                      const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Goal: $_aiGoal',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: fg1),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Difficulty: ', style: TextStyle(fontSize: 13, color: fg2)),
                    ...List.generate(5, (index) => Icon(
                      LucideIcons.star,
                      size: 14,
                      color: index < _aiDifficulty ? Colors.orange : (isDark ? AppColors.darkBorder : Colors.grey[300]),
                    )),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _titleController.text.isEmpty ? null : () async {
                if (widget.habit == null) {
                  final newHabit = Habit(
                    id: '', // Firestore will generate this
                    name: _titleController.text,
                    description: _descriptionController.text,
                    goal: _aiGoal,
                    streak: '0 days',
                    streakValue: 0,
                    recordStreak: 0,
                    isCompleted: false,
                    iconColor: '#10B981',
                    categoryColor: '#10B981',
                    createdAt: DateTime.now(),
                    completedDates: [],
                    difficulty: _aiDifficulty,
                  );
                  await FirestoreService().addHabit(newHabit);
                } else {
                  final updatedHabit = widget.habit!.copyWith(
                    name: _titleController.text,
                    description: _descriptionController.text,
                    goal: _aiGoal,
                    difficulty: _aiDifficulty,
                  );
                  await FirestoreService().updateHabit(updatedHabit);
                }
                if (mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                widget.habit == null ? 'Create Habit' : 'Update Habit',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, bool isDark, {int maxLines = 1}) {
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final bg = isDark ? AppColors.darkBgCard : Colors.grey[100]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: fg2)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: fg1, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: fg2.withOpacity(0.5)),
            filled: true,
            fillColor: bg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
