import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitnesspal/core/theme/colors.dart';
import 'package:fitnesspal/core/models/habit_category.dart';
import 'package:fitnesspal/core/models/habit.dart';
import 'package:fitnesspal/core/services/habit_categories_service.dart';
import 'package:fitnesspal/core/services/firestore_service.dart';
import 'package:fitnesspal/core/utils/habit_category_constants.dart';
import 'package:intl/intl.dart';

class HabitSettingsScreen extends StatefulWidget {
  final bool isDarkMode;

  const HabitSettingsScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  State<HabitSettingsScreen> createState() => _HabitSettingsScreenState();
}

class _HabitSettingsScreenState extends State<HabitSettingsScreen> {
  final HabitCategoriesService _categoriesService = HabitCategoriesService();
  List<HabitCategory> _categories = [];
  List<Habit> _habits = [];
  bool _isLoading = true;
  int _selectedDays = 7;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _categoriesService.initDefaultsIfNeeded();
    _categoriesService.streamCategories().listen((cats) {
      if (mounted) {
        setState(() {
          _categories = cats;
          _isLoading = false;
        });
      }
    });
    FirestoreService().streamHabits().listen((habits) {
      if (mounted) {
        setState(() {
          _habits = habits;
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

  IconData _getIconData(String iconName) {
    final iconMap = {
      'dumbbell': LucideIcons.dumbbell,
      'leaf': LucideIcons.leaf,
      'bed': LucideIcons.bed,
      'brain': LucideIcons.brain,
      'users': LucideIcons.users,
      'palette': LucideIcons.palette,
      'heart': LucideIcons.heart,
      'zap': LucideIcons.zap,
      'target': LucideIcons.target,
      'flame': LucideIcons.flame,
      'droplet': LucideIcons.droplet,
      'pill': LucideIcons.pill,
      'sun': LucideIcons.sun,
      'moon': LucideIcons.moon,
      'coffee': LucideIcons.coffee,
      'music': LucideIcons.music,
      'book': LucideIcons.book,
    };
    return iconMap[iconName] ?? LucideIcons.check;
  }

  List<FlSpot> _calculateChartData() {
    final now = DateTime.now();
    final spots = <FlSpot>[];

    for (int i = _selectedDays - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      int completedCount = 0;

      for (final habit in _habits) {
        final wasCompleted = habit.completedDates.any((d) =>
            d.year == date.year && d.month == date.month && d.day == date.day);
        if (wasCompleted) completedCount++;
      }

      final percentage = _habits.isEmpty ? 0.0 : (completedCount / _habits.length) * 100;
      spots.add(FlSpot((_selectedDays - 1 - i).toDouble(), percentage));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bgApp = isDark ? AppColors.darkBgApp : AppColors.lightBgApp;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;
    final cardBg = isDark ? AppColors.darkBgCardSolid : Colors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      backgroundColor: bgApp,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildHeader(context, fg1, fg3),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          _buildChartCard(isDark, cardBg, fg1, fg2, fg3, border),
                          const SizedBox(height: 24),
                          _buildCategoriesSectionHeader(fg2, fg3),
                          const SizedBox(height: 12),
                          _buildCategoriesList(cardBg, fg1, fg2, fg3, border),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color fg1, Color fg3) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: widget.isDarkMode ? AppColors.darkBgCard : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(LucideIcons.chevronLeft, color: fg1, size: 22),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Habit Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: fg1),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(bool isDark, Color cardBg, Color fg1, Color fg2, Color fg3, Color border) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DAILY COMPLETION',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg3, letterSpacing: 1.0),
          ),
          const SizedBox(height: 16),
          Row(
            children: [7, 14, 30].map((days) {
              final isSelected = _selectedDays == days;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDays = days),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accent : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.accent : border,
                      ),
                    ),
                    child: Text(
                      '$days',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : fg2,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: _habits.isEmpty
                ? Center(
                    child: Text(
                      'No habit data yet',
                      style: TextStyle(color: fg3, fontSize: 14),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 25,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: border.withOpacity(0.3),
                          strokeWidth: 1,
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 25,
                            reservedSize: 32,
                            getTitlesWidget: (value, meta) => Text(
                              '${value.toInt()}%',
                              style: TextStyle(color: fg3, fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 24,
                            interval: (_selectedDays == 7 ? 1 : (_selectedDays == 14 ? 2 : 5)).toDouble(),
                            getTitlesWidget: (value, meta) {
                              final now = DateTime.now();
                              final date = DateTime(now.year, now.month, now.day - (_selectedDays - 1 - value.toInt()));
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  DateFormat('E').format(date).substring(0, 1),
                                  style: TextStyle(color: fg3, fontSize: 10, fontWeight: FontWeight.w600),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: (_selectedDays - 1).toDouble(),
                      minY: 0,
                      maxY: 100,
                      lineBarsData: [
                        LineChartBarData(
                          spots: _calculateChartData(),
                          isCurved: true,
                          color: AppColors.accent,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                              radius: 4,
                              color: AppColors.accent,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: AppColors.accent.withOpacity(0.15),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSectionHeader(Color fg2, Color fg3) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'CATEGORIES',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: fg3, letterSpacing: 0.5),
        ),
        GestureDetector(
          onTap: () => _showCategoryBottomSheet(context, null),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.plus, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Add',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesList(Color cardBg, Color fg1, Color fg2, Color fg3, Color border) {
    return Column(
      children: _categories.map((category) {
        return _buildCategoryItem(category, cardBg, fg1, fg2, fg3, border);
      }).toList(),
    );
  }

  Widget _buildCategoryItem(
    HabitCategory category,
    Color cardBg,
    Color fg1,
    Color fg2,
    Color fg3,
    Color border,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _parseColor(category.colorHex).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconData(category.iconName),
              color: _parseColor(category.colorHex),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: fg1),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tap to edit',
                  style: TextStyle(fontSize: 12, color: fg3),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showCategoryBottomSheet(context, category),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBgCard : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(LucideIcons.pencil, color: fg2, size: 16),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _confirmDelete(context, category),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.danger.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(LucideIcons.trash2, color: AppColors.danger, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  bool get isDark => widget.isDarkMode;

  void _showCategoryBottomSheet(BuildContext context, HabitCategory? category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CategoryBottomSheet(
        isDarkMode: widget.isDarkMode,
        category: category,
        categoriesService: _categoriesService,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, HabitCategory category) async {
    final habitsInCategory = await _categoriesService.getHabitsByCategoryColor(category.colorHex);
    final isDark = widget.isDarkMode;
    final bg = isDark ? AppColors.darkBgCardSolid : Colors.white;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: bg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.danger.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(LucideIcons.trash2, color: AppColors.danger, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Delete "${category.name}"?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: fg1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'This will permanently delete:',
                style: TextStyle(fontSize: 14, color: fg2),
              ),
              const SizedBox(height: 12),
              ...habitsInCategory.take(3).map((h) => Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Row(
                      children: [
                        Icon(LucideIcons.check, color: AppColors.danger, size: 14),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            h.name,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: fg1),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  )),
              if (habitsInCategory.length > 3)
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: Text(
                    'and ${habitsInCategory.length - 3} more habits',
                    style: TextStyle(fontSize: 13, color: fg2, fontStyle: FontStyle.italic),
                  ),
                ),
              if (habitsInCategory.isNotEmpty) const SizedBox(height: 8),
              Text(
                'This action cannot be undone.',
                style: TextStyle(fontSize: 13, color: fg2, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkBgCard : Colors.grey[200],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: fg1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pop(ctx);
                        await _categoriesService.deleteCategoryAndHabits(category.id);
                        if (mounted) {
                          final cats = await _categoriesService.getCategories();
                          if (mounted) setState(() => _categories = cats);
                        }
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.danger,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            'Delete',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryBottomSheet extends StatefulWidget {
  final bool isDarkMode;
  final HabitCategory? category;
  final HabitCategoriesService categoriesService;

  const _CategoryBottomSheet({
    required this.isDarkMode,
    this.category,
    required this.categoriesService,
  });

  @override
  State<_CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<_CategoryBottomSheet> {
  late final TextEditingController _nameController;
  late String _selectedIcon;
  late String _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _selectedIcon = widget.category?.iconName ?? 'heart';
    _selectedColor = widget.category?.colorHex ?? '#10B981';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'dumbbell': LucideIcons.dumbbell,
      'leaf': LucideIcons.leaf,
      'bed': LucideIcons.bed,
      'brain': LucideIcons.brain,
      'users': LucideIcons.users,
      'palette': LucideIcons.palette,
      'heart': LucideIcons.heart,
      'zap': LucideIcons.zap,
      'target': LucideIcons.target,
      'flame': LucideIcons.flame,
      'droplet': LucideIcons.droplet,
      'pill': LucideIcons.pill,
      'sun': LucideIcons.sun,
      'moon': LucideIcons.moon,
      'coffee': LucideIcons.coffee,
      'music': LucideIcons.music,
      'book': LucideIcons.book,
    };
    return iconMap[iconName] ?? LucideIcons.check;
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
    final bg = isDark ? AppColors.darkBgApp : Colors.white;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final cardBg = isDark ? AppColors.darkBgCard : Colors.grey[100]!;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
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
            widget.category == null ? 'New Category' : 'Edit Category',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: fg1),
          ),
          const SizedBox(height: 24),
          Text('Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: fg2)),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            style: TextStyle(color: fg1, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Category name',
              hintStyle: TextStyle(color: fg2.withOpacity(0.5)),
              filled: true,
              fillColor: cardBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
          const SizedBox(height: 20),
          Text('Icon', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: fg2)),
          const SizedBox(height: 12),
          SizedBox(
            height: 56,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: HabitCategoryConstants.availableIcons.length,
              itemBuilder: (context, index) {
                final iconName = HabitCategoryConstants.availableIcons[index];
                final isSelected = _selectedIcon == iconName;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = iconName),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? _parseColor(_selectedColor).withOpacity(0.2) : cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: isSelected
                          ? Border.all(color: _parseColor(_selectedColor), width: 2)
                          : null,
                    ),
                    child: Icon(
                      _getIconData(iconName),
                      color: isSelected ? _parseColor(_selectedColor) : fg2,
                      size: 22,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text('Color', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: fg2)),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: HabitCategoryConstants.availableColors.length,
              itemBuilder: (context, index) {
                final colorHex = HabitCategoryConstants.availableColors[index];
                final isSelected = _selectedColor == colorHex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = colorHex),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _parseColor(colorHex),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: fg1, width: 3)
                          : null,
                    ),
                    child: isSelected
                        ? Icon(LucideIcons.check, color: Colors.white, size: 18)
                        : null,
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _nameController.text.trim().isEmpty
                  ? null
                  : () async {
                      final name = _nameController.text.trim();
                      final now = DateTime.now();

                      if (widget.category == null) {
                        final newCategory = HabitCategory(
                          id: '${now.millisecondsSinceEpoch}',
                          name: name,
                          iconName: _selectedIcon,
                          colorHex: _selectedColor,
                          createdAt: now,
                          sortOrder: 999,
                        );
                        await widget.categoriesService.addCategory(newCategory);
                      } else {
                        final updated = widget.category!.copyWith(
                          name: name,
                          iconName: _selectedIcon,
                          colorHex: _selectedColor,
                        );
                        await widget.categoriesService.updateCategory(updated);
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
                widget.category == null ? 'Create Category' : 'Save Changes',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}