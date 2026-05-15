import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnesspal/core/theme/app_theme.dart';
import 'package:fitnesspal/presentation/screens/home_screen.dart';
import 'package:fitnesspal/presentation/screens/auth/login_screen.dart';
import 'package:fitnesspal/core/services/auth_service.dart';
import 'package:fitnesspal/core/services/firestore_service.dart';

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
      home: StreamBuilder<User?>(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData && snapshot.data != null) {
            // Set the userId in FirestoreService
            FirestoreService().userId = snapshot.data!.uid;
            return HomeScreen(
              isDarkMode: _isDarkMode,
              onThemeToggle: _toggleTheme,
              isCompactDensity: _isCompactDensity,
              onDensityToggle: _toggleDensity,
            );
          }
          return LoginScreen(isDarkMode: _isDarkMode);
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
