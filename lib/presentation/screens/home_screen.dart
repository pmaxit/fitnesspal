import 'package:flutter/material.dart';
import 'package:fitnesspal/core/theme/colors.dart';
import 'package:fitnesspal/core/models/meal.dart';
import 'package:fitnesspal/core/services/firestore_service.dart';
import 'package:fitnesspal/presentation/screens/dashboard_screen.dart';
import 'package:fitnesspal/presentation/screens/activity_screen.dart';
import 'package:fitnesspal/presentation/screens/meals_screen.dart';
import 'package:fitnesspal/presentation/screens/habits_screen.dart';
import 'package:fitnesspal/presentation/screens/profile_screen.dart';

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
            child: const Icon(Icons.add, color: Colors.white),
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
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Row(
            children: [
              _navTab(0, Icons.home, 'Home'),
              _navTab(1, Icons.show_chart, 'Activity'),
              _navTab(2, Icons.restaurant, 'Meals'),
              _navTab(3, Icons.repeat, 'Habits'),
              _navTab(4, Icons.person, 'Profile'),
            ],
          ),
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
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.accentSoft2 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? activeColor : inactiveColor,
                size: 24,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isActive ? activeColor : inactiveColor,
                  letterSpacing: 0.05,
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: fg3,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Add Meal',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: fg1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                _sheetField(nameCtrl, 'Meal name', fg2, fg3, border),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _sheetField(calCtrl, 'Calories', fg2, fg3, border, keyboardType: TextInputType.number),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _sheetField(proteinCtrl, 'Protein (g)', fg2, fg3, border, keyboardType: TextInputType.number),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _sheetField(carbsCtrl, 'Carbs (g)', fg2, fg3, border, keyboardType: TextInputType.number),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _sheetField(fatCtrl, 'Fat (g)', fg2, fg3, border, keyboardType: TextInputType.number),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _sheetField(descCtrl, 'Description (optional)', fg2, fg3, border),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                      Navigator.pop(ctx);
                    },
                    child: const Text('Add Meal', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sheetField(
    TextEditingController ctrl,
    String hint,
    Color fg2,
    Color fg3,
    Color border, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      style: TextStyle(color: fg2, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: fg3, fontSize: 14),
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}
