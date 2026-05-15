import 'package:flutter/material.dart';
import 'package:fitnesspal/core/theme/colors.dart';
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

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bgApp = isDark ? AppColors.darkBgApp : AppColors.lightBgApp;
    final bgTab = isDark ? AppColors.darkBgTab : AppColors.lightBgTab;
    final fg3 = isDark ? AppColors.darkFg3 : AppColors.lightFg3;

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
            onPressed: () {},
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.accentSoft2 : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isActive ? activeColor : inactiveColor,
                size: 24,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isActive ? activeColor : inactiveColor,
                letterSpacing: 0.05,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
