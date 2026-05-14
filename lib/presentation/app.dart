import 'package:flutter/material.dart';
import 'package:fitnesspal/core/theme/app_theme.dart';
import 'package:fitnesspal/presentation/screens/home_screen.dart';

class FitnessPalApp extends StatefulWidget {
  const FitnessPalApp({Key? key}) : super(key: key);

  @override
  State<FitnessPalApp> createState() => _FitnessPalAppState();
}

class _FitnessPalAppState extends State<FitnessPalApp> {
  bool _isDarkMode = true;
  bool _isCompactDensity = false;

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
  }

  void _toggleDensity() {
    setState(() => _isCompactDensity = !_isCompactDensity);
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    final density = _isCompactDensity ? VisualDensity.compact : VisualDensity.standard;

    return MaterialApp(
      title: 'FitnessPal',
      theme: theme.copyWith(visualDensity: density),
      home: HomeScreen(
        isDarkMode: _isDarkMode,
        onThemeToggle: _toggleTheme,
        isCompactDensity: _isCompactDensity,
        onDensityToggle: _toggleDensity,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
