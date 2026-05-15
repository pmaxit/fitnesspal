import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitnesspal/core/services/seed_data.dart';
import 'package:fitnesspal/firebase_options.dart';
import 'package:fitnesspal/presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await seedDatabase();
  runApp(const FitnessPalApp());
}
