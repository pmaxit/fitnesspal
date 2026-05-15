import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitnesspal/core/theme/colors.dart';
import 'package:fitnesspal/core/models/meal.dart';
import 'package:fitnesspal/core/services/firestore_service.dart';
import 'package:fitnesspal/presentation/screens/dashboard_screen.dart';
import 'package:fitnesspal/presentation/screens/activity_screen.dart';
import 'package:fitnesspal/presentation/screens/meals_screen.dart';
import 'package:fitnesspal/presentation/screens/habits_screen.dart';
import 'package:fitnesspal/presentation/screens/profile_screen.dart';
import 'package:fitnesspal/core/data/indian_foods.dart';
import 'package:fitnesspal/core/models/activity.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final bool isCompactDensity;
  final VoidCallback onDensityToggle;

  const HomeScreen({
    Key? key,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.isCompactDensity,
    required this.onDensityToggle,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bgApp = isDark ? AppColors.darkBgApp : AppColors.lightBgApp;
    final bgTab = isDark ? AppColors.darkBgTab : AppColors.lightBgTab;

    final screens = [
      DashboardScreen(isDarkMode: isDark),
      ActivityScreen(isDarkMode: isDark),
      MealsScreen(isDarkMode: isDark),
      HabitsScreen(isDarkMode: isDark),
      ProfileScreen(isDarkMode: isDark),
    ];

    return Scaffold(
      backgroundColor: bgApp,
      body: screens[_selectedTab],
      floatingActionButton: _selectedTab == 2
        ? FloatingActionButton(
            backgroundColor: AppColors.accent,
            child: Icon(LucideIcons.plus, color: Colors.white),
            onPressed: _showAddMealSheet,
          )
        : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: bgTab,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
        ),
        child: Row(
          children: [
            _navTab(0, LucideIcons.home, 'Home'),
            _navTab(1, LucideIcons.activity, 'Activity'),
            _navTab(2, LucideIcons.leaf, 'Meals'),
            _navTab(3, LucideIcons.checkSquare, 'Habits'),
            _navTab(4, LucideIcons.user, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _navTab(int index, IconData icon, String label) {
    final isDark = widget.isDarkMode;
    final isActive = _selectedTab == index;
    final activeColor = AppColors.accent;
    final inactiveColor = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: EdgeInsets.only(top: 12, bottom: 12 + MediaQuery.of(context).padding.bottom),
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? activeColor : inactiveColor,
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isActive ? activeColor : inactiveColor,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddMealSheet() {
    final isDark = widget.isDarkMode;
    final bgCard = isDark ? AppColors.darkBgCard : AppColors.lightBgCard;
    final fg1 = isDark ? AppColors.darkFg1 : AppColors.lightFg1;
    final fg2 = isDark ? AppColors.darkFg2 : AppColors.lightFg2;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final nameCtrl = TextEditingController();
    final calCtrl = TextEditingController();
    final proteinCtrl = TextEditingController();
    final carbsCtrl = TextEditingController();
    final fatCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    void updateCalories() {
      final p = int.tryParse(proteinCtrl.text) ?? 0;
      final c = int.tryParse(carbsCtrl.text) ?? 0;
      final f = int.tryParse(fatCtrl.text) ?? 0;
      final total = (p * 4) + (c * 4) + (f * 9);
      if (total > 0) {
        calCtrl.text = total.toString();
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgCard,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: fg3.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Meal',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: fg1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.accentSoft2,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(LucideIcons.sparkles, size: 14, color: AppColors.accent),
                              const SizedBox(width: 4),
                              Text(
                                'AI Assistant ON',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search / Indian Foods Dropdown
                    Autocomplete<IndianFood>(
                      displayStringForOption: (option) => option.name,
                      optionsBuilder: (textEditingValue) {
                        if (textEditingValue.text.isEmpty) return const Iterable<IndianFood>.empty();
                        return indianFoodsDatabase.where((food) => food.name.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                      },
                      onSelected: (food) {
                        nameCtrl.text = food.name;
                        proteinCtrl.text = food.protein.toString();
                        carbsCtrl.text = food.carbs.toString();
                        fatCtrl.text = food.fat.toString();
                        calCtrl.text = food.calories.toString();
                        setSheetState(() {});
                      },
                      fieldViewBuilder: (ctx, ctrl, focus, onFieldSubmitted) {
                        return _sheetField(ctrl, 'Search Indian foods or enter name...', fg2, fg3, border, focusNode: focus);
                      },
                      optionsViewBuilder: (ctx, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4,
                            color: bgCard,
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: MediaQuery.of(ctx).size.width - 40,
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: options.length,
                                separatorBuilder: (ctx, i) => Divider(color: border, height: 1),
                                itemBuilder: (ctx, index) {
                                  final option = options.elementAt(index);
                                  return ListTile(
                                    title: Text(option.name, style: TextStyle(color: fg1, fontWeight: FontWeight.w600)),
                                    subtitle: Text('${option.calories} kcal • P:${option.protein}g C:${option.carbs}g F:${option.fat}g', style: TextStyle(color: fg3, fontSize: 12)),
                                    onTap: () => onSelected(option),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Media Section
                    Row(
                      children: [
                        _mediaButton(LucideIcons.camera, 'Add Photo', fg2, border, () {}),
                        const SizedBox(width: 12),
                        _mediaButton(LucideIcons.video, 'Add Video', fg2, border, () {}),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _stepperField(calCtrl, 'Calories', LucideIcons.flame, fg1, fg2, fg3, border, (val) => setSheetState(() {})),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _stepperField(proteinCtrl, 'Protein (g)', LucideIcons.dumbbell, fg1, fg2, fg3, border, (val) {
                            updateCalories();
                            setSheetState(() {});
                          }),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _stepperField(carbsCtrl, 'Carbs (g)', LucideIcons.croissant, fg1, fg2, fg3, border, (val) {
                            updateCalories();
                            setSheetState(() {});
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _stepperField(fatCtrl, 'Fat (g)', LucideIcons.droplets, fg1, fg2, fg3, border, (val) {
                      updateCalories();
                      setSheetState(() {});
                    }),
                    const SizedBox(height: 16),
                    _sheetField(descCtrl, 'Description (optional)', fg2, fg3, border),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          final name = nameCtrl.text.trim();
                          final cal = int.tryParse(calCtrl.text.trim());
                          final protein = int.tryParse(proteinCtrl.text.trim());
                          final carbs = int.tryParse(carbsCtrl.text.trim());
                          final fat = int.tryParse(fatCtrl.text.trim());

                          if (name.isEmpty || cal == null || protein == null || carbs == null || fat == null) return;

                          final meal = Meal(
                            id: '',
                            name: name,
                            calories: cal,
                            description: descCtrl.text.trim(),
                            proteinGrams: protein,
                            carbsGrams: carbs,
                            fatGrams: fat,
                            createdAt: DateTime.now(),
                          );

                          _firestoreService.addMeal(meal);

                          // Also add to activity log
                          final now = DateTime.now();
                          final hour12 = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
                          final amPm = now.hour >= 12 ? 'PM' : 'AM';
                          final activity = Activity(
                            id: '',
                            time: '$hour12:${now.minute.toString().padLeft(2, '0')} $amPm',
                            title: 'Meal: $name',
                            subtitle: '$cal kcal • P:${protein}g C:${carbs}g F:${fat}g',
                            icon: 'restaurant',
                            date: now,
                          );
                          _firestoreService.addActivity(activity);

                          Navigator.pop(ctx);
                        },
                        child: const Text('Save Meal Log', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _mediaButton(IconData icon, String label, Color fg2, Color border, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.accent, size: 24),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: fg2, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepperField(
    TextEditingController ctrl,
    String label,
    IconData icon,
    Color fg1,
    Color fg2,
    Color fg3,
    Color border,
    Function(int) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: fg3),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: fg2, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(LucideIcons.minus, size: 20),
                color: AppColors.accent,
                onPressed: () {
                  int val = int.tryParse(ctrl.text) ?? 0;
                  if (val > 0) {
                    val--;
                    ctrl.text = val.toString();
                    onChanged(val);
                  }
                },
              ),
              Expanded(
                child: TextField(
                  controller: ctrl,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: fg1, fontSize: 16, fontWeight: FontWeight.w700),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (s) => onChanged(int.tryParse(s) ?? 0),
                ),
              ),
              IconButton(
                icon: Icon(LucideIcons.plus, size: 20),
                color: AppColors.accent,
                onPressed: () {
                  int val = int.tryParse(ctrl.text) ?? 0;
                  val++;
                  ctrl.text = val.toString();
                  onChanged(val);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sheetField(
    TextEditingController ctrl,
    String hint,
    Color fg2,
    Color fg3,
    Color border, {
    TextInputType? keyboardType,
    FocusNode? focusNode,
  }) {
    return TextField(
      controller: ctrl,
      focusNode: focusNode,
      keyboardType: keyboardType,
      style: TextStyle(color: fg2, fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: fg3, fontSize: 14),
        filled: true,
        fillColor: Colors.black.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
