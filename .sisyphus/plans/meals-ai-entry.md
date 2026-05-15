# Plan: Meals AI Entry and UI Improvements

**Created:** 2026-05-15
**Status:** active

## Overview

Enhance the FitnessPal Meals screen with six improvements:
1. Fix bottom tab bar gap (expand to cover remaining screen height)
2. Make Add Meal modal fully opaque
3. Indian food database with typeahead autocomplete
4. Auto-calculate calories from macros
5. Touch +/− stepper controls on all numeric fields
6. Image/video media picker with AI-simulated extraction (Android/iOS, hybrid interface)

## Architecture Decisions

- **State management**: setState only — no new libraries
- **Food DB**: Seeded Dart list in lib/core/data/indian_foods.dart (no new DB dependency for v1)
- **AI extraction**: Hybrid interface — image_picker for media, simulated extraction autofill now, clean MealAiService interface for real OCR later
- **Calorie formula**: calories = (protein x 4) + (carbs x 4) + (fat x 9) — auto-computed when any macro changes
- **New packages**: image_picker only (add to pubspec.yaml)
- **Platform scope**: Android/iOS only for media/AI features
- **Timestamp fix**: Meal.toFirestore() must write both createdAt AND timestamp fields so Firestore query orderBy('timestamp') works

## Files to Create

- lib/core/data/indian_foods.dart — seeded list of 50+ Indian foods with full nutrition
- lib/core/services/meal_ai_service.dart — AI extraction interface + mock implementation
- lib/presentation/widgets/numeric_stepper_field.dart — reusable +/- stepper widget
- lib/presentation/widgets/food_autocomplete_field.dart — typeahead search widget
- lib/presentation/widgets/meal_media_picker.dart — image/video picker widget

## Files to Modify

- pubspec.yaml — add image_picker
- lib/core/models/meal.dart — add imageUrl optional field; fix toFirestore() to write timestamp
- lib/presentation/screens/home_screen.dart — fix bottom nav gap; make modal opaque; replace Add Meal sheet with enhanced version
- lib/presentation/screens/meals_screen.dart — ensure SafeArea fills height correctly

## TODOs

- [ ] T1: Fix bottom tab bar gap — ensure Scaffold body fills remaining height; fix SafeArea/padding so no gap appears below tab bar
- [ ] T2: Make Add Meal modal fully opaque — set backgroundColor to solid bgCard color (no opacity), add barrierColor override
- [ ] T3: Create lib/core/data/indian_foods.dart with 50+ Indian foods (name, calories, protein, carbs, fat, category)
- [ ] T4: Fix Meal.toFirestore() to write timestamp: Timestamp.fromDate(createdAt) alongside createdAt so Firestore orderBy('timestamp') works
- [ ] T5: Add imageUrl optional field to Meal model with fromFirestore, toFirestore, copyWith support
- [ ] T6: Create lib/core/services/meal_ai_service.dart — abstract MealAiService interface + MockMealAiService that returns nutrition from Indian food DB lookup
- [ ] T7: Create lib/presentation/widgets/numeric_stepper_field.dart — widget with label, current value, minus and plus touch buttons, and optional text field; fires onChanged(int)
- [ ] T8: Create lib/presentation/widgets/food_autocomplete_field.dart — typeahead field that filters indianFoods list as user types, shows dropdown of matches, autofills all macro fields on selection
- [ ] T9: Create lib/presentation/widgets/meal_media_picker.dart — row of camera/gallery/video buttons; on pick calls MealAiService.extractFromMedia() and returns MealNutrition result
- [ ] T10: Rewrite _showAddMealSheet() in home_screen.dart to use all new widgets: FoodAutocompleteField, NumericStepperField for each macro, auto-calc calories, MealMediaPicker, opaque sheet
- [ ] T11: Add image_picker: ^1.1.2 to pubspec.yaml and run flutter pub get
- [ ] T12: Run flutter analyze and flutter test — fix all issues until both pass clean

## Final Verification Wave

- [ ] F1: flutter analyze exits 0 with zero issues
- [ ] F2: flutter test exits 0 with all tests passing
- [ ] F3: Manual code review — every new file reviewed for correctness, no stubs, no TODOs, no hardcoded values
- [ ] F4: QA checklist — bottom nav fills screen, modal is opaque, autocomplete filters Indian foods, steppers increment/decrement, media picker buttons present, calories auto-calculate
